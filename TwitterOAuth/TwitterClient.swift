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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerkey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
