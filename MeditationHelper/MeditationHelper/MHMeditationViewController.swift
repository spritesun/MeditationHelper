//
//  MHMeditationViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationViewController: UIViewController {
  
  @IBOutlet var datePicker: UIDatePicker!
  
  @IBOutlet var startButton: UIButton!
  
  @IBOutlet var stopButton: UIButton!
  
  var meditation: MHMeditation!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func start(sender: AnyObject) {
    startButton.hidden = true
    stopButton.hidden = false
    registerNotification()

    meditation = MHMeditation()
    meditation.start()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MHMeditationStop" {
      self.stop()
      let saveRecordVC = segue.destinationViewController.topViewController as MHMeditationDetailsViewController
      saveRecordVC.meditation = meditation
    }
  }
  
  func stop() {
    startButton.hidden = false
    stopButton.hidden = true
    clearNotifications()
    
    meditation.stop()
  }
  
  func registerNotification() {
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: datePicker.countDownDuration)
    notification.alertBody = "請慢慢下座";
    notification.soundName = "tibetan-bell-low.caf";
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    println("alarm ready")
  }
  
  func clearNotifications() {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
}

