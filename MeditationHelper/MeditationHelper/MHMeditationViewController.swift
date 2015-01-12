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
  
  @IBOutlet var startButton: UIButton!
  
  @IBOutlet var stopButton: UIButton!
  
  var meditation: MHMeditation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func start(sender: AnyObject) {
    self.startButton.hidden = true
    self.stopButton.hidden = false
    self.registerNotification()
    self.meditation = MHMeditation()
  }
  
  @IBAction func stop(sender: AnyObject) {
    self.startButton.hidden = false
    self.stopButton.hidden = true
    self.clearNotifications()
    let saveRecordNC = self.storyboard?.instantiateViewControllerWithIdentifier("MHSaveRecordNavigationController") as UINavigationController
    self.presentViewController(saveRecordNC, animated: true, completion: nil)
  }
  
  func registerNotification() {
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: self.datePicker.countDownDuration)
    notification.alertBody = "請慢慢下座";
    notification.soundName = UILocalNotificationDefaultSoundName;
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    println("alarm ready")
  }
  
  func clearNotifications() {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
}

