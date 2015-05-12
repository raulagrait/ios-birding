//
//  MenuViewController.swift
//  Birder
//
//  Created by Raul Agrait on 5/11/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {


    @IBOutlet weak var profileButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = User.currentUser {
            profileButton.setTitle(user.name, forState: UIControlState.Normal)
            profileButton.addTarget(self, action: "onProfileButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onProfileButtonTouched(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(navigateToCurrentUserNotification, object: self)
        closeLeftNav()
    }
    
    @IBAction func onHomeTimeline(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(navigateToHomeTimelineNotification, object: self)
        closeLeftNav()
    }
    
    func closeLeftNav() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.closeLeftNav()
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
