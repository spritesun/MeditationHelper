//
//  MHMeditation.swift
//  MeditationHelper
//
//  Created by Long Sun on 12/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import Foundation

class MHMeditation : PFObject, PFSubclassing, Printable {
  @NSManaged var startTime: NSDate?
  @NSManaged var endTime: NSDate?
  @NSManaged var rate: Int
  @NSManaged var weather: String?
  @NSManaged var location: String?
  @NSManaged var geocode: CLLocationCoordinate2D
  @NSManaged var tags: [String]?
  @NSManaged private var commentRaw: NSData?
  var uploading = false

  var comment: String? {
    get {
      if let commentRaw = self.commentRaw as NSData! {
        return NSString(data:commentRaw, encoding: NSUTF8StringEncoding) as String?
      }
      return nil
    }
    set {
      commentRaw = newValue?.dataUsingEncoding(NSUTF8StringEncoding)
    }
  }

  override class func initialize() {
    var onceToken : dispatch_once_t = 0;
    dispatch_once(&onceToken) {
      self.registerSubclass()
    }
  }
  class func parseClassName() -> String! {
    return "MHMeditation"
  }
  
  override init() {
    super.init()
  }
  
  func start() {
    startTime = NSDate()
  }
  
  func stop() {
    endTime = NSDate()
    rate = 3
  }
    
  func shortDuration() -> String {
    if endTime == nil || startTime == nil {
      return "-"
    } else {
      return "\((Int)(endTime!.timeIntervalSinceDate(startTime!) / 60))"
    }
  }
  
  // Should be in meditation view model 
  func duration() -> String {
    if endTime == nil || startTime == nil {
      return ""
    } else {
      return String(format: NSLocalizedString("%@ Minutes", comment: "Duration Minutes"), shortDuration())
    }
  }
  
  func dateWithoutTime() -> NSDate {
    if let endTime = self.endTime {
      let calendar = CFCalendarCopyCurrent() as NSCalendar
      let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: endTime)
      return calendar.dateFromComponents(components)!
    } else {
      return createdAt
    }    
  }
  
  class func currentUserQuery() -> PFQuery {
    var query = MHMeditation.query()
    if nil == PFUser.currentUser() {
      query.fromLocalDatastore()
    }
    return query;
  }
  
}
