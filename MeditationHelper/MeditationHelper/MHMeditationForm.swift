//
//  MHMeditationForm.swift
//  MeditationHelper
//
//  Created by Long Sun on 27/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationForm : NSObject, FXForm {

  var startTime: NSDate?
  var endTime: NSDate?
  var duration: String?
  var location: String?
  var weather: String?
  var rate: String?
  var comment: String?
  
  func fields() -> [AnyObject]! {
    return [
      [FXFormFieldHeader: "", FXFormFieldKey: "startTime", FXFormFieldTitle: "開始時間", FXFormFieldType: FXFormFieldTypeDateTime, FXFormFieldAction: "updateDuration"],
      [FXFormFieldKey: "endTime", FXFormFieldTitle: "結束時間", FXFormFieldType: FXFormFieldTypeDateTime, FXFormFieldAction: "updateDuration"],
      [FXFormFieldKey: "duration", FXFormFieldTitle: "時長", "textField.enabled": false, "textField.textColor": UIColor.lightGrayColor()],
      
      [FXFormFieldHeader: "", FXFormFieldKey: "location", FXFormFieldTitle: "地點", FXFormFieldPlaceholder:"例如: 家中"],
      [FXFormFieldKey: "weather", FXFormFieldTitle: "天氣", FXFormFieldPlaceholder:"例如: 晴天"],
      [FXFormFieldKey: "rate",
        FXFormFieldTitle: "評分",
        FXFormFieldOptions: ["1", "2", "3", "4", "5"],
        FXFormFieldCell: FXFormOptionSegmentsCell.self
      ],

      [FXFormFieldHeader:"" ,FXFormFieldKey: "comment", FXFormFieldTitle: "心得", FXFormFieldType: FXFormFieldTypeLongText]
    ]
  }
    
}
