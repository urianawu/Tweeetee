//
//  TwitterClient.swift
//  TwitterOAuth
//
//  Created by you wu on 2/15/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerkey = "Yedmpn7BacoBa6ndhJOmjodnK"
let twitterConsumerSecret = "O26dSpJh5A6cF64p9ekDF8zo1xvz56LIIFqSB9B1jJgKQub1On"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerkey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        self.loginCompletion = completion
        
        //fetch request token 
        self.requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweeetee://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("failure")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func userProfile(screenName: String!, completion: (user: User?, error: NSError?) -> ()) {
        self.GET("1.1/users/show.json?screen_name="+String(screenName.characters.dropFirst()).lowercaseString, parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            completion(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(user: nil, error: error)
        })
        
    }

    func userProfileMedias(screenName: String!, completion: (medias: [NSURL]?, error: NSError?) -> ()) {
        self.GET("1.1/search/tweets.json?q=from%3A"+String(screenName.characters.dropFirst()).lowercaseString+"%20filter%3Aimages&include_entities=true&count=16", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            var medias = [NSURL]()
            if let tweets = response!["statuses"] as? [NSDictionary] {
            for tweet in tweets {
                if let media = (tweet["entities"])!["media"] as? [NSDictionary] {
                    for image in media {
                        medias.append(NSURL(string: image["media_url_https"] as! String)!)
                    }
                }
                
            }
            }
            completion(medias: medias, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(medias: nil, error: error)
        })

    }
    
    func userTimelineWithParams(screenName: String!, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        self.GET("1.1/statuses/user_timeline.json?screen_name="+String(screenName.characters.dropFirst()).lowercaseString, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(tweets: nil, error: error)
        })
        
    }

    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        self.GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("user: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func searchTweetsWithParams(term: String!, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        self.GET("https://api.twitter.com/1.1/search/tweets.json?q=" + term, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let statuses = response!["statuses"]
            let tweets = Tweet.tweetsWithArray(statuses as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(tweets: nil, error: error)
        }
    }

    func searchUsersWithParams(term: String!, params: NSDictionary?, completion: (users: [User]?, error: NSError?) -> ()) {
    
    
        self.GET("https://api.twitter.com/1.1/users/search.json?q=" + term, parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let users = User.usersWithArray(response as! [NSDictionary])
            completion(users: users, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error")
                completion(users: nil, error: error)
        }
    }

    func tweet(status: String!, params: NSDictionary?, completion: (error: NSError?) ->()) {
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        var paramsWithStatus = ["status": status]
        if params != nil {
            for (id, value) in params! {
                paramsWithStatus[id as! String] = value as! String
            }
        }
        self.POST(url, parameters: paramsWithStatus as NSDictionary, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion( error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("tweeting error")
                completion(error: error)
        }
    }

    
    func retweet(id: String!, completion: (error: NSError?) ->()) {
        let url = "https://api.twitter.com/1.1/statuses/retweet/" + id + ".json"
        self.POST(url, parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion( error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("retweeting error")
                completion(error: error)
        }
    }
    
    func unretweet(id: String!, completion: (error: NSError?) ->()) {
        
        let url = "https://api.twitter.com/1.1/statuses/unretweet/" + String(id) + ".json"
        self.POST(url, parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion( error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("unretweeting error")
                completion(error: error)
        }
    }

    func like(id: String!, completion: (error: NSError?) ->()) {
        let url = "https://api.twitter.com/1.1/favorites/create.json?id=" + id
        self.POST(url, parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(error: error)
        }
    }
    
    func unlike(id: String!, completion: (error: NSError?) ->()) {
        let url = "https://api.twitter.com/1.1/favorites/destroy.json?id=" + id
        self.POST(url, parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got access token")
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print(user.name)
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("fail to get current user error")
                    self.loginCompletion?(user: nil, error: error)

            })
            
        }) { (error: NSError!) -> Void in
            print("fail to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
