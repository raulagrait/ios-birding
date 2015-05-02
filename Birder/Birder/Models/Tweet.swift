//
//  Tweet.swift
//  Birder
//
//  Created by Raul Agrait on 5/1/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var user: User?
 
    init(dictionary: NSDictionary) {
        
        let userDictionary = dictionary["user"] as! NSDictionary
        user = User(dictionary: userDictionary)
        
        text = dictionary["text"] as? String
        
        createdAtString = dictionary["created_at"] as?  String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y "
        createdAt = dateFormatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
