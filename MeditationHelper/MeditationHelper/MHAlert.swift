//
//  MHAlert.swift
//  MeditationHelper
//
//  Created by Long Sun on 3/02/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

extension UIViewController {
  func alert(#title : String, message : String) {
    if isAtLeastiOS8() {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert confirm"), style: .Default, handler: nil))
      presentViewController(alert, animated: true) {}
    } else {
      let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "Alert confirm"))
      alert.show()
    }
  }
  
  func isAtLeastiOS8() -> Bool {
    return floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1;
  }
  
}
