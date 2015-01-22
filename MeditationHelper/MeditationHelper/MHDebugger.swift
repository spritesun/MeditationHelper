//
//  MHDebugger.swift
//  MeditationHelper
//
//  Created by Long Sun on 22/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHDebugger {
  private init () {}
  
  static func printLocalMeditaions () {
    let query = MHMeditation.query()
    query.fromLocalDatastore()
    query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
      if error == nil {
        println("There is \(meditations.count) meditations not saved yet.\n\(meditations)")
      }
    })
  }
  
}