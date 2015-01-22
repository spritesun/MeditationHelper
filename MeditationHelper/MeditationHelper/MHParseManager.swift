//
//  MHParseManager.swift
//  MeditationHelper
//
//  Created by Long Sun on 22/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHParseManager {

  private init () {}

  static func setup (launchOptions: [NSObject: AnyObject]?) {
    ParseCrashReporting.enable()
    Parse.enableLocalDatastore() // will cause one warnBlockingOperationOnMainThread()
    Parse.setApplicationId("bkhHMDxhsLutFJpJi2HhAvhgoaPC3k2f1DgopU7Y", clientKey: "6XwgHrOVVTm44VqCtqc4k079plmRPx9zkUoGUnI1")
    PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil) // will cause another warnBlockingOperationOnMainThread()
    
    if (nil != PFUser.currentUser()) {
      var defaultACL = PFACL()
      PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
    }
  }
  
}
