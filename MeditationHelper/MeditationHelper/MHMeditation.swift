//
//  MHMeditation.swift
//  MeditationHelper
//
//  Created by Long Sun on 12/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditation : PFObject, PFSubclassing, Printable {
  @NSManaged var startTime: NSDate!
  @NSManaged var endTime: NSDate!
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
      return Optional.None
    }
    set {
      commentRaw = newValue?.dataUsingEncoding(NSUTF8StringEncoding)
    }
  }
  
  class override func load() {
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
    location = "家中"
  }
  
  // Should be in meditation view model 
  func duration() -> String {
    return "\((Int)(endTime.timeIntervalSinceDate(startTime) / 60)) 分鐘"
  }
  
  override var description : String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    let str = dateFormatter.stringFromDate(NSDate())
    var locationStr = ""
    if location != nil {
      locationStr = location!
    }
    return "開始時間: \(dateFormatter.stringFromDate(startTime))\n結束時間: \(dateFormatter.stringFromDate(endTime))\n地點: \(locationStr)\n天氣: \(weather)\n評分: \(rate)\n心得: \(comment)"
  }

}
