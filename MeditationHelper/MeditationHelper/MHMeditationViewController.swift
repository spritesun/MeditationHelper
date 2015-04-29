//
//  MHMeditationViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import AVFoundation

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
  var audioPlayer : AVAudioPlayer!
  var soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tibetan-bell-low", ofType: "caf")!)
  
  
  let MHLastCountDown = "MHLastCountDown"
  let MHWelcomeMessageDisplayed = "MHWelcomeMessageDisplayed"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    resetTimeControl()
    audioPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: nil)
    audioPlayer.prepareToPlay()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    welcomeMessage()
  }
  
  func welcomeMessage() {
    var displayed = NSUserDefaults.standardUserDefaults().boolForKey(MHWelcomeMessageDisplayed)
    if displayed == false {
      var message = "- 建议每次打坐前，调至【飞行模式】，切断网络，以免受到电话，短信，各种提醒的惊扰。\n"
      message += "- 请不要调至【静音模式】，那样您就听不到下座的铃声了。\n"
      message += "- 请确认【允许推送通知】，以激活铃声\n"
      alert(title: "铃声说明", message: message)
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: MHWelcomeMessageDisplayed)
    }
  }
  
  func resetTimeControl() {
    var lastCountDown = NSUserDefaults.standardUserDefaults().doubleForKey(MHLastCountDown)
    if lastCountDown <= 0 {
      lastCountDown = 45 * TimeUtil.Minute
    }

    hourControl.color = MHTheme.mainBgColor
    hourControl.highlightColor = UIColor.lightGrayColor()
    hourControl.maxValue = 12
    hourControl.minutesOrSeconds = TimeUtil.hoursOf(lastCountDown)
    hourControl.titleLabel.text = NSLocalizedString("hour", comment: "Clock title hour")
    
    minControl.type = DDHTimerType.EqualElements
    minControl.color = UIColor.orangeColor()
    minControl.highlightColor = UIColor.lightGrayColor()
    minControl.minutesOrSeconds = TimeUtil.minutesOf(lastCountDown)
    minControl.titleLabel.text = NSLocalizedString("min", comment: "Clock title minute")
    
    secControl.type = DDHTimerType.Solid
    secControl.color = UIColor.purpleColor()
    secControl.minutesOrSeconds = 59
    secControl.titleLabel.text = NSLocalizedString("sec", comment: "Clock title seconds")
  }
  
  @IBAction func start(sender: AnyObject) {
    MHNotificationManager.setup()
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
    audioPlayer.play()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MHMeditationStop" {
      self.stop()
      let saveRecordVC = segue.destinationViewController.topViewController as! MHMeditationDetailsViewController
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
    audioPlayer.play()
  }
  
  func registerNotification() {
    let notification = UILocalNotification()
    notification.fireDate = endTime
    notification.alertBody = NSLocalizedString("Please come out softly", comment: "Notification alert message")
    notification.soundName = "tibetan-bell-low.caf"
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
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

