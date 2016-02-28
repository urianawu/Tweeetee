//
//  TweetsViewController.swift
//  TwitterOAuth
//
//  Created by you wu on 2/16/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit
import SWRevealViewController
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var refreshingNeeded = false
    var tweets = [Tweet]()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var loadingCount = 20

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100


        //tableView.backgroundColor = UIColor.flatSkyBlueColor()

        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets!
                self.tableView.reloadData()
            }
        }
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
        
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // loading
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.contentView.layer.masksToBounds = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        //Add the recognizer to your view.
        cell.authorImageView.addGestureRecognizer(tapRecognizer)
        
        return cell
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreTweets()
            }
        }
    }
    
    func loadMoreTweets () {
        loadingCount += 20
        let param = ["count": loadingCount]
        TwitterClient.sharedInstance.homeTimelineWithParams(param) { (tweets, error) -> () in
            if tweets != nil {
            self.tweets = tweets!
            // Update flag
            self.isMoreDataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            }
        }

    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadingCount = 20

        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets!
                self.tableView.reloadData()
            refreshControl.endRefreshing()
            }
        }
    }
    
    func imageTapped(sender: AnyObject){
        let tappedView = sender.view as? UIImageView
        let cell = tappedView?.superview?.superview as! TweetCell
        let selectedIndex = self.tableView.indexPathForCell(cell)
        let screenName = tweets[(selectedIndex?.row)!].user!.screenName
        

        TwitterClient.sharedInstance.userProfile(screenName, completion: { (user, error) -> () in
            TwitterClient.sharedInstance.userProfileMedias(screenName) { (medias, error) -> () in
                user?.medias = medias
                self.performSegueWithIdentifier("toUserProfileSegue", sender: user)
            }
        })

    }
    
    @IBAction func oncloseCompose(segue: UIStoryboardSegue){
    }
    
    @IBAction func onFinishCompose(segue: UIStoryboardSegue) {
        if let vc = segue.sourceViewController as? ComposeViewController{
        TwitterClient.sharedInstance.tweet(vc.tweetView.text, params: nil, completion: { (error) -> () in
            TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
                if tweets != nil {
                    self.tweets = tweets!
                    self.tableView.reloadData()
                }
            }
        })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let composeViewController = segue.destinationViewController as? ComposeViewController {
            composeViewController.profileImageURL = (User.currentUser?.profileImageUrl)!
        }
        if segue.identifier == "toUserProfileSegue" {
            let navViewController = segue.destinationViewController as! UINavigationController
            let profileViewController = navViewController.topViewController as! ProfileViewController
            profileViewController.user = sender as? User
        }
    }
    

}
