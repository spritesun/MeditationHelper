//
//  MHAlert.swift
//  MeditationHelper
//
//  Created by Long Sun on 3/02/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

extension UIViewController {
  func alert(#title : String, message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert confirm"), style: .Default, handler: nil))
    presentViewController(alert, animated: true) {}

  }
}
