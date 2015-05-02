//
//  LoginViewController.swift
//  Birder
//
//  Created by Raul Agrait on 4/30/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "birder://oauth"), scope: nil, success: { (credential: BDBOAuth1Credential!) -> Void in
            
            println("got the request token")
            let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential.token)")!
            
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) -> Void in
            
            println("failed to get the request token")
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
