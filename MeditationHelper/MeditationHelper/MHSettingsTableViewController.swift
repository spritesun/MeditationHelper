//
//  MHSettingsTableViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 14/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHSettingsTableViewController: UITableViewController {
  
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
    upload()
    PFACL.setDefaultACL(nil, withAccessForCurrentUser:true)
  }
  
  // MARK: Upload
  func upload() {
    if IJReachability.isConnectedToNetwork() && nil != PFUser.currentUser() {
      let query = MHMeditation.query()
      query.fromLocalDatastore()
      query.findObjectsInBackgroundWithBlock({ (meditations, error) -> Void in
        if error == nil {
          for meditation in meditations as [MHMeditation] {
            meditation.saveInBackgroundWithBlock({ (successed, error) -> Void in
              if successed {
                meditation.unpinInBackground()
              }
            })
          }
        }
      })
    }
  }  

}
