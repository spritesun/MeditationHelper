//
// Created by Long Sun on 23/01/15.
// Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationListViewModel {
  var meditationsDict = [NSDate: [AnyObject]]()
  var sortedKeys : [NSDate]
  var dateFormatter = NSDateFormatter()

  init(meditations : [MHMeditation]) {
    for meditation in meditations {
      var key = meditation.dateWithoutTime()
      if meditationsDict[key] == nil {
        meditationsDict[key] = []
      }
      meditationsDict[key]?.append(meditation)
    }
    
    sortedKeys = meditationsDict.keys.array.sorted({$0.compare($1) == NSComparisonResult.OrderedDescending})
    
//    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
    dateFormatter.dateFormat = "u-M-d ccc"
  }

  func objectAtIndexPath(indexPath: NSIndexPath!) -> AnyObject! {
    return meditationsDict[sortedKeys[indexPath.section]]![indexPath.row]
  }

  func numberOfSections() -> Int {
    return sortedKeys.count
  }

  func numberOfObjectsInSection(section: Int) -> Int {
    return meditationsDict[sortedKeys[section]]!.count
  }

  func titleForSection(section: Int) -> String {
    var dateKey = sortedKeys[section]
    var dateStr = dateFormatter.stringFromDate(dateKey)
    var sumTimeInterval = 0.0
    for object in meditationsDict[dateKey]! {
      if let meditation = object as? MHMeditation {
        sumTimeInterval += meditation.endTime!.timeIntervalSinceDate(meditation.startTime!)
      }
    }
    return String(format: NSLocalizedString("%@ | %dh%dm", comment: "Meditation list section title"), dateStr, TimeUtil.hoursOf(sumTimeInterval), TimeUtil.minutesOf(sumTimeInterval))
  }
}
