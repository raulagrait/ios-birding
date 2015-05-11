//
//  UserViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/11/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    var user:User?

    @IBOutlet weak var headerBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = user {
            
            if let backgroundImageUrlString = user.backgroundImageUrlString {

                let backgroundUrl = NSURL(string: backgroundImageUrlString)
                headerBackgroundImageView.setImageWithURL(backgroundUrl)
                
            }
            
            if let profileImageUrlString = user.profileImageUrlString {
                let profileUrl = NSURL(string: profileImageUrlString)
                profileImageView.setImageWithURL(profileUrl)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
