//
//  MHSaveRecordTableViewController
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHSaveRecordTableViewController: FormViewController, FormViewControllerDelegate {

  struct FormTag {
    static let duration = "duration"
    static let location = "location"
    static let weather = "weather"
    static let rate = "rate"
    static let comment = "comment"
  }
  
  var meditation: MHMeditation!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadForm()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self;
    setValue(meditation.duration(), forTag: FormTag.duration)
    setValue(3, forTag: FormTag.rate)
  }
  
  @IBAction func cancel(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func save(sender: AnyObject) {
    let values = self.form.formValues()
    meditation.location = values[FormTag.location] as? String
    meditation.weather = values[FormTag.weather] as? String
    meditation.rate = values[FormTag.rate] as Int
    meditation.comment = values[FormTag.comment] as? String
    
    meditation.pinInBackground()    
    if IJReachability.isConnectedToNetwork() && nil != PFUser.currentUser() {
      meditation.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
        if succeeded {
          self.meditation.unpinInBackground()
        }
      })
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: Private interface
  
  private func loadForm() {
    
    let form = FormDescriptor()
    
    form.title = "保存禪修記錄"
    
    let section1 = FormSectionDescriptor()
    
    var row: FormRowDescriptor! = FormRowDescriptor(tag: FormTag.duration, rowType: .Text, title: "時長")
    row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.enabled": false]
    section1.addRow(row)
    
    let section2 = FormSectionDescriptor()
    
    row = FormRowDescriptor(tag: FormTag.location, rowType: .Text, title: "地點")
    row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "例如: 家中", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
    section2.addRow(row)
    
    row = FormRowDescriptor(tag: FormTag.weather, rowType: .Text, title: "天氣")
    row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "例如: 晴天", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
    section2.addRow(row)
    
    let section3 = FormSectionDescriptor()
    
    row = FormRowDescriptor(tag: FormTag.rate, rowType: .SegmentedControl, title: "評分")
    row.configuration[FormRowDescriptor.Configuration.Options] = [1, 2, 3, 4, 5]
    section3.addRow(row)
    
    row = FormRowDescriptor(tag: FormTag.comment, rowType: .MultilineText, title: "心得")
    section3.addRow(row)
    
    form.sections = [section1, section2, section3]
    
    self.form = form
  }  
}
