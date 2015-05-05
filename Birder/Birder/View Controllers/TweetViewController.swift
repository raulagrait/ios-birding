//
//  TweetViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/3/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    var tweet: Tweet?
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet, user = tweet.user {
            let url = NSURL(string: user.profileImageUrlString!)
            userImageView.setImageWithURL(url)
            
            nameLabel.text = user.name
            screenNameLabel.text = "@" + user.screenName!
            
            tweetLabel.text = tweet.text
            
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
            createdAtLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)

            updateControls()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }

    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        if let tweet = tweet {
            TwitterClient.sharedInstance.favoriteTweet(tweet, completion: { (tweet, error) -> Void in
                if error == nil {
                    self.updateControls()
                }
            })
        }
    }
    
    func updateControls() {
        if let tweet = tweet {
            favoriteButton.selected = tweet.favorited!
            retweetButton.selected = tweet.retweeted!
        }
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
