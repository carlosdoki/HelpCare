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
import UserNotificationsUI

let myBMSClient = BMSClient.sharedInstance
let push =  BMSPushClient.sharedInstance
let pushAppGUID = "43449690-8e31-4c50-844f-7fb25a1b357a"
let pushClientSecret = "666a746b-757c-4e69-ae71-6d98cb2bc69c"
let cloudRegion = BMSClient.Region.usSouth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMSPushObserver {


    var window: UIWindow?

    func getPushOptions() -> BMSPushClientOptions{
        let actionOne = BMSPushNotificationAction(identifierName: "FIRST", buttonTitle: "Accept", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionTwo = BMSPushNotificationAction(identifierName: "SECOND", buttonTitle: "Reject", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionThree = BMSPushNotificationAction(identifierName: "Third", buttonTitle: "Delete", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionFour = BMSPushNotificationAction(identifierName: "Fourth", buttonTitle: "View", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let actionFive = BMSPushNotificationAction(identifierName: "Fifth", buttonTitle: "Later", isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background)
        
        let category = BMSPushNotificationActionCategory(identifierName: "category", buttonActions: [actionOne, actionTwo])
        let categorySecond = BMSPushNotificationActionCategory(identifierName: "category1", buttonActions: [actionOne, actionTwo])
        let categoryThird = BMSPushNotificationActionCategory(identifierName: "category2", buttonActions: [actionOne, actionTwo,actionThree,actionFour,actionFive])
        
        let notifOptions = BMSPushClientOptions()
//        notifOptions.setDeviceId(deviceId: customeDeviceId)
        
//        notifOptions.setPushVariables(pushVariables: pushVariables)
        notifOptions.setInteractiveNotificationCategories(categoryName: [category,categorySecond,categoryThird])
        
        return notifOptions
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        myBMSClient.initialize(bluemixRegion: cloudRegion)
        let pushNotificationOptions = getPushOptions()

        push.initializeWithAppGUID(appGUID: pushAppGUID, clientSecret: pushClientSecret , options: pushNotificationOptions)
        push.delegate = self
        
        return true
    }
    
    func onChangePermission(status: Bool) {
        print("Push Notification is enabled:  \(status)" as NSString)
    }
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        
        
        push.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: "doki") { (response, statusCode, error) -> Void in
            if error.isEmpty {
                print( "Response during device registration : \(response)")
                print( "status code during device registration : \(statusCode)")
            } else{
                print( "Error during device registration \(error) ")
                print( "Error during device registration \n  - status code: \(statusCode) \n Error :\(error) \n")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
//        let push =  BMSPushClient.sharedInstance
        let respJson = (userInfo as NSDictionary).value(forKey: "payload") as! String
        let data = respJson.data(using: String.Encoding.utf8)
        
        let jsonResponse:NSDictionary = try! JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        let messageId:String = jsonResponse.value(forKey: "nid") as! String
        push.sendMessageDeliveryStatus(messageId: messageId) { (res, ss, ee) in
            print("Send message status to the Push server")
        }
    }
    
    // Send notification status when the app is in background mode.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let payLoad = ((((userInfo as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
//        self.showAlert(title: "Recieved Push notifications", message: payLoad)
        
//        let push =  BMSPushClient.sharedInstance
        
        let respJson = (userInfo as NSDictionary).value(forKey: "payload") as! String
        let data = respJson.data(using: String.Encoding.utf8)
        
        let jsonResponse:NSDictionary = try! JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        let messageId:String = jsonResponse.value(forKey: "nid") as! String
        push.sendMessageDeliveryStatus(messageId: messageId) { (res, ss, ee) in
            completionHandler(UIBackgroundFetchResult.newData)
        }
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
    }


}

