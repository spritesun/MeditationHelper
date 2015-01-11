//
//  MHSaveRecordTableViewController
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import UIKit

class MHSaveRecordTableViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func cancel(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func save(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
