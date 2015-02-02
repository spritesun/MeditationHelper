//
// Created by Long Sun on 23/01/15.
// Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationListViewModel {
  var meditationsDict = [NSDate: [MHMeditation]]()
  var sortedKeys : [NSDate]
  var dateFormatter = NSDateFormatter()

  init(meditations : [MHMeditation]) {
    for meditation in meditations {
      var key = meditation.date()
      if meditationsDict[key] == nil {
        meditationsDict[key] = []
      }
      meditationsDict[key]?.append(meditation)
    }
    
    sortedKeys = meditationsDict.keys.array.sorted({$0.compare($1) == NSComparisonResult.OrderedDescending})
    
    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
    dateFormatter.dateFormat = "u年M月d日 ccc"
//    dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
  }

  func objectAtIndexPath(indexPath: NSIndexPath!) -> MHMeditation! {
    return meditationsDict[sortedKeys[indexPath.section]]![indexPath.row]
  }

  func numberOfSections() -> Int {
    return sortedKeys.count
  }

  func numberOfObjectsInSection(section: Int) -> Int {
    return meditationsDict[sortedKeys[section]]!.count
  }

  func titleForSection(section: Int) -> String {
    return dateFormatter.stringFromDate(sortedKeys[section])
  }
}
