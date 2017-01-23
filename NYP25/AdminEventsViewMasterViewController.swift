//
//  AdminEventsViewMasterViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class AdminEventsViewMasterViewController: UIViewController, UIToolbarDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, HideableHairlineViewController {
    @IBOutlet weak var segmentedControl : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!
    
    var isUpcoming = false
    var isPast = false
    var isDraft = false
    
    //For normal usage
    var eventsList : [Event] = []
    var filterList : [Event] = []
    
    //For searching purposes
    var searchList : [Event] = []
    var retainButtons : [UIBarButtonItem]? = nil
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchController.searchBar.delegate = self
        
        isUpcoming = true
        loadEvents()
    }
    
    @IBAction func searchButtonSelected(sender: Any){
        //For searching purposes
        retainButtons = self.navigationItem.rightBarButtonItems
        navigationItem.rightBarButtonItems = nil
        
        //Creating search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.titleView = searchController.searchBar
        searchController.isActive = true
        perform(#selector(showKeyboard), with: nil, afterDelay: 0.1)
    }
    
    func showKeyboard(){
        searchController.searchBar.becomeFirstResponder()
    }
    
    //Logic for filtering
    func filterEventsBy(searchText: String){
        searchList = filterList.filter({ (event) -> Bool in
            return (event.name?.lowercased().contains(searchText.lowercased()))!
        })

        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterEventsBy(searchText: searchController.searchBar.text!)
    }
    
    //When cancel search selected
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.title = "Events"
        navigationItem.rightBarButtonItems = retainButtons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideHairline()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        showHairline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    //Deciding which segmented control
    @IBAction func selectedSegmentWhere(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            isUpcoming = true
            isPast = false
            isDraft = false
        } else if sender.selectedSegmentIndex == 1{
            isUpcoming = false
            isPast = true
            isDraft = false
        } else {
            isUpcoming = false
            isPast = false
            isDraft = true
        }
        
        filterEvents()
        tableView.reloadData()
    }
    
    func loadEvents(){
        AdminEventDM.retrieveAllEvents { (listFromDb) in
            self.eventsList = listFromDb
            self.filterEvents()
        }
    }
    
    func filterEvents(){
        filterList = []
        
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        let formatDate = formatter.string(from: today)
        
        for event in eventsList{
            if isUpcoming{
                //When status is opened
                if event.status == "O"{
                    if event.date! >= formatDate{
                        filterList.append(event)
                    }
                }
            } else if isPast{
                //When status is opened and event is over
                if event.status == "O"{
                    if event.date! < formatDate{
                        filterList.append(event)
                    }
                }
            } else if isDraft{
                //When status is closed
                if event.status == "C"{
                    filterList.append(event)
                }
            }
        }
        
        filterList.sort { (a, b) -> Bool in
            if isUpcoming{
                if a.date! < b.date!{
                    return true
                }else{
                    return false
                }
            } else if isPast{
                if a.date! > b.date!{
                    return true
                }else{
                    return false
                }
            } else{
                return true
            }
        }
        
        if searchController.isActive && searchController.searchBar.text != ""{
            filterEventsBy(searchText: searchController.searchBar.text!)
        }

        tableView.reloadData()
    }
    
    
    //For table views
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return searchList.count
        }
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! AdminEventTableViewCell
        
        // Configure the cell...
        cell.eventImg.image = UIImage(named: "Ellipsis-100")
        let e : Event
        if searchController.isActive && searchController.searchBar.text != ""{
           e = searchList[(indexPath as IndexPath).row]
        }else{
           e = filterList[(indexPath as IndexPath).row]
        }
        cell.titleLabel.text = e.name
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        cell.titleLabel.minimumScaleFactor = 0.5
        cell.dateLabel.text = e.date
        if e.date != nil && e.startTime != nil{
            let day = GlobalDM.getDayNameBy(stringDate: e.date!)
            let time = GlobalDM.getTimeInHrBy(stringTime: e.startTime!)
            cell.dateLabel.text = "\(day) @ \(time)"
        }
        
        cell.locationLabel.text = e.address
        
        if(e.imageUrl != nil){
            loadEventImage(imageView: cell.eventImg, url: e.imageUrl!)
        }else{
            cell.eventImg.image = UIImage(named: "Ellipsis-100")
        }
 
        return cell
    }
    
    func loadEventImage(imageView: UIImageView, url: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let nurl = URL(string: url)
                var imageBinary : Data?
                if nurl != nil
                {
                    do
                    {
                        imageBinary = try Data(contentsOf: nurl!)
                    }
                    catch
                    {
                        return
                    }
                }
                
                DispatchQueue.main.async
                    {
                        var img : UIImage?
                        if imageBinary != nil
                        {
                            img = UIImage(data: imageBinary!)
                        }
                        
                        imageView.image = img
                        
                }
                
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowEventDetail"{
            let eventDetailController = segue.destination as! AdminEventsMasterDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            if indexPath != nil{
                let eventItem : Event
                if searchController.isActive && searchController.searchBar.text != ""{
                    eventItem = searchList[indexPath!.row]
                }else{
                    eventItem = filterList[indexPath!.row]
                }
                eventDetailController.event = eventItem
            }
        }
    }
}
