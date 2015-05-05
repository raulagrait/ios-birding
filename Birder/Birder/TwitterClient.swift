//
//  TwitterClient.swift
//  Birder
//
//  Created by Raul Agrait on 4/30/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

let TwitterConsumerKey = "LciTCN3yBk5ovAzFr6tRC5q8o"
let TwitterConsumerSecret = "DRMQit16Co0SIJa8PnOREM9eD5CVlKuLEdJ4zJdBtPdpRO4m6R"
let TwitterBaseUrl = "https://api.twitter.com"

class TwitterClient: BDBOAuth1RequestOperationManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: TwitterBaseUrl), consumerKey: TwitterConsumerKey, consumerSecret: TwitterConsumerSecret)
    
    var loginCompletion: ((user: User?, error: NSError?) -> Void)?
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> Void) {
        
        loginCompletion = completion
        
        requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "birder://oauth"), scope: nil,
            success: { (credential: BDBOAuth1Credential!) -> Void in
            
                println("got the request token")
                let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential.token)")!
            
                UIApplication.sharedApplication().openURL(authUrl)
            
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {

        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) -> Void in

            var tweets = Tweet.tweetsWithArray(responseObject as! [NSDictionary])            
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func postStatusUpdate(text: String, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = NSMutableDictionary()
        params["status"] = text
        
        POST("1.1/statuses/update.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                
                var tweet: Tweet? = nil
                if let dictionary = responseObject as? NSDictionary {
                    tweet = Tweet(dictionary: dictionary)
                    println("Tweet posted successfully")
                    println("tweet = \(tweet?.text) from \(tweet?.user?.name)")
                }
                completion(tweet: tweet, error: nil)
                
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error posting tweet")
                completion(tweet: nil, error: error)
        })
        
    }
    
    func favoriteTweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = NSMutableDictionary()
        params["id"] = NSNumber(longLong: tweet.id)
        
        POST("1.1/favorites/create.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                println("success favoriting tweet")
                tweet.favorited = true
                completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error favoriting tweet")
                completion(tweet: tweet, error: error)
        })
    }
    
    func openUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                println("Got the access token")
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                        if let dictionary = responseObject as? NSDictionary {
                            var user = User(dictionary: dictionary)
                            User.currentUser = user
                            println("current user: \(user.name)")
                            self.loginCompletion?(user: user, error: nil)
                        }
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("failed getting current user")
                        self.loginCompletion?(user: nil, error: error)
                })

            }, failure: { (error: NSError!) -> Void in
                println("Failed to get the access token")
                self.loginCompletion?(user: nil, error: error)
        })
    }
}