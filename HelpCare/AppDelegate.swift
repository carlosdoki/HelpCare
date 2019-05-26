//
//  AppDelegate.swift
//  HelpCare
//
//  Created by Lucas Dok on 25/05/19.
//  Copyright © 2019 Lucas Dok. All rights reserved.
//

import UIKit
import BMSCore
import BMSPush
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let myBMSClient = BMSClient.sharedInstance
        myBMSClient.initialize(bluemixRegion: BMSClient.Region.usSouth)
        myBMSClient.requestTimeout = 10.0 // seconds
        
        if let contents = Bundle.main.path(forResource:"BMSCredentials", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: contents) {
            let push = BMSPushClient.sharedInstance
            push.initializeWithAppGUID(appGUID: dictionary["pushAppGuid"] as! String, clientSecret: dictionary["pushClientSecret"] as! String)
        }
        
        
        
        return true
    }
    
    
    
    // Initialize IBM Cloud Push Notifications client SDK and register device.
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let push = BMSPushClient.sharedInstance
        
        // Replace USER_ID with a unique end user identifier. This enables specific push notification targeting.
        push.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            if error.isEmpty {
                print("Response during device registration : \(String(describing: response))")
                print("status code during device registration : \(String(describing: statusCode))")
            } else {
                print("Error during device registration \(error)")
                print("Error during device registration \n  - status code: \(String(describing: statusCode)) \n  - Error: \(error) \n")
            }
        }
    }
    
    // Alerts the user of a received push notification when the app is running in the foreground.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // UserInfo dictionary will contain data sent from the server.
        var userPayload = String()
        let payload = ((((userInfo as NSDictionary).value(forKey:"aps") as! NSDictionary).value(forKey:"alert") as! NSDictionary).value(forKey:"body") as! NSString)
        let additionalPayload = (userInfo as NSDictionary).value(forKey:"payload")
        userPayload = additionalPayload.debugDescription
        
        let alert = UIAlertController(title: "Push Notification Received",
                                      message: payload as String,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        application.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        print("Recieved IBM Cloud Push Notifications message: " + (payload as String) + ", payload: " + (userPayload as String))
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "UIWebViewTutorialBlog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

