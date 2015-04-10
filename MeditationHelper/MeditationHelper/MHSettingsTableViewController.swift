//
//  MHSettingsTableViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 14/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

import MessageUI;

class MHSettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
  
  // MARK: UITableViewDelegate & UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nil == PFUser.currentUser() ? 2 : 3
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell
    switch indexPath.row {
    case 0:
      if nil == PFUser.currentUser() {
        cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLoginCell") as! UITableViewCell
      } else {
        cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLogoutCell") as! UITableViewCell
        cell.detailTextLabel?.text = PFUser.currentUser().username
      }
    case 1:
      cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsFeedbackCell") as! UITableViewCell
    case 2:
      cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsUploadCell") as! UITableViewCell
    default:
      cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLoginCell") as! UITableViewCell
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      nil == PFUser.currentUser() ? presentLogin() : logout()
    case 1:
      feedback()
    case 2:
      MHMeditationUploader.upload(slient: false) {(sucess: Bool) -> Void in}
    default:
      println("Should never go here")
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: Login/Logout Cell
  func presentLogin() {
    let logInViewController = MHLogInViewController()        
    presentViewController(logInViewController, animated: true, completion: nil)
  }
  
  func logout() {
    PFUser.logOut()
    tableView.reloadData()
    MHMeditationUploader.upload(slient: true) {(sucess: Bool) -> Void in}
    PFACL.setDefaultACL(nil, withAccessForCurrentUser:true)
  }
  
  func feedback() {
    if MFMailComposeViewController.canSendMail() {
      var controller = MFMailComposeViewController()
      controller.mailComposeDelegate = self
      controller.setSubject(NSLocalizedString("Feedback for Zen Path", comment: "Feedback mail subject"))
      controller.setToRecipients(["zen.path.app@gmail.com"])
      controller.setMessageBody("", isHTML: false)
      presentViewController(controller, animated: true, completion: nil)
    }
    else
    {
      alert(title: NSLocalizedString("Please configure your email in Settings", comment: "Email not configured message title"), message: "")
    }
  }
  
  func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
    dismissViewControllerAnimated(true, completion: { () -> Void in
      if (result.value == MFMailComposeResultSent.value) {
        self.alert(title: NSLocalizedString("Thank you very much for your feedback", comment: "Feedback thanks title"), message: "")
      }
    })
    controller.delegate = nil
  }
}
