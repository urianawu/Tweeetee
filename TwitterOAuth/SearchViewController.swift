//
//  SearchViewController.swift
//  TwitterOAuth
//
//  Created by you wu on 2/20/16.
//  Copyright © 2016 You Wu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchModeControl: UISegmentedControl!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var searchBar = UISearchBar()
    var tweetResults = [Tweet]()
    var userResults = [User]()
    var resultCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.hidden = true

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        menuButton.target = self.revealViewController()
        menuButton.action = Selector("revealToggle:")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultCount
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweetResults[indexPath.row]
        cell.replyButton.hidden = true
        cell.retweetButton.hidden = true
        cell.likeButton.hidden = true
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SearchUserCell", forIndexPath: indexPath) as! SearchUserCell
        cell.user = userResults[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = userResults[indexPath.row]
        TwitterClient.sharedInstance.userProfileMedias(user.screenName, completion: { (medias, error) -> () in
            user.medias = medias
            self.performSegueWithIdentifier("toUserProfileSegue", sender: user)
        })

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)  {
        tableView.hidden = true
        collectionView.hidden = true
        searchModeControl.hidden = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //do search
        if searchModeControl.selectedSegmentIndex == 1 {
            //search user
            TwitterClient.sharedInstance.searchUsersWithParams(searchBar.text!, params: nil) { (users, error) -> () in
                self.userResults = users!
                self.resultCount = self.userResults.count
                self.collectionView.reloadData()
            }

            collectionView.hidden = false
        }else {
            TwitterClient.sharedInstance.searchTweetsWithParams(searchBar.text!, params: nil) { (tweets, error) -> () in
                self.tweetResults = tweets!
                self.resultCount = self.tweetResults.count
                self.tableView.reloadData()
            }
            //search tweet
            tableView.hidden = false
        }
        searchModeControl.hidden = true
        searchBar.resignFirstResponder()


    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailTweetViewController = segue.destinationViewController as? DetailTweetViewController {
            detailTweetViewController.tweet = tweetResults[(tableView.indexPathForSelectedRow?.row)!]
        }
        if segue.identifier == "toUserProfileSegue" {
            let navViewController = segue.destinationViewController as! UINavigationController
            let profileViewController = navViewController.topViewController as! ProfileViewController
            profileViewController.user = sender as? User
        }
        
    }
    

}
