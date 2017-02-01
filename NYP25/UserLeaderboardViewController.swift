//
//  UserLeaderboardViewController.swift
//  NYP25
//
//  Created by sjtan on 23/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Charts
import CoreLocation
import MapKit

class UserLeaderboardViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var green: UIImageView!
    @IBOutlet weak var blue: UIImageView!
    @IBOutlet weak var yellow: UIImageView!
    @IBOutlet weak var purple: UIImageView!
    @IBOutlet weak var orange: UIImageView!
    @IBOutlet weak var red: UIImageView!
    @IBOutlet weak var pink: UIImageView!
    
    @IBOutlet weak var sitLbl: UILabel!
    @IBOutlet weak var sbmLbl: UILabel!
    @IBOutlet weak var sidmLbl: UILabel!
    @IBOutlet weak var shsLbl: UILabel!
    @IBOutlet weak var sclLbl: UILabel!
    @IBOutlet weak var segLbl: UILabel!
    @IBOutlet weak var sdnLbl: UILabel!
    
    @IBOutlet weak var sitScoreLbl: UILabel!
    @IBOutlet weak var sbmScoreLbl: UILabel!
    @IBOutlet weak var sidmScoreLbl: UILabel!
    @IBOutlet weak var shsScoreLbl: UILabel!
    @IBOutlet weak var sclScoreLbl: UILabel!
    @IBOutlet weak var segScoreLbl: UILabel!
    @IBOutlet weak var sdnScoreLbl: UILabel!
    
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    
    @IBOutlet weak var leaderboardChart: HorizontalBarChartView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
  //  @IBOutlet weak var mapView : MKMapView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dataView.isHidden = false
            mapView.isHidden = true
            
        case 1:
            dataView.isHidden = true
            mapView.isHidden = false
            
        default:
            break;
        }
    }

    var locationManager : CLLocationManager?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Create Location manager object
        locationManager = CLLocationManager();
        
        //Set the delegate property of the location manager to self
        locationManager?.delegate = self;
        
        //Set the most accurate location data as possible
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Check for iOS 8. Without this guard the code will
        // crash with "unknown selector" on iOS 7.
        let ios8 = locationManager?.responds(to:
            #selector(CLLocationManager.requestWhenInUseAuthorization))
        if (ios8!) {
            locationManager?.requestWhenInUseAuthorization();
        }
        //Tell the location manager to start looking for its location
        //immediately
        locationManager?.startUpdatingLocation();
    }
    
    var lastLocationUpdateTime : Date = Date()
    // This function receives information about the change of the
    // user’s GPS location. The locations array may contain one
    // or more location updates that were collected in-between calls
    // to this function.
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        // There are multiple locations, but we are only
        // interested in the last one.
        let newLocation = locations.last!;
        // Get find out how old (in seconds) this data was.
        let howRecent =
            self.lastLocationUpdateTime.timeIntervalSinceNow;
        // Handle only recent events to save power.
        if (abs(howRecent) > 15)
        {
            print("Longitude = \(newLocation.coordinate.longitude)");
            print("Latitude = \(newLocation.coordinate.latitude)");
            self.lastLocationUpdateTime = Date()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Could not find location: \(error)");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        //configure user interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self;
        //Set the region and zoom level
        var span = MKCoordinateSpan()
        span.longitudeDelta = 0.02
        span.latitudeDelta = 0.02
        //Set the region and zoom level
        var location = CLLocationCoordinate2D()
        location.latitude = 1.38012
        location.longitude = 103.85023
        //amount of map to display
        var region = MKCoordinateRegion()
        region.span = span
        region.center = location
        //Set to the region with animated effect
        mapView.setRegion(region, animated:true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
