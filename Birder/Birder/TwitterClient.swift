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
    
    
}