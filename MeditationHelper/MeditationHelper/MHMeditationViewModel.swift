//
//  MHMeditationViewModel.swift
//  MeditationHelper
//
//  Created by Long Sun on 23/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationViewModel {
  var meditation : MHMeditation
  
//  var loaction: String {
//    get {
//      if let location = meditation.location as String! {
//        return
//      }
//    }
//  }
  
  init (meditation : MHMeditation) {
    self.meditation = meditation
  }
}
