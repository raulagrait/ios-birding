//
//  AppDelegate.swift
//  Birder
//
//  Created by Raul Agrait on 4/30/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var menuViewController: UIViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        if let currentUser = User.currentUser {
            // Go to the logged in screen
            println("Current user detected: \(currentUser.name)")
            var vc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UIViewController
            window?.rootViewController = vc
            
            if let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as? UIViewController {
                self.menuViewController = menuViewController
                window?.insertSubview(menuViewController.view, belowSubview: vc.view)
                
                var gestureRecognizer = UIPanGestureRecognizer(target: self, action: "onLeftPan:")
                vc.view.addGestureRecognizer(gestureRecognizer)
            }
        }
        
        return true
    }
    
    var mainViewLeft: CGFloat = 0.0
    var maxNavWidth: CGFloat = 200.0
    
    func onLeftPan(recognizer: UIPanGestureRecognizer) {
        if let viewController = window?.rootViewController, view = viewController.view {
            var x = recognizer.locationInView(view)
            var velocity = recognizer.velocityInView(view)
            mainViewLeft = view.frame.minX
            
            var point = recognizer.translationInView(view)
            var left = mainViewLeft + point.x
            left = min(left, maxNavWidth)
            left = max(0, left)
            
            view.frame.origin.x = left
            
            if recognizer.state == .Ended || recognizer.state == .Cancelled {
                var finalX = left > maxNavWidth / 2.0 ? maxNavWidth : 0
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    view.frame.origin.x = finalX
                })
            }
        }
    }
    
    func closeLeftNav() {
        var finalX = 0.0
        if let viewController = window?.rootViewController, view = viewController.view {
            //UIView.animateWithDuration(0.5, animations: { () -> Void in
                view.frame.origin.x = 0
            //})
        }
    }
    
    func userDidLogout() {
        var vc = storyboard.instantiateInitialViewController() as! UIViewController
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        TwitterClient.sharedInstance.openUrl(url)
        return true
    }
    
}

