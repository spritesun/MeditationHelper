//
//  MHMeditationViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import UIKit

class MHMeditationViewController: UIViewController {
  
  @IBOutlet var datePicker: UIDatePicker!
  
  @IBOutlet var controlButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func start(sender: AnyObject) {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    self.controlButton.selected = !self.controlButton.selected
    self.registerNotification()
    //    let saveRecordNC = self.storyboard?.instantiateViewControllerWithIdentifier("MHSaveRecordNavigationController") as UINavigationController
    //    self.presentViewController(saveRecordNC, animated: true, completion: nil)
  }
  
  func registerNotification() {
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: self.datePicker.countDownDuration)
    notification.alertBody = "請慢慢下座";
    notification.soundName = UILocalNotificationDefaultSoundName;
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    println("alarm ready")
  }
}

