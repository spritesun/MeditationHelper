//
//  MHDismissSegue.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

@objc(MHDismissSegue)
class MHDismissSegue: UIStoryboardSegue {
  override func perform() {
    sourceViewController.dismissViewControllerAnimated(true, completion: nil)
  }
}
