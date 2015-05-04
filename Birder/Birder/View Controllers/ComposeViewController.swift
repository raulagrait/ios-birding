//
//  ComposeViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/3/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextView.text = ""
        tweetTextView.becomeFirstResponder()
        
        if let user = User.currentUser {
            let url = NSURL(string: user.profileImageUrlString!)
            userImageView.setImageWithURL(url)
            nameLabel.text = user.name
            screenNameLabel.text = "@" + user.screenName!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelTouched(sender: AnyObject) {
        closeModal()
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        var text = tweetTextView.text
        TwitterClient.sharedInstance.postStatusUpdate(text, completion: { (tweet: Tweet?, error: NSError?) -> Void in
            if error == nil {
                var userInfo = [NSObject: AnyObject]()
                userInfo["tweet"] = tweet
                NSNotificationCenter.defaultCenter().postNotificationName(newTweetNotification, object: self, userInfo: userInfo)
                self.closeModal()
            } else {
                // Show an alert or something
            }
        })
    }
    
    func closeModal() {
        dismissViewControllerAnimated(true, completion: nil)
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
