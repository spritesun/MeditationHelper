//
//  MHNotificationManager.swift
//  MeditationHelper
//
//  Created by Long Sun on 22/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHNotificationManager {
  
  private init () {}
  
  static func setup () {
    if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:")))
    {
      UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert, categories: nil))
    }
  }
}
