//
//  AppDelegate.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    ParseCrashReporting.enable()
    Parse.enableLocalDatastore()
    Parse.setApplicationId("bkhHMDxhsLutFJpJi2HhAvhgoaPC3k2f1DgopU7Y", clientKey: "6XwgHrOVVTm44VqCtqc4k079plmRPx9zkUoGUnI1")
    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    
    if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")))
    {
      application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
    }
    else
    {
      //do iOS 7 stuff, which is pretty much nothing for local notifications.
    }
    return true
  }
}

