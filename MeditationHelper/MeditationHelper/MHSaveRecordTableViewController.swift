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
  var isEditingMode = false
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadForm()
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
    
    delegate = self;
    setValue(meditation.duration(), forTag: FormTag.duration)

    setValue(meditation.location ?? "", forTag: FormTag.location)
    setValue(meditation.weather ?? "", forTag: FormTag.weather)
    setValue(meditation.rate, forTag: FormTag.rate)
    setValue(meditation.comment ?? "", forTag: FormTag.comment)
  }
  override func viewWillDisappear(animated: Bool) {
    save()
    super.viewWillDisappear(animated)
  }
  
  func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func save() {
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
    
    NSNotificationCenter.defaultCenter().postNotificationName(MHNotification.MeditationDidUpdate, object: nil)
    
    if !isEditingMode {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  // MARK: Private interface
  
  private func loadForm() {
    
    let form = FormDescriptor()
    
    form.title = title
    
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
    row.configuration[FormRowDescriptor.Configuration.Options] = [1, 2 ,3 ,4 ,5 ]
    row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
      return "  \(value)  "
      } as TitleFormatterClosure
    section3.addRow(row)
    
    row = FormRowDescriptor(tag: FormTag.comment, rowType: .MultilineText, title: "心得")
    section3.addRow(row)
    
    form.sections = [section1, section2, section3]
    
    self.form = form
  }  
}
