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
    MHParseManager.setup(launchOptions)
    //    MHDebugger.printLocalMeditaions()
    MHMigrator.migrate()
    MHTheme.setup(window)
    
    return true
  }
}

