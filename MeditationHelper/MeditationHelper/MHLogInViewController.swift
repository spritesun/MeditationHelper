//
//  MHLogInViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 22/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHLogInViewController: PFLogInViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

  var settingsVC : MHSettingsTableViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let logInlogoView = UIView()
    logInlogoView.contentMode = UIViewContentMode.ScaleAspectFit
    logInView.logo = logInlogoView
    logInView.emailAsUsername = true
    delegate = self
    
    let signUpViewController = PFSignUpViewController()
    let signUplogoView = UIView()
    signUplogoView.contentMode = UIViewContentMode.ScaleAspectFit
    signUpViewController.signUpView.logo = signUplogoView
    signUpViewController.signUpView.emailAsUsername = true
    signUpViewController.delegate = self
    
    signUpController = signUpViewController
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    settingsVC = (presentingViewController as! UITabBarController).selectedViewController as! MHSettingsTableViewController? // keep a reference, when dismiss, parentVC will be nil.
  }
  
  func reloadSettingsTable () {
    settingsVC?.tableView.reloadData()
  }
  
  // MARK: PFLogInViewControllerDelegate
  
  func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
    if (!username.isEmpty && !password.isEmpty) {
      return true
    }
  
    logInController.alert(title: NSLocalizedString("Please fill out your email/password", comment: "Fail to login/signup title"), message: "")
    return false
  }
  
  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    dismissViewControllerAnimated(true, completion: reloadSettingsTable)
    PFACL.setDefaultACL(PFACL(), withAccessForCurrentUser:true)
    let query = MHMeditation.query()
    query.fromLocalDatastore()
    query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
      if error == nil {
        for meditation in meditations as! [MHMeditation] {
          meditation.ACL = PFACL(user: PFUser.currentUser())
        }
      }
    })    
  }
  
  func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {

  }
  
  func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {

  }

  // MARK: PFSignUpViewControllerDelegate
  
  func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
    var informationComplete = true
    
    for (key, value) in info {
      if let strValue = value as? String {
        if (strValue.isEmpty) {
          informationComplete = false;
          break;
        }
      }
    }
    
    if (!informationComplete) {
      signUpController.alert(title: NSLocalizedString("Please fill out your email/password", comment: "Fail to login/signup title"), message: "")
    }
    return informationComplete
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
    settingsVC?.dismissViewControllerAnimated(true, completion: reloadSettingsTable)
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
  }
  
  func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
  }
}
