//
//  AppDelegate.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    ParseCrashReporting.enable()
    Parse.enableLocalDatastore() // will cause one warnBlockingOperationOnMainThread()
    Parse.setApplicationId("bkhHMDxhsLutFJpJi2HhAvhgoaPC3k2f1DgopU7Y", clientKey: "6XwgHrOVVTm44VqCtqc4k079plmRPx9zkUoGUnI1")
    PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil) // will cause another warnBlockingOperationOnMainThread()

    PFUser.enableAutomaticUser()
    var defaultACL = PFACL()
    // Optionally enable public read access while disabling public write access.
    // defaultACL.setPublicReadAccess(true)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
      PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
    })
    
    if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")))
    {
      application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
    }
    
    return true
  }
}

