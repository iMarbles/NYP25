//
//  AdminStatisticsTwoViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminStatisticsTwoViewController: UIViewController, IAxisValueFormatter, IValueFormatter {
    @IBOutlet weak var percentLbl : UILabel!
    @IBOutlet weak var expectedLbl : UILabel!
    @IBOutlet weak var upcomingEventLbl : UILabel!
    @IBOutlet weak var schoolChart : BarChartView!
    
    var eventList : [Event] = []
    var attendanceList : [EventAttendance] = []

    //For predictions
    var tempListUpcoming : [Event] = []
    var tempListPast : [Event] = []
    
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SiDM"]
    var schoolCount : [Int] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadEventAttendance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Loading of all events first
    func loadEventAttendance(){
        AdminEventDM.retrieveAllEvents(onComplete: {(listFromDb) in
            self.eventList = listFromDb
            self.calculatePredictions()
        })
        AdminEventDM.retrieveAllEventAttendance(onComplete: { (attendanceFromDb) in
            self.attendanceList = attendanceFromDb
            
            self.createPieChart()
            self.calculatePredictions()
        })
    }
    
    func calculatePredictions(){
        tempListPast = []
        tempListUpcoming = []
        
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        let formatDate = formatter.string(from: today)
        
        for event in eventList{
            if event.status == "O"{
                //Check if event has passed
                if event.date! <= formatDate{
                    tempListPast.append(event)
                }else{
                    tempListUpcoming.append(event)
                }
            }
        }
        
        //Sort both event lists by date
        //Latest event that is upcoming
        if tempListUpcoming.count != 0{
            //Latest event (that has passed) at the front
            tempListPast.sort(by: { (a, b) -> Bool in
                if a.date! > b.date!{
                    return true
                }else{
                    return false
                }
            })
            
            //Latest (upcoming) event at the front
            tempListUpcoming.sort(by: { (a, b) -> Bool in
                if a.date! < b.date!{
                    return true
                }else{
                    return false
                }
            })
            
            //Upcoming event
            upcomingEventLbl.text = tempListUpcoming[0].name
            
            var expectedCount = 0
            var prevCount = 0

            for attendee in attendanceList{
                //Get expected turnout based on current RSVPs
                let isPresent = attendee.events.first(where: {$0.eventId == tempListUpcoming[0].eventId})
                
                if isPresent != nil{
                    if isPresent?.rsvp != nil{
                        expectedCount += 1
                    }
                }
                
                //Get previous event turnout
                let isPrev = attendee.events.first(where: {$0.eventId == tempListPast[0].eventId})
                if isPrev != nil{
                    if isPrev?.checkIn != nil{
                        prevCount += 1
                    }
                }
            }
            
            expectedLbl.text = "\(expectedCount)"
            
            //Get the percent involved
            if expectedCount > prevCount{
                //Positve change
                if prevCount != 0{
                    let diff = expectedCount - prevCount
                    let percent = (Double(diff)/Double(prevCount)) * 100
                    
                    if checkIfDecimal(number: percent){
                        percentLbl.text = "+" + String(format: "%.02f", percent) + "%"
                    }else{
                        percentLbl.text = "+" + String(format: "%.00f", percent) + "%"
                    }
                    
                }else{
                    percentLbl.text = "-%"
                }
                percentLbl.textColor = UIColor(red: 0, green: 0.6, blue: 0.2, alpha: 1.0)
            } else if expectedCount < prevCount{
                let diff = prevCount - expectedCount
                let percent = (Double(diff)/Double(prevCount)) * 100
                
                if checkIfDecimal(number: percent){
                    percentLbl.text = "-" + String(format: "%.02f", percent) + "%"
                }else{
                    percentLbl.text = "-" + String(format: "%.00f", percent) + "%"
                }
                percentLbl.textColor = UIColor.red
            }else{
                percentLbl.textColor = UIColor.black
                percentLbl.text = "No Change"
            }
            
            
        }else{
            percentLbl.text = "-%"
            expectedLbl.text = "0"
            upcomingEventLbl.text = "No Upcoming Event"
        }
    }
    
    func checkIfDecimal(number: Double) -> Bool{
        if (number - floor(number) > 0.000001) {
            return true
        }else{
            return false
        }
    }
    
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
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "No. of Attendees")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        schoolChart.data = chartData
        
        //Customization
        let colors = [GlobalDM.sbmCol, GlobalDM.sclCol, GlobalDM.sdnCol, GlobalDM.segCol, GlobalDM.shsCol, GlobalDM.sitCol, GlobalDM.sidmCol]

        
        chartDataSet.colors = colors
        
        schoolChart.xAxis.labelPosition = .bottom
        schoolChart.leftAxis.axisMinimum = 0
        schoolChart.legend.enabled = false
        schoolChart.chartDescription?.text = ""
        schoolChart.rightAxis.enabled = false
        
        schoolChart.isUserInteractionEnabled = false
        
        schoolChart.leftAxis.granularityEnabled = true
        schoolChart.leftAxis.granularity = 1.0
        
        schoolChart.xAxis.valueFormatter = self
        schoolChart.barData?.setValueFormatter(self)
    }
    
    //Formatting
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return schools[Int(value)]
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "StatsMore"{
            let moreController = segue.destination as! AdminStatisticsMoreTableViewController
            moreController.eventList = self.eventList
            moreController.attendanceList = self.attendanceList
        }
    }

}
