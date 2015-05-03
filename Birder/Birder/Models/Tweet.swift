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
    
    var dateShortForm: String {
        get {
            if let difference = createdAt?.timeIntervalSinceNow {
                var secondsDifference = (difference as Double) * -1.0
                if secondsDifference < 60 * 60 {
                    let minutes = Int(secondsDifference / 60.0)
                    return "\(minutes)m"
                } else if secondsDifference < 60 * 60 * 24 {
                    let hours = Int(secondsDifference / 60 / 24)
                    return "\(hours)h"
                }
            }
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.stringFromDate(createdAt!)
        }
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
