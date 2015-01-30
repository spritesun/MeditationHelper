//
//  MHMeditationViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationViewController: UIViewController {
  
  @IBOutlet var startButton: UIButton!
  @IBOutlet var stopButton: UIButton!
  @IBOutlet var hourControl: DDHTimerControl!
  @IBOutlet var minControl : DDHTimerControl!
  @IBOutlet var secControl: DDHTimerControl!
  @IBOutlet var remainLabel: UILabel!
  
  var meditation : MHMeditation!
  var endTime : NSDate!
  var timer: NSTimer?
  
  let MHLastCountDown = "MHLastCountDown"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resetTimeControl()
  }
  
  func resetTimeControl() {
    var lastCountDown = NSUserDefaults.standardUserDefaults().doubleForKey(MHLastCountDown)
    if lastCountDown <= 0 {
      lastCountDown = 45 * TimeUtil.Minute
    }

    hourControl.color = UIColor.darkGrayColor()
    hourControl.maxValue = 12
    hourControl.minutesOrSeconds = TimeUtil.hoursOf(lastCountDown)
    hourControl.titleLabel.text = "時"
    
    minControl.type = DDHTimerType.EqualElements
    minControl.color = UIColor.orangeColor()
    minControl.minutesOrSeconds = TimeUtil.minutesOf(lastCountDown)
    minControl.titleLabel.text = "分"
    
    secControl.type = DDHTimerType.Solid
    secControl.color = UIColor.grayColor()
    secControl.minutesOrSeconds = 59
    secControl.titleLabel.text = "秒"
  }
  
  @IBAction func start(sender: AnyObject) {
    startButton.hidden = true
    stopButton.hidden = false

    remainLabel.hidden = false
    hourControl.hidden = (hourControl.minutesOrSeconds == 0)
    secControl.hidden = false
    
    hourControl.userInteractionEnabled = false
    minControl.userInteractionEnabled = false

    var countDown = NSTimeInterval(hourControl.minutesOrSeconds) * TimeUtil.Hour + NSTimeInterval(minControl.minutesOrSeconds) * TimeUtil.Minute
    endTime = NSDate(timeIntervalSinceNow: countDown)
    
    registerNotification()
    fireTimer()

    meditation = MHMeditation()
    meditation.start()
    
    NSUserDefaults.standardUserDefaults().setDouble(countDown, forKey: MHLastCountDown)
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

    remainLabel.hidden = true
    hourControl.hidden = false
    secControl.hidden = true
    
    hourControl.userInteractionEnabled = true
    minControl.userInteractionEnabled = true

    clearNotifications()
    stopTimer()
    
    meditation.stop()

    resetTimeControl()
  }
  
  func registerNotification() {
    let notification = UILocalNotification()
    notification.fireDate = endTime
    notification.alertBody = "請慢慢下座";
    notification.soundName = "tibetan-bell-low.caf";
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    println("alarm ready")
  }
  
  func clearNotifications() {
    UIApplication.sharedApplication().cancelAllLocalNotifications()
  }
  
  func fireTimer() {
    timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("changeTimer:"), userInfo: nil, repeats: true)
  }
  
  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  func changeTimer(timer: NSTimer) {
    var countDown = endTime.timeIntervalSinceNow

    if countDown < 0 {
      stopTimer()
    }
    
    if !hourControl.hidden {
      hourControl.minutesOrSeconds = TimeUtil.hoursOf(countDown)
    }
    minControl.minutesOrSeconds = TimeUtil.minutesOf(countDown)
    secControl.minutesOrSeconds = TimeUtil.secondsOf(countDown)
  }
  
}

