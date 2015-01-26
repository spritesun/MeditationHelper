//
//  MHMeditation.swift
//  MeditationHelper
//
//  Created by Long Sun on 12/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditation : PFObject, PFSubclassing, Printable {
  @NSManaged var startTime: NSDate?
  @NSManaged var endTime: NSDate?
  @NSManaged var rate: Int
  @NSManaged var weather: String?
  @NSManaged var location: String?
  @NSManaged var geocode: CLLocationCoordinate2D
  @NSManaged var tags: [String]?
  @NSManaged private var commentRaw: NSData?

  var comment: String? {
    get {
      if let commentRaw = self.commentRaw as NSData! {
        return NSString(data:commentRaw, encoding: NSUTF8StringEncoding)
      }
      return nil
    }
    set {
      commentRaw = newValue?.dataUsingEncoding(NSUTF8StringEncoding)
    }
  }

  override class func load() {
    self.registerSubclass()
  }
  
  class func parseClassName() -> String! {
    return "MHMeditation"
  }
  
  func start() {
    startTime = NSDate()
  }
  
  func stop() {
    endTime = NSDate()
    rate = 3
  }
  
  // Should be in meditation view model 
  func duration() -> String {
    if endTime == nil || startTime == nil {
      return ""
    } else {
      return "\((Int)(endTime!.timeIntervalSinceDate(startTime!) / 60)) 分鐘"
    }
  }
  
  func date() -> NSDate {
    if let endTime = self.endTime? {
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
  
//  override var description : String {
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
//    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//    let str = dateFormatter.stringFromDate(NSDate())
//    var locationStr = ""
//    if location != nil {
//      locationStr = location!
//    }
//    return "開始時間: \(dateFormatter.stringFromDate(startTime?))\n結束時間: \(dateFormatter.stringFromDate(endTime?))\n地點: \(locationStr)\n天氣: \(weather)\n評分: \(rate)\n心得: \(comment)"
//  }

}
