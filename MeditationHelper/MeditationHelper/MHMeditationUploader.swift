//
//  MHMeditationUploader.swift
//  MeditationHelper
//
//  Created by Long Sun on 3/02/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

struct MHMeditationUploader {
  static func upload (slient silent : Bool, completion : ((success : Bool) -> Void)?) {
    var currentUser = PFUser.currentUser()
    if IJReachability.isConnectedToNetwork() && nil != currentUser {
      let query = MHMeditation.query()
      query.fromLocalDatastore()
      query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        if error == nil {
          if meditations.isEmpty {
            if !silent { vc?.alert(title: NSLocalizedString("No record need to upload", comment: "Uploader empty upload list title"), message: "") }
          }
          for meditation in meditations as! [MHMeditation] {
//            meditation.ACL = PFACL(user: currentUser)
            if !meditation.uploading {
              meditation.saveInBackgroundWithBlock({ (successed, error) -> Void in
                meditation.uploading = false
                if successed {
                  meditation.unpinInBackground()
                  if !silent { vc?.alert(title: NSLocalizedString("Upload successfully", comment: "Uploader upload success title"), message: "") }
                } else {
                  if !silent { vc?.alert(title: NSLocalizedString("Fail to upload", comment: "Uploader upload fail title"), message: "") }
                }
                completion?(success: successed)
              })
              meditation.uploading = true
            } else {
              if !silent { vc?.alert(title: NSLocalizedString("Uploading", comment: "Uploader uploading title"), message: "") }
            }
          }
        }
      })
    }

  }
}
