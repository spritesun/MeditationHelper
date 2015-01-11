//
//  MHMeditationViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import UIKit

class MHMeditationViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func start(sender: AnyObject) {
//    let saveRecordTVC = self.storyboard?.instantiateViewControllerWithIdentifier("MHSaveRecordTableViewController") as UIViewController

    let saveRecordNC = self.storyboard?.instantiateViewControllerWithIdentifier("MHSaveRecordNavigationController") as UINavigationController
//    saveRecordNC.pushViewController(saveRecordTVC, animated: false)

    self.presentViewController(saveRecordNC, animated: true, completion: nil)
  }
}

