//
//  MHMigrator.swift
//  MeditationHelper
//
//  Created by Long Sun on 22/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHMigrator {
  private init () {}
  
  static func migrate () {
//    migrateMeditationCommentToCommentRaw()
  }
  
//  static func migrateMeditationCommentToCommentRaw() {
//    let query = MHMeditation.query()
//    query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
//      if error == nil {
//        for meditation in meditations as [MHMeditation] {
//          meditation.commentRaw = meditation.comment?.dataUsingEncoding(NSUTF8StringEncoding)
//          meditation.comment = nil
//          println("\(meditation) migrated")
//          meditation.saveInBackground()
//        }
//      }
//    })
//  }

}
