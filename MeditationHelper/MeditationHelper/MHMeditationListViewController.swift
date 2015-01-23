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

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.parseClassName = MHMeditation.parseClassName()
    
    dateFormatter.locale = NSLocale(localeIdentifier: "zh_Hant")
    dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func queryForTable() -> PFQuery! {
    var query = MHMeditation.query()
    query.orderByDescending("endTime")
    return query
  }

  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    var cell = tableView.dequeueReusableCellWithIdentifier("MHMeditationCell") as MHMeditationCell!
    let meditation = object as MHMeditation
    cell.location.text = meditation.location
    cell.weather.text = meditation.weather
    cell.comment.text = meditation.comment
    cell.duration.text = meditation.duration()
    cell.rate.text = "評分: \(meditation.rate)"
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

//  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    super.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
//    let selectedObject = self.objectAtIndexPath(indexPath)
//  }

}
