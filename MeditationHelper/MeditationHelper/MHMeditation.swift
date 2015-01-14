//
//  MHMeditation.swift
//  MeditationHelper
//
//  Created by Long Sun on 12/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditation {
  var startTime: NSDate!
  var endTime: NSDate?
  var rate = 0
  var weather: String?
  var locatoin: String?
  var geocode: CLLocationCoordinate2D?
  var tags = [String]()
  var comment: String?
  
  init()  {
  }
  
  func start() {
    startTime = NSDate()
  }
  
  func stop() {
    endTime = NSDate()
  }
  
}
