//
//  TimeUtil.swift
//  MeditationHelper
//
//  Created by Long Sun on 30/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import Foundation

struct TimeUtil {
  static let Hour : NSTimeInterval = 60 * 60
  static let Minute : NSTimeInterval = 60

  static func hoursOf(interval : NSTimeInterval) -> Int {
    return Int(interval / Hour)
  }
  
  static func minutesOf(interval : NSTimeInterval) -> Int {
    return Int((interval % Hour) / Minute)
  }

  static func secondsOf(interval : NSTimeInterval) -> Int {
    return Int(interval % Minute)
  }

}