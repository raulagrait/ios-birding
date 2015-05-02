//
//  User.swift
//  Birder
//
//  Created by Raul Agrait on 5/1/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String
    var screenName: String
    var profileImageUrlString: String
    var tagline: String
   
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as! String
        screenName = dictionary["screen_name"] as! String
        profileImageUrlString = dictionary["profile_image_url"] as! String
        tagline = dictionary["description" ] as! String
        
        super.init()
        
        
    }
    
}
