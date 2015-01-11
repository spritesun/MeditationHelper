//
//  MHDismissSegue.swift
//  MeditationHelper
//
//  Created by Long Sun on 11/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import UIKit

@objc(MHDismissSegue)
class MHDismissSegue: UIStoryboardSegue {
    override func perform() {
        self.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
