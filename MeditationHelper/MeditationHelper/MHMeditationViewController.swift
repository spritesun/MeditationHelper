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

    PFAnalytics.trackEvent("startMeditation", dimensions: ["category": "mainUsage", "dayType": "weekday"])

  }
  
  @IBAction func stop(sender: AnyObject) {
    startButton.hidden = false
    stopButton.hidden = true
    clearNotifications()
    
    meditation.stop()
    meditation.pinInBackground()
    if IJReachability.isConnectedToNetwork() && nil != PFUser.currentUser() {
      meditation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
        if succeeded {
          self.meditation.unpinInBackground()
        }
      })
    }
    
   
    let alert = alertController("保存成功", message: "本次打坐: " + meditation.duration())
    self.presentViewController(alert, animated: true, completion: nil)
    
//    let saveRecordNC = storyboard?.instantiateViewControllerWithIdentifier("MHSaveRecordNavigationController") as UINavigationController
//    presentViewController(saveRecordNC, animated: true, completion: nil)
  }
  
  func alertController(title: String!, message:String!) -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) {action -> Void in}
    controller.addAction(OKAction)
    return controller
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

