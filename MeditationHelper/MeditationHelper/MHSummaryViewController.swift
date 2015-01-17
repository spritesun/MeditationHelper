//
//  MHSummaryViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHSummaryViewController: UIViewController {
  
  @IBOutlet var historyContent: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    var query = MHMeditation.query()
    if !IJReachability.isConnectedToNetwork() {
      query.fromLocalDatastore()
    }
    query.orderByDescending("endTime")
    query.findObjectsInBackgroundWithBlock { (meditations, error) -> Void in
      if error == nil {
        var history = ""
        for meditation in meditations {
          history += meditation.description
          history += "\n"
        }
        self.historyContent.text = history
      }
    }
    
  }
}

