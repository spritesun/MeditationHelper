//
//  MHMeditationUploader.swift
//  MeditationHelper
//
//  Created by Long Sun on 3/02/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHMeditationUploader {
  static func upload (slient silent : Bool, completion : ((success : Bool) -> Void)?) {
    if IJReachability.isConnectedToNetwork() && nil != PFUser.currentUser() {
      let query = MHMeditation.query()
      query.fromLocalDatastore()
      query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        if error == nil {
          if meditations.isEmpty {
            if !silent { vc?.alert(title: "沒有記錄需要同步", message: "") }
          }
          for meditation in meditations as [MHMeditation] {
            if !meditation.uploading {
              meditation.saveInBackgroundWithBlock({ (successed, error) -> Void in
                meditation.uploading = false
                if successed {
                  meditation.unpinInBackground()
                  if !silent { vc?.alert(title: "記錄同步成功", message: "") }
                } else {
                  if !silent { vc?.alert(title: "記錄同步失敗", message: "") }
                }
                completion?(success: successed)
              })
              meditation.uploading = true
            } else {
              if !silent { vc?.alert(title: "正在上傳", message: "") }
            }
          }
        }
      })
    }

  }
}
