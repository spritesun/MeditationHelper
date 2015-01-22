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
    
    let logInlogoView = UIImageView(image: UIImage(named: "logo"))
    logInlogoView.contentMode = UIViewContentMode.ScaleAspectFit
    logInView.logo = logInlogoView
    logInView.emailAsUsername = true
    delegate = self
    
    let signUpViewController = PFSignUpViewController()
    let signUplogoView = UIImageView(image: UIImage(named: "logo"))
    signUplogoView.contentMode = UIViewContentMode.ScaleAspectFit
    signUpViewController.signUpView.logo = signUplogoView
    signUpViewController.signUpView.emailAsUsername = true
    signUpViewController.delegate = self
    
    signUpController = signUpViewController
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    settingsVC = (presentingViewController as UITabBarController).selectedViewController as MHSettingsTableViewController? // keep a reference, when dismiss, parentVC will be nil.
  }
  
  func reloadSettingsTable () {
    settingsVC?.tableView.reloadData()
  }
  
  // MARK: PFLogInViewControllerDelegate
  
  func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
    if (!username.isEmpty && !password.isEmpty) {
      return true
    }
  
    let alert = UIAlertController(title: "Missing Information", message: "Please fill out all of the information", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    logInController.presentViewController(alert, animated: true) {}
    return false
  }
  
  func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
    dismissViewControllerAnimated(true, completion: reloadSettingsTable)
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
      let alert = UIAlertController(title: "Missing Information", message: "Please fill out all of the information", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      signUpController.presentViewController(alert, animated: true) {}
    }
    return informationComplete
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
    dismissViewControllerAnimated(true, completion: reloadSettingsTable)
  }
  
  func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
    println("fail to sign up, need track")
  }
  
  func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
    println("dismiss sign up, need track")
  }
}
