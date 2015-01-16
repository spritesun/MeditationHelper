//
//  MHSettingsTableViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 14/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHSettingsTableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
  
  // MARK: UITableViewDelegate & UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nil == PFUser.currentUser() ? 1 : 2
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell
    switch indexPath.row {
    case 0:
      if nil == PFUser.currentUser() {
        cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLoginCell") as UITableViewCell
      } else {
        cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLogoutCell") as UITableViewCell
        cell.detailTextLabel?.text = PFUser.currentUser().username
      }
    case 1:
      cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsUploadCell") as UITableViewCell
    default:
      cell = tableView.dequeueReusableCellWithIdentifier("MHSettingsLoginCell") as UITableViewCell
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      nil == PFUser.currentUser() ? presentLogin() : logout()
    case 1:
      upload()
    default:
      println("Should not go here")
    }
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  // MARK: Login/Logout Cell
  func presentLogin() {
    var logInViewController = PFLogInViewController()
    logInViewController.delegate = self
    
    var signUpViewController = PFSignUpViewController()
    signUpViewController.delegate = self
    
    logInViewController.signUpController = signUpViewController
    
    presentViewController(logInViewController, animated: true, completion: nil)
  }
  
  func logout() {
    PFUser.logOut()
    tableView.reloadData()
    upload()
    PFACL.setDefaultACL(nil, withAccessForCurrentUser:true)
  }
  
  // MARK: Upload
  func upload() {
    if nil != PFUser.currentUser() {
      let query = MHMeditation.query()
      query.fromLocalDatastore()
      query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
        if error == nil {
          for meditation in meditations as [MHMeditation] {
            meditation.saveEventually({ (successed, error) -> Void in
              if successed {
                meditation.unpinInBackground()
              }
            })
          }
        }
      })
    }
  }
  
  // MARK: PFLogInViewControllerDelegate
  
  func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
    if (!username.isEmpty && !password.isEmpty) {
      return true
    }
    
    let alert = alertController("Missing Information", message: "Please fill out all of the information")
    logInController.presentViewController(alert, animated: true) {}
    return false
  }
  
  func alertController(title: String!, message:String!) -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) {action -> Void in}
    controller.addAction(OKAction)
    return controller
  }
  
  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    dismissViewControllerAnimated(true, completion: {
      self.tableView.reloadData()
    })
    PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser:true)
    let query = MHMeditation.query()
    query.fromLocalDatastore()
    query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
      if error == nil {
        for meditation in meditations as [MHMeditation] {
          meditation.ACL = PFACL(user: PFUser.currentUser())
        }
      }
    })

  }
  
  func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
    println("fail to login, may need track")
  }
  
  func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
    println("User dismissed the logInViewController, may need track event")
  }
  
  // MARK: PFSignUpViewControllerDelegate
  
  func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : String]!) -> Bool {
    var informationComplete = true
    
    for (key, value) in info {
      if (value.isEmpty) {
        informationComplete = false;
        break;
      }
    }
    
    if (!informationComplete) {
      let alert = alertController("Missing Information", message: "Please fill out all of the information")
      signUpController.presentViewController(alert, animated: true) {}
      
    }
    return informationComplete
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
    dismissViewControllerAnimated(true, completion: {
      self.tableView.reloadData()
    })
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
    println("fail to sign up, need track")
  }
  
  func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
    println("dismiss sign up, need track")
  }
}
