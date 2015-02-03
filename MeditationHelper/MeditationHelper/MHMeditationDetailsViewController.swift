//
//  MHMeditationDetailsViewController
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationDetailsViewController: FXFormViewController {

  enum Mode {
    case Create, Update, FreeformCreate
  }
  
  struct FormTag {
    static let duration = "duration"
    static let location = "location"
    static let weather = "weather"
    static let rate = "rate"
    static let comment = "comment"
  }
  
  var meditation: MHMeditation!
  var mode : Mode = .Create

  override func awakeFromNib() {
    formController.form = MHMeditationForm()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch mode {
    case .Create, .FreeformCreate:
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("save"))
      title = "保存禪修記錄"
    case .Update:
      navigationItem.hidesBackButton = false
      title = "修改禪修記錄"
    default:
      println("error to be here")
    }

    var form  = formController.form as MHMeditationForm
    form.startTime = meditation.startTime
    form.endTime = meditation.endTime
    form.duration = meditation.duration()
    form.location = meditation.location
    form.weather = meditation.weather
    form.rate = String(meditation.rate)
    form.comment = meditation.comment
  }
    
  override func viewWillDisappear(animated: Bool) {
    if mode == .Update {
      save()
    }
    super.viewWillDisappear(animated)
  }
  
  func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func save() {
    if !isValid() {
      alert(title: "Missing Information", message: "開始/結束時間不能為空")
      return
    }
    var form = formController.form as MHMeditationForm
    meditation.startTime = form.startTime
    meditation.endTime = form.endTime
    meditation.location = form.location
    meditation.weather = form.weather
    meditation.rate = form.rate?.toInt() ?? 3
    meditation.comment = form.comment
    
    meditation.pinInBackground()
    MHMeditationUploader.upload(slient: true) {(sucess: Bool) -> Void in}
    
    NSNotificationCenter.defaultCenter().postNotificationName(MHNotification.MeditationDidUpdate, object: nil)

    if mode != .Update {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func isValid() -> Bool {
    var form = formController.form as MHMeditationForm
    return form.startTime != nil && form.endTime != nil
  }
  
  func updateDuration() {
    if isValid() {
      var form  = formController.form as MHMeditationForm
      meditation.startTime = form.startTime
      meditation.endTime = form.endTime
      form.duration = meditation.duration()
      var durationCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as FXFormBaseCell
      durationCell.update()
    }
  }

}
