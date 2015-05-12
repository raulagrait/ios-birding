//
//  TweetsViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/2/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

let newTweetNotification = "newTweetNotification"
let replyToTweetNotification = "replyToTweetNotification"
let navigateToUserNotification = "navigateToUserNotification"
let navigateToCurrentUserNotification = "navigateToCurrentUserNotification"
let navigateToHomeTimelineNotification = "navigateToHomeTimeline"

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewTweet:", name: newTweetNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onReplyToTweet:", name: replyToTweetNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNavigateToUser:", name: navigateToUserNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNavigateToCurrentUser:", name: navigateToCurrentUserNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNavigateToHomeTimeline:", name: navigateToHomeTimelineNotification, object: nil)
        
        initTableView()
        initRefreshControl()
        
        load(callback: animateMenu)
    }
    
    func animateMenu() {
        
        var destination = self.view.frame
        destination.origin.x += 26
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    func initRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    // MARK: - Event handlers

    @IBAction func onLogout(sender: AnyObject) {
         User.currentUser?.logout()
    }
    
    func onRefresh() {
        load(callback: onRefreshDone)
    }
    
    func onNewTweet(notification: NSNotification) {
        if let userInfo = notification.userInfo, tweet = userInfo["tweet"] as? Tweet {
            tweets?.insert(tweet, atIndex: 0)
            tableView.reloadData()
        }
    }
    
    func onReplyToTweet(notification: NSNotification) {
        if let userInfo = notification.userInfo, tweet = userInfo["tweet"] as? Tweet {
            
        }
    }
    
    func onNavigateToUser(notification: NSNotification) {
        if let userInfo = notification.userInfo, tweet = userInfo["tweet"] as? Tweet {
            navigateToUser(tweet.user)
        }
    }
    
    func onNavigateToCurrentUser(notification: NSNotification) {
        var currentUser = User.currentUser
        navigateToUser(currentUser)
    }
    
    func onNavigateToHomeTimeline(notification: NSNotification) {
        navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func navigateToUser(user: User?) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userViewController = storyboard.instantiateViewControllerWithIdentifier("UserViewController") as? UserViewController {
            userViewController.user = user
            navigationController?.pushViewController(userViewController, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = TweetCell()
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.accessoryType = UITableViewCellAccessoryType.None

        if let tweets = tweets {
            var tweetModel = tweets[indexPath.row]
            cell.tweet = tweetModel
            
            cell.tweetTextLabel.text = tweetModel.text
            cell.timeLabel.text = tweetModel.dateShortForm
        
            if let user = tweetModel.user {
                cell.userLabel.text = user.name
                cell.screenNameLabel.text = "@" + user.screenName!
                
                let userUrl = NSURL(string: user.profileImageUrlString!)
                cell.userImageView.setImageWithURL(userUrl)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // MARK: - Internal
    
    func onRefreshDone() {
        refreshControl.endRefreshing()
    }
    
    func load(callback: (() -> Void) = {}) {
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> Void in            
            self.tweets = tweets
            self.tableView.reloadData()
            callback()
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  let tweetViewController = segue.destinationViewController as? TweetViewController,
            let tweetCell = sender as? TweetCell,
            let indexPath = tableView.indexPathForCell(tweetCell) {
            if tweets?.count > indexPath.row {
                var tweet = tweets?[indexPath.row]
                tweetViewController.tweet = tweet
            }
        }
    }
}
