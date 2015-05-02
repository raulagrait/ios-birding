//
//  User.swift
//  Birder
//
//  Created by Raul Agrait on 5/1/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

var currentUserKey = "kCurrentUserKey"
var _currentUser: User?

class User: NSObject {
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData,
                   let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            var data: NSData? = nil
            
            if let user = user {
                data = NSJSONSerialization.dataWithJSONObject(user.dictionary, options: nil, error: nil)
            }
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var name: String?
    var screenName: String?
    var profileImageUrlString: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrlString = dictionary["profile_image_url"] as? String
        tagline = dictionary["description" ] as? String  
    }
}
