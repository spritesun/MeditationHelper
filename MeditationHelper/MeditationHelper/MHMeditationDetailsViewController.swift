//
//  MHMeditationDetailsViewController
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationDetailsViewController: FXFormViewController {

  struct FormTag {
    static let duration = "duration"
    static let location = "location"
    static let weather = "weather"
    static let rate = "rate"
    static let comment = "comment"
  }
  
  var meditation: MHMeditation!
  var isEditingMode = false
  
  override func awakeFromNib() {
    formController.form = MHMeditationForm()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if isEditingMode {
      navigationItem.hidesBackButton = false
      title = "修改禪修記錄"
    } else {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancel"))
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("save"))
      title = "保存禪修記錄"
    }

    var form  = formController.form as MHMeditationForm
    form.duration = meditation.duration()
    form.location = meditation.location
    form.weather = meditation.weather
    form.rate = String(meditation.rate)
    form.comment = meditation.comment
  }
  
  override func viewWillDisappear(animated: Bool) {
    if isEditingMode {
      save()
    }
    super.viewWillDisappear(animated)
  }
  
  func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func save() {
    var form = formController.form as MHMeditationForm
    meditation.location = form.location
    meditation.weather = form.weather
    meditation.rate = form.rate?.toInt() ?? 3
    meditation.comment = form.comment
    
    meditation.pinInBackground()    
    if IJReachability.isConnectedToNetwork() && nil != PFUser.currentUser() {
      meditation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
        if succeeded {
          self.meditation.unpinInBackground()
        }
      })
    }
    
    NSNotificationCenter.defaultCenter().postNotificationName(MHNotification.MeditationDidUpdate, object: nil)

    if !isEditingMode {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
}
