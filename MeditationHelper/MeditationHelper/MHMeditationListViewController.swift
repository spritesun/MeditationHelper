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
  
  @IBOutlet var footer: UIView!
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.parseClassName = MHMeditation.parseClassName()
    
//    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
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
    MHMeditationUploader.upload(slient: true) { (success : Bool) -> Void in
      if success { self.reloadTable() }
    }
  }
    
  func reloadTable () {
    tableView.reloadData()
    updateFooter()
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
    var cell = tableView.dequeueReusableCellWithIdentifier("MHMeditationCell") as! MHMeditationCell!
    let meditation = object as! MHMeditation
    
    var metadata = ""
    if let location = meditation.location {
      metadata += (location + " | ")
    }
    if let weather = meditation.weather {
      metadata += (weather + " | ")
    }
    metadata += (String(meditation.rate) + NSLocalizedString("-star", comment: "star suffix"))
    
    cell.metadata.text = metadata
    
    cell.comment.text = meditation.comment
    cell.duration.text = meditation.shortDuration()
    if meditation.startTime != nil && meditation.endTime != nil {
      cell.timeRange.text = "\(dateFormatter.stringFromDate(meditation.startTime!)) - \(dateFormatter.stringFromDate(meditation.endTime!))"

    }
    return cell
  }
  
  override func objectsDidLoad(error: NSError!) {
    super.objectsDidLoad(error)
    if error == nil {
      viewModel = MHMeditationListViewModel(meditations: objects as! [MHMeditation])
      reloadTable()
    } else {
      alert(title: NSLocalizedString("Fail to load", comment: "Fail to load records title"), message: NSLocalizedString("Please check you network", comment: "Fail to load records message"))
    }
  }

  override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
    return viewModel.objectAtIndexPath(indexPath) as! PFObject!
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
        self.loadObjects()
      } else {
        //repeat delete same thing again and again seems be handle properly by Parse
        meditation.deleteInBackgroundWithBlock({ (success, error) -> Void in
          if success {
            self.loadObjects()
          }
        })
      }
    }
  }
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    if !footer.hidden && scrollView.contentOffset.y >= scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.height - footer.frame.height {
      if !loading {
        loadNextPage()
        updateFooter()
      }
    }
  }

  //Hack
  override func _shouldShowPaginationCell() -> Bool {
    return false;
  }
  
  func updateFooter() {
    footer.hidden = !super._shouldShowPaginationCell()
  }
  
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    var header = view as! UITableViewHeaderFooterView
//    header.contentView.backgroundColor = MHTheme.mainBgColor
    header.textLabel.textColor = MHTheme.mainBgColor
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "MHMeditationEdit" {
      let saveRecordVC = segue.destinationViewController as! MHMeditationDetailsViewController
      saveRecordVC.meditation = objectAtIndexPath(tableView.indexPathForSelectedRow()) as! MHMeditation
      saveRecordVC.mode = .Update
    } else if segue.identifier == "MHMeditationFreeformCreate" {
      let saveRecordVC = segue.destinationViewController.topViewController as! MHMeditationDetailsViewController
      saveRecordVC.meditation = MHMeditation()
      saveRecordVC.meditation.rate = 3
      saveRecordVC.mode = .FreeformCreate
    }
  }

}
