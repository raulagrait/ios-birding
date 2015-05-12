//
//  TweetCell.swift
//  Birder
//
//  Created by Raul Agrait on 5/2/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet? {
        didSet {
            updateButtons()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onImageTouched")
        userImageView.addGestureRecognizer(tapGestureRecognizer)
        userImageView.userInteractionEnabled = true

        self.contentView.layoutIfNeeded()
        updatePreferredMaxLayoutWidths()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        updatePreferredMaxLayoutWidths()
    }

    @IBAction func onFavorite(sender: AnyObject) {
        if let tweet = tweet {
            TwitterClient.sharedInstance.changeFavoriteStatus(onTweet: tweet, completion: { (tweet, error) -> Void in
                if error == nil {
                    self.updateButtons()
                }
            })
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if let tweet = tweet {
            if !(tweet.retweeted!) {
                var alert = UIAlertController(title: "Retweet", message: "Retweet to your followers?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Retweet", style: UIAlertActionStyle.Default, handler: onRetweetAlertAction))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: onRetweetAlertAction))
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                changeRetweetedStatus()
            }
        }
    }
    
    func onRetweetAlertAction(action: UIAlertAction!) {
        if action.style == UIAlertActionStyle.Default {
            changeRetweetedStatus()
        }
    }
    
    func changeRetweetedStatus() {
        if let tweet = tweet {
            TwitterClient.sharedInstance.changeRetweetedStatus(onTweet: tweet, completion: { (tweet, error) -> Void in
                if error == nil {
                    self.tweet = tweet
                    self.updateButtons()
                }
            })
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        var userInfo = [NSObject: AnyObject]()
        userInfo["tweet"] = tweet
        NSNotificationCenter.defaultCenter().postNotificationName(replyToTweetNotification, object: self, userInfo: userInfo)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updatePreferredMaxLayoutWidths() {
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    func updateButtons() {
        if let tweet = tweet {
            favoriteButton.selected = tweet.favorited!
            retweetButton.selected = tweet.retweeted!
        }
    }
    
    func onImageTouched() {
        var userInfo = [NSObject: AnyObject]()
        userInfo["tweet"] = tweet
        NSNotificationCenter.defaultCenter().postNotificationName(navigateToUserNotification, object: self, userInfo: userInfo)
    }
}