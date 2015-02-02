//
//  MHMeditationListViewController.swift
//  MeditationHelper
//
//  Created by Long Sun on 23/01/2015.
//  Copyright (c) 2015 Sunlong. All rights reserved.
//

class MHMeditationListViewController: PFQueryTableViewController {

  var viewModel = MHMeditationListViewModel(meditations: [MHMeditation]())
  var dateFormatter = NSDateFormatter()
  var needRefresh = false

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.parseClassName = MHMeditation.parseClassName()
    
    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
    dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "markAsNeedRefresh", name: MHNotification.MeditationDidUpdate, object: nil)
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if needRefresh {
      loadObjects()
      needRefresh = false
    }
  }
  
  func markAsNeedRefresh() {
    needRefresh = true
  }
  
  override func queryForTable() -> PFQuery! {
    var query = MHMeditation.currentUserQuery()
    query.orderByDescending("endTime")
    return query
  }

  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("MHMeditationCell") as MHMeditationCell!
    let meditation = object as MHMeditation
    cell.metadata.text = "\(meditation.location ?? String()) | \(meditation.weather ?? String()) | \(meditation.rate)分"
    cell.comment.text = meditation.comment
    cell.duration.text = meditation.duration()
    if meditation.startTime != nil && meditation.endTime != nil {
      cell.timeRange.text = "\(dateFormatter.stringFromDate(meditation.startTime!)) - \(dateFormatter.stringFromDate(meditation.endTime!))"

    }
    return cell
  }

  override func objectsDidLoad(error: NSError!) {
    super.objectsDidLoad(error)
    viewModel = MHMeditationListViewModel(meditations: objects as [MHMeditation])
    tableView.reloadData()
  }

  override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
    return viewModel.objectAtIndexPath(indexPath)
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfObjectsInSection(section)
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.titleForSection(section)
  }

  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }

  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == UITableViewCellEditingStyle.Delete {
      var meditation = objectAtIndexPath(indexPath)
      if nil == PFUser.currentUser() {
        //unpin aysnc task, callback not been called properly everytime.
        meditation.unpinInBackground()
        println("==delete from local")
        self.loadObjects()
      } else {
        //repeat delete same thing again and again seems be handle properly by Parse
        meditation.deleteInBackgroundWithBlock({ (success, error) -> Void in
          if success {
            println("==delete from internet")
            self.loadObjects()
          }
        })
      }
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MHMeditationEdit" {
      let saveRecordVC = segue.destinationViewController as MHMeditationDetailsViewController
      saveRecordVC.meditation = objectAtIndexPath(tableView.indexPathForSelectedRow()) as MHMeditation
      saveRecordVC.mode = .Update
    } else if segue.identifier == "MHMeditationFreeformCreate" {
      let saveRecordVC = segue.destinationViewController.topViewController as MHMeditationDetailsViewController
      saveRecordVC.meditation = MHMeditation()
      saveRecordVC.mode = .FreeformCreate
    }
  }

}
