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
  @NSManaged var weather: String!
  @NSManaged var location: String!
  @NSManaged var geocode: CLLocationCoordinate2D
  @NSManaged var tags: [String]!
  @NSManaged var comment: String!
  
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
  
  func duration() -> String {
    return String((Int)(endTime.timeIntervalSinceDate(startTime) / 60) + 1) + "分鐘"
  }
  
  override var description : String {
    return "開始時間: \(startTime); 結束時間: \(endTime); 地點: \(location)"
  }

}
