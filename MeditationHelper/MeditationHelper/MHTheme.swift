//
//  MHTheme.swift
//  MeditationHelper
//
//  Created by Long Sun on 30/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHTheme {
  static let mainBgColor = UIColor(red: 68.0 / 255.0, green: 110.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0)
  static let mainTextColor = UIColor(white: 0.95, alpha: 1.0)
  
  static func setup (window : UIWindow?) {
//    NSUserDefaults.standardUserDefaults().setObject(["zh"], forKey: "AppleLanguages")
//    NSUserDefaults.standardUserDefaults().synchronize()
    
    window?.tintColor = mainBgColor
    
    let tabBar = UITabBar.appearance()
    tabBar.tintColor = mainTextColor
    tabBar.barTintColor = mainBgColor
    
    let textColor = UIColor(white: 184.0 / 255.0, alpha: 1)
    let tabBarItem = UITabBarItem.appearance()
    tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: textColor], forState: .Normal)
    tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: mainTextColor], forState: .Selected)
  }
}

class MHTabBarController: UITabBarController {
  
  override func awakeFromNib() {
    for vc in viewControllers as [UIViewController] {
      vc.tabBarItem.image = vc.tabBarItem.image?.imageWithRenderingMode(.AlwaysOriginal)
    }
  }
  
}
