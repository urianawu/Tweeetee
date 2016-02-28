//
//  User.swift
//  TwitterOAuth
//
//  Created by you wu on 2/15/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
var _currentUser: User?
let currentUserKey = "kCurrentUser"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var profileBackgroundUrl: NSURL?
    var tagline: String?
    var medias: [NSURL]?
    
    var followingCount: Int? //friends_count
    var followersCount: Int? //followers_count
    var tweetsCount: Int? //statuses_count
    var following: Bool? //following
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = "@" + (dictionary["screen_name"] as? String)!
        profileImageUrl = NSURL(string: (dictionary["profile_image_url_https"] as! String))
        profileBackgroundUrl = NSURL(string: (dictionary["profile_background_image_url_https"] as! String))
        tagline = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        following = dictionary["following"] as? Bool
    }
    
    class func usersWithArray(array: [NSDictionary]) -> [User] {
        var users = [User]()
        
        for dictionary in array {
            users.append(User(dictionary: dictionary))
        }
        return users
    }

    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    }catch let error as NSError {
                        print(error.localizedDescription)
                    }

                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                let data = try NSJSONSerialization.dataWithJSONObject((user?.dictionary)!, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}
