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

class UserLeaderboardViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, IAxisValueFormatter, IValueFormatter{
    
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var thirdImg: UIImageView!
    @IBOutlet weak var fourthImg: UIImageView!
    @IBOutlet weak var fifthImg: UIImageView!
    @IBOutlet weak var sixthImg: UIImageView!
    @IBOutlet weak var seventhImg: UIImageView!
    
    
    @IBOutlet weak var firstScoreLbl: UILabel!
    @IBOutlet weak var secondScoreLbl: UILabel!
    @IBOutlet weak var thirdScoreLbl: UILabel!
    @IBOutlet weak var fourthScoreLbl: UILabel!
    @IBOutlet weak var fifthScoreLbl: UILabel!
    @IBOutlet weak var sixthScoreLbl: UILabel!
    @IBOutlet weak var seventhScoreLbl: UILabel!
    
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var secondLbl: UILabel!
    @IBOutlet weak var thirdLbl: UILabel!
    @IBOutlet weak var fourthLbl: UILabel!
    @IBOutlet weak var fifthLbl: UILabel!
    @IBOutlet weak var sixthLbl: UILabel!
    @IBOutlet weak var seventhLbl: UILabel!
    
    @IBOutlet weak var leaderboardChart: BarChartView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var locationManager : CLLocationManager!
    
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    //for bar chart 
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SIDM"]
    let colour = ["yellow", "red", "pink", "green", "orange", "blue", "purple"]

    var schoolCount : [Int] = []
    var sumOfAttendees = 0
    var selectedAdminNum = ""
    
    
    var eventList : [Event] = []
    var attendanceList : [EventAttendance] = []

    

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
        
//        mapView.mapType = MKMapType.standard
        
        
        //configure user interactions
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = false
//        mapView.delegate = self;
        
        var span = MKCoordinateSpan()
        span.longitudeDelta = 0.005
        span.latitudeDelta = 0.005
        
        var location = CLLocationCoordinate2D()
        location.latitude = 1.38012
        location.longitude = 103.85023
        
        var region = MKCoordinateRegion()
        region.span = span
        region.center = location
        
        //Set to the region with animated effect
        mapView.setRegion(region, animated:true)
        
        
        let sitLocation = Location(title: "SIT", subtitle: "School of Information Technology", colour: UIColor.blue, coordinate: CLLocationCoordinate2D(latitude: 1.379348, longitude:103.849876))
        
        let sidmLocation = Location(title: "SIDM", subtitle: "School of Interactive Design & Media", colour: UIColor.purple, coordinate: CLLocationCoordinate2D(latitude: 1.3788469, longitude: 103.850058))
        
        let segLocation = Location(title: "SEG", subtitle: "School of Engineering", colour: UIColor.green, coordinate: CLLocationCoordinate2D(latitude: 1.378844, longitude: 103.848631))
        
        let sclLocation = Location(title: "SCL", subtitle: "School of Chemical Life Sciences", colour: UIColor.red, coordinate: CLLocationCoordinate2D(latitude: 1.3779, longitude: 103.8495))
        
        let sdnLocation = Location(title: "SDN", subtitle: "School of Design", colour: UIColor(red:0.9059, green:0, blue:0.9882, alpha:1.0), coordinate: CLLocationCoordinate2D(latitude: 1.378297, longitude:103.848567))
        
        let sbmLocation = Location(title: "SBM", subtitle: "School of Business Management", colour: UIColor.yellow, coordinate: CLLocationCoordinate2D(latitude: 1.381311, longitude:103.84846))
        
        let shsLocation = Location(title: "SHS", subtitle: "School of Health Sciences", colour: UIColor(red: 0.898, green: 0.6941, blue: 0.4471, alpha: 1.0), coordinate: CLLocationCoordinate2D(latitude: 1.381139, longitude:103.849865))
        
        
        mapView.addAnnotation(sitLocation)
        mapView.addAnnotation(sidmLocation)
        mapView.addAnnotation(segLocation)
        mapView.addAnnotation(sclLocation)
        mapView.addAnnotation(sdnLocation)
        mapView.addAnnotation(sbmLocation)
        mapView.addAnnotation(shsLocation)
        
        mapView.addAnnotations([sitLocation, sidmLocation, segLocation, sclLocation, sdnLocation, sbmLocation, shsLocation])
        //for pie chart
        loadEventAttendance()
        getAttendance()
        
                
            }
 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func loadEventAttendance(){
        LeaderboardDM.retrieveAllEvents(onComplete: {(listFromDb) in
            self.eventList = listFromDb
            
        })
        
        LeaderboardDM.retrieveAttendance(adminNum: selectedAdminNum, onComplete: { (attendanceFromDb) in
            self.attendanceList = attendanceFromDb
            
            self.createPieChart()
       //     self.getAttendance()
           
       //     self.getUniqueAttendance()
            
        })
    }
    
    func getAttendance(){
        
        var sbmAtt = 0;
        var sclAtt = 0;
        var sdnAtt = 0;
        var segAtt = 0;
        var shsAtt = 0;
        var sitAtt = 0;
        var sidmAtt = 0;
        var count = 0;
        
        //Loop through all the event attendances
        for a in attendanceList{
            let b = a.school
            //each person attends multple events (sum them up)
            for e in a.events{
                if e.checkIn != nil{
                    count += 1
                }
          
            }
            if b == "SBM"{
            sbmAtt += count
            }
            if b == "SCL"{
            sclAtt += count
            }
            if b == "SDN"{
            sdnAtt += count
            }
            if b == "SEG"{
            segAtt += count
            }
            if b == "SHS"{
            shsAtt += count
            }
            if b == "SIT"{
            sitAtt += count
            }
            if b == "SIDM"{
            sidmAtt += count
            }
            
        }
        
        var leaderboard = [Leaderboard]()
    schoolCount = [sbmAtt, sclAtt, sdnAtt, segAtt, shsAtt, sitAtt, sidmAtt]
        var ldrCount = 0;
        for i in schoolCount {
            let l : Leaderboard = Leaderboard()
            l.school =  schools[ldrCount]
            l.colour = colour [ldrCount]
            l.avgPoints = Double(i)
            
            ldrCount += 1
            leaderboard.append(l)
        }
        
        var sortedBoard = [Leaderboard]()
        var prev = 0;
        for j in leaderboard {
            let x = Int(j.avgPoints)
            if x < prev {
                sortedBoard.insert(j, at: 0)
            } else {
                sortedBoard.append(j)
            }
            prev = x
            // sort leaderboard objects, with the 1st object having the most avgPoints, and the last having the least.
        }
      
        
        var sortedCount = 0
        for a in sortedBoard {
            if sortedCount == 0 {
            firstLbl.text = a.school
            firstScoreLbl.text = String(format:"%.0f", a.avgPoints)
            firstImg.image = UIImage(named: a.colour!)
            } else if sortedCount == 1 {
                secondLbl.text = a.school
                secondScoreLbl.text = String(format:"%.0f", a.avgPoints)
                secondImg.image = UIImage(named: a.colour!)
            }
            else if sortedCount == 2 {
                thirdLbl.text = a.school
                thirdScoreLbl.text = String(format:"%.0f", a.avgPoints)
                thirdImg.image = UIImage(named: a.colour!)
            }
            else if sortedCount == 3 {
                fourthLbl.text = a.school
                fourthScoreLbl.text = String(format:"%.0f", a.avgPoints)
                fourthImg.image = UIImage(named: a.colour!)
            }
            else if sortedCount == 4 {
                fifthLbl.text = a.school
                fifthScoreLbl.text = String(format:"%.0f", a.avgPoints)
                fifthImg.image = UIImage(named: a.colour!)
            }
            else if sortedCount == 5 {
                sixthLbl.text = a.school
                sixthScoreLbl.text = String(format:"%.0f", a.avgPoints)
                sixthImg.image = UIImage(named: a.colour!)
            }
            else if sortedCount == 6 {
                seventhLbl.text = a.school
                seventhScoreLbl.text = String(format:"%.0f", a.avgPoints)
                seventhImg.image = UIImage(named: a.colour!)
            }

            sortedCount += 1
        }
        
        
  
       
        
        
        
        
        
      
        
        // do some loop and sort which leaderboard object has more points an assign into another list
        
        
        
        //Show the attendance
   //     sumOfAttendees = count
     //   sitLbl.text = formatNumber(toComma: count)
    }
    
  //  func getUniqueAttendance(){
    //    uniqueLbl.text = formatNumber(toComma: attendanceList.count)
    //}
    
    func createPieChart(){
        //Need to show number of attendees per school (Not unique, total)
        var sbm = 0
        var scl = 0
        var sdn = 0
        var seg = 0
        var shs = 0
        var sit = 0
        var sidm = 0
        
        for attendance in attendanceList{
            let s = attendance.school
            var count = 0
            for event in attendance.events{
                if event.checkIn != nil{
                    count += 1
                }
            }
            
            if s == "SBM"{
                sbm += count
            }
            if s == "SCL"{
                scl += count
            }
            if s == "SDN"{
                sdn += count
            }
            if s == "SEG"{
                seg += count
            }
            if s == "SHS"{
                shs += count
            }
            if s == "SIT"{
                sit += count
            }
            if s == "SIDM"{
                sidm += count
            }
        }
        
        schoolCount = [sbm, scl, sdn, seg, shs, sit, sidm]
        
        //To represent as pie chart
        setBarChartFor(schools: schools, withValues: schoolCount)
    }
    
    //Bar Chart
    func setBarChartFor(schools: [String], withValues : [Int]){
        var dataEntries : [BarChartDataEntry] = []
        
        for i in 0 ..< schools.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(withValues[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Attendance")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        leaderboardChart.data = chartData
        
        //Customization
        let colors = [LeaderboardDM.sbmColor, LeaderboardDM.sclColor, LeaderboardDM.sdnColor, LeaderboardDM.segColor, LeaderboardDM.shsColor, LeaderboardDM.sitColor, LeaderboardDM.sidmColor]
        
        
        chartDataSet.colors = colors
        
        leaderboardChart.xAxis.labelPosition = .bottom
        leaderboardChart.leftAxis.axisMinimum = 0
        leaderboardChart.legend.enabled = false
        leaderboardChart.chartDescription?.text = ""
        leaderboardChart.rightAxis.enabled = false
        
        leaderboardChart.isUserInteractionEnabled = false
        
        leaderboardChart.leftAxis.granularityEnabled = true
        leaderboardChart.leftAxis.granularity = 1.0
        
        leaderboardChart.xAxis.valueFormatter = self
        leaderboardChart.barData?.setValueFormatter(self)
    }
    
    //Formatting
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return schools[Int(value)]
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
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
