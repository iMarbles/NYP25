//
//  AdminEventsMapViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 26/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import MapKit

class AdminEventsMapViewController: UIViewController {
    @IBOutlet weak var mapView : MKMapView!
 
    var resultSearchController : UISearchController? = nil
    
    var event : Event?
    var isDone = false
    var oldEventAdd : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //To be used to check if done button was selected
        isDone = false
        
        if event != nil{
            //Show location of event
            if event?.address != nil{
                oldEventAdd = (event?.address)!
            }
            searchLocation()
        }
        
        // Do any additional setup after loading the view.
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! AdminEventsLocationSearchTableViewController
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Location"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.event = event
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //If done button not selected, no selected address (for new events)
        if !isDone{
            event?.address = nil
        }
        
        //For existing events
        if !isDone && oldEventAdd != "" {
            event?.address = oldEventAdd
        }
        
    }
    
    @IBAction func doneBtnClick(sender: Any){
        isDone = true
        if mapView.annotations.count == 0{
            let uiAlert = UIAlertController(title: "Error", message: "No location entered", preferredStyle: UIAlertControllerStyle.alert)
            
            uiAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            self.present(uiAlert, animated: true, completion: nil)
            
            event?.address = nil
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func searchLocation(){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = event?.address
        request.region = (mapView?.region)!
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                let selectedItem = response?.mapItems[0].placemark
                self.dropPinZoomIn(placemark: selectedItem!)

            }
        })
    }
    
    func dropPinZoomIn(placemark:MKPlacemark){
        // clear existing pins
        mapView?.removeAnnotations((mapView?.annotations)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotation.subtitle = parseAddress(selectedItem: placemark)
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView?.setRegion(region, animated: true)
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : " "
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
