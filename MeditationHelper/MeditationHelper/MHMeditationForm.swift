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
      [FXFormFieldHeader: "", FXFormFieldKey: "startTime", FXFormFieldTitle: NSLocalizedString("Start time", comment: "Form start time"), FXFormFieldType: FXFormFieldTypeDateTime, FXFormFieldAction: "updateDuration"],
      [FXFormFieldKey: "endTime", FXFormFieldTitle: NSLocalizedString("End time", comment: "Form end time"), FXFormFieldType: FXFormFieldTypeDateTime, FXFormFieldAction: "updateDuration"],
      [FXFormFieldKey: "duration", FXFormFieldTitle: NSLocalizedString("Duration", comment: "Form duration"), "textField.enabled": false, "textField.textColor": UIColor.lightGrayColor()],
      
      [FXFormFieldHeader: "", FXFormFieldKey: "location", FXFormFieldTitle: NSLocalizedString("Location", comment: "Form location"), FXFormFieldPlaceholder:NSLocalizedString("e.g. Home", comment: "Form location placeholder")],
      [FXFormFieldKey: "weather", FXFormFieldTitle: NSLocalizedString("Weather", comment: "Form weather"), FXFormFieldPlaceholder:NSLocalizedString("e.g. Sunny", comment: "Form weather placeholder")],
      [FXFormFieldKey: "rate",
        FXFormFieldTitle: NSLocalizedString("Rating", comment: "Form rate"),
        FXFormFieldOptions: ["1", "2", "3", "4", "5"],
        FXFormFieldCell: FXFormOptionSegmentsCell.self
      ],

      [FXFormFieldHeader:"" ,FXFormFieldKey: "comment", FXFormFieldTitle: NSLocalizedString("Comment", comment: "Form comment"), FXFormFieldType: FXFormFieldTypeLongText]
    ]
  }
    
}
