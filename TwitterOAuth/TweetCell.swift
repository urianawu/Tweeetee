//
//  TweetCell.swift
//  TwitterOAuth
//
//  Created by you wu on 2/20/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import ChameleonFramework

class TweetCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorScreennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var retweeted = false
    var liked = false
    var retweetCount: Int?
    var likeCount: Int?
    
    var tweet: Tweet! {
        didSet {
            if let url = tweet.user?.profileImageUrl {
                authorImageView.setImageWithURL(url)
            }
            authorNameLabel.text = tweet.user?.name
            authorScreennameLabel.text = tweet.user?.screenName
            tweetLabel.text = tweet.text
            timeLabel.text = tweet.timelineString
            
            retweetButton.setTitle(String(tweet.retweetCount!), forState: .Normal)
            likeButton.setTitle(String(tweet.likeCount!), forState: .Normal)
            retweeted = tweet.retweeted!
            liked = tweet.liked!
            retweetCount = tweet.retweetCount
            likeCount = tweet.likeCount
            setRetweetButton()
            setLikeButton()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        authorImageView.layer.cornerRadius = 4
        authorImageView.clipsToBounds = true
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.selectionStyle = .None
        // Configure the view for the selected state
    }
    @IBAction func onLikeButton(sender: AnyObject) {
        if (!liked) {
            TwitterClient.sharedInstance.like(tweet.id) { (error) -> () in
                self.likeCount! += 1
                self.liked = !self.liked
            }
        }else {
            TwitterClient.sharedInstance.unlike(tweet.id) { (error) -> () in
                self.likeCount! -= 1
                self.liked = !self.liked
            }
            
        }
        self.setLikeButton()
    }
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        if (!retweeted) {
            TwitterClient.sharedInstance.retweet(tweet.id) { (error) -> () in
                self.retweetCount! += 1
                self.retweeted = !self.retweeted
            }
        }else {
            TwitterClient.sharedInstance.unretweet(tweet.id) { (error) -> () in
                self.retweetCount! -= 1
                self.retweeted = !self.retweeted
            }

        }
        self.setRetweetButton()
    }

    func setRetweetButton() {
        self.retweetButton.setTitle(String(self.retweetCount!), forState: .Normal)
        if (retweeted) {
            self.retweetButton.tintColor = UIColor.flatGreenColorDark()
            self.retweetButton.setTitleColor(UIColor.flatGreenColorDark(), forState: .Normal)
        }else {
            self.retweetButton.tintColor = UIColor.flatSkyBlueColor()
            self.retweetButton.setTitleColor(UIColor.flatSkyBlueColor(), forState: .Normal)
        }
        
    }
    
    func setLikeButton() {
        self.likeButton.setTitle(String(self.likeCount!), forState: .Normal)
        if (liked) {
            self.likeButton.tintColor = UIColor.flatRedColor()
            self.likeButton.setTitleColor(UIColor.flatRedColor(), forState: .Normal)
        }else {
            self.likeButton.tintColor = UIColor.flatSkyBlueColor()
            self.likeButton.setTitleColor(UIColor.flatSkyBlueColor(), forState: .Normal)
        }
        
    }
    
}