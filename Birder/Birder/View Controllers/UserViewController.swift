//
//  UserViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/11/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var tweets: [Tweet]?

    @IBOutlet weak var headerBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = user {
            
            let numberFormatter = NSNumberFormatter()
            numberFormatter.locale = NSLocale.currentLocale()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            numberFormatter.usesGroupingSeparator = true

            if let backgroundImageUrlString = user.backgroundImageUrlString {
                let backgroundUrl = NSURL(string: backgroundImageUrlString)
                headerBackgroundImageView.setImageWithURL(backgroundUrl)
            }
            
            if let profileImageUrlString = user.profileImageUrlString {
                let profileUrl = NSURL(string: profileImageUrlString)
                profileImageView.setImageWithURL(profileUrl)
            }
            
            if let followersCount = user.followersCount {
                let formattedNumber = numberFormatter.stringFromNumber(NSNumber(integer: followersCount))
                followersCountLabel.text = formattedNumber
            }
            
            if let followingCount = user.followingCount {
                let formattedNumber = numberFormatter.stringFromNumber(NSNumber(integer: followingCount))
                followingCountLabel.text = formattedNumber
            }
            
            if let statusesCount = user.statusesCount {
                let formattedNumber = numberFormatter.stringFromNumber(NSNumber(integer: statusesCount))
                tweetCountLabel.text = formattedNumber
            }
            
            nameLabel.text = user.name
            
            if let screenName = user.screenName {
                screenNameLabel.text = "@" + screenName
            }
        }

        initTableView()
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UserTweetCell", forIndexPath: indexPath) as! TweetCell
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
    
    func load() {
        
        var params = NSMutableDictionary()
        if let user = user {
            params["screen_name"] = user.screenName
        }
        
        TwitterClient.sharedInstance.userTimelineWithParams(params, completion: { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    
    func initTableView() {
        
        //tableView.registerClass(TweetCell.self, forCellReuseIdentifier: "UserTweetCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
