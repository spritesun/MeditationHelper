//
//  MHTheme.swift
//  MeditationHelper
//
//  Created by Long Sun on 30/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHTheme {
  static let mainBgColor = UIColor(red: 68.0 / 255.0, green: 110.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
  static let mainTextColor = UIColor(white: 0.9, alpha: 1.0)
  
  static func setup (window : UIWindow?) {
    window?.tintColor = mainBgColor
    
    var tabBar = UITabBar.appearance()
    tabBar.tintColor = mainTextColor
    tabBar.barTintColor = mainBgColor
  }
}