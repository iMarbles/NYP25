//
//  AdminStatisticsOneViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminStatisticsOneViewController: UIViewController, IValueFormatter {
    @IBOutlet weak var totalAttendanceLbl : UILabel!
    @IBOutlet weak var uniqueLbl : UILabel!
    @IBOutlet weak var ratingLbl : UILabel!
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    //Relevant charts
    @IBOutlet weak var schoolChart : PieChartView!
    @IBOutlet weak var ratingChart : HorizontalBarChartView!
    
    var eventList : [Event] = []
    var attendanceList : [EventAttendance] = []
    
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SiDM"]
    var schoolCount : [Int] = []
    var sumOfAttendees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        schoolChart.noDataText = "No event data available"
        ratingChart.noDataText = "No event data available"
        loadEventAttendance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Loading of all events first
    func loadEventAttendance(){
        AdminEventDM.retrieveAllEventAttendance(onComplete: { (attendanceFromDb) in
            self.attendanceList = attendanceFromDb
            
            self.getTotalAttendance()
            self.getUniqueAttendance()
            self.createPieChart()
            self.createRatings()
        })
    }
    
    //Relevant methods
    func getTotalAttendance(){
        var count = 0;
        //Loop through all the event attendances
        for attendance in attendanceList{
            //each person attends multple events (sum them up)
            for e in attendance.events{
                if e.checkIn != nil{
                    count += 1
                }
            }
        }
        
        //Show the attendance
        sumOfAttendees = count
        totalAttendanceLbl.text = formatNumber(toComma: count)
    }
    
    func getUniqueAttendance(){
        var count = 0
        for attendance in attendanceList{
            for e in attendance.events{
                if e.checkIn != nil{
                    count += 1
                    break;
                }
            }
        }
        uniqueLbl.text = formatNumber(toComma: count)
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
        setPieChartFor(schools: schools, withValues: schoolCount)
    }
    
    func createRatings(){
        AdminEventDM.retrieveAllEvents(onComplete: { (eventFromDb) in
            self.eventList = eventFromDb
            self.calculateRatings()
        })
    }
    
    //Formatting number to comma
    func formatNumber(toComma: Int) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: toComma))!
    }
    
    //Formatting numbers for pie chart
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        //To show percentage
        // x / sum * 100
        let asPercent = (value / Double(sumOfAttendees)) * 100.0
        let percentStr = String(format: "%.01f", asPercent)
        
        let s = "\(percentStr)% \n " + schools[Int(entry.x)]
        
        if value != 0{
            return s
        }else{
            return ""
        }
    }
    
    //Pie Chart
    func setPieChartFor(schools: [String], withValues : [Int]){
        var dataEntries : [ChartDataEntry] = []
        
        for i in 0 ..< schools.count{
           let dataEntry = ChartDataEntry(x: Double(i), y: Double(withValues[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "No. of Attendees")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        schoolChart.data = chartData
        
        let colors = [GlobalDM.sbmCol, GlobalDM.sclCol, GlobalDM.sdnCol, GlobalDM.segCol, GlobalDM.shsCol, GlobalDM.sitCol, GlobalDM.sidmCol]
        
        chartDataSet.colors = colors
        
        schoolChart.legend.enabled = false
        schoolChart.chartDescription?.text = ""
        
        schoolChart.isUserInteractionEnabled = false
        
        let centerText = NSMutableAttributedString()
        let numberText = NSMutableAttributedString(string: "Attendance", attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName: UIFont(name: "Arial",size:25)!])
        let descriptionText = NSMutableAttributedString(string: "\n    by School", attributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName: UIFont(name: "Arial",size:20)!])
        centerText.append(numberText)
        centerText.append(descriptionText)
        schoolChart.centerAttributedText = centerText
        
        schoolChart.data?.setValueFormatter(self)
        
        schoolChart.animate(xAxisDuration: 1.0)
        /*
         let circleColor = UIColor.black
         let textColor = UIColor.white
         schoolChart.holeRadiusPercent = 0.3
         schoolChart.transparentCircleRadiusPercent = 0.0
         schoolChart.centerTextRadiusPercent = 1.0
         schoolChart.holeColor = circleColor
         */
    }
    
    //Rating numbers
    func calculateRatings(){
        var totalRating = 0.0
        var totalFeedbackCount = 0;
        var oneStar = 0
        var twoStar = 0
        var threeStar = 0
        var fourStar = 0
        var fiveStar = 0
        
        for event in eventList{
            if event.feedbackList != nil{
                for feedback in event.feedbackList!{
                    //Get sum of rating through all events
                    totalRating += Double(feedback.rating)
                    //Increase number of people who feedback +1
                    totalFeedbackCount += 1
                    
                    //Add number of 1 ~ 5 stars
                    if feedback.rating == 1{
                        oneStar += 1
                    }
                    if feedback.rating == 2{
                        twoStar += 1
                    }
                    if feedback.rating == 3{
                        threeStar += 1
                    }
                    if feedback.rating == 4{
                        fourStar += 1
                    }
                    if feedback.rating == 5{
                        fiveStar += 1
                    }
                }
            }
        }
        
        //Get the number rating
        if totalRating != 0{
            let avgRating = totalRating / Double(totalFeedbackCount)
            ratingLbl.text = String(format: "%.1f", avgRating)
            
            star1.image = getStarImage(starNumber: 1, forRating: avgRating)
            star2.image = getStarImage(starNumber: 2, forRating: avgRating)
            star3.image = getStarImage(starNumber: 3, forRating: avgRating)
            star4.image = getStarImage(starNumber: 4, forRating: avgRating)
            star5.image = getStarImage(starNumber: 5, forRating: avgRating)
        }else{
            ratingLbl.text = "0.0"
        }
        
        //Managed to get all values, time to pass into chart
        let userRating = [oneStar, twoStar, threeStar, fourStar, fiveStar]
        setRatingChart(values: userRating)
    }
    
    //Rating chart
    func setRatingChart(values : [Int]){
        let chartRatings = [1, 2, 3, 4, 5]
        
        var dataEntries : [BarChartDataEntry] = []
        for i in 0 ..< chartRatings.count{
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Rating")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.setDrawValues(false)
        
        ratingChart.data = chartData
        
        //Customization
        let red = UIColor.red
        let orange = UIColor.orange
        let yellow = UIColor(red:0.87, green:0.87, blue:0.13, alpha:1.0)
        let lightGreen = UIColor(red:0.20, green:0.80, blue:0.20, alpha:1.0)
        let darkGreen = UIColor(red:0.00, green:0.40, blue:0.00, alpha:1.0)
        let color = [red, orange, yellow, lightGreen, darkGreen]
        chartDataSet.colors = color
        
        ratingChart.legend.enabled = false
        ratingChart.chartDescription?.text = ""
        
        ratingChart.xAxis.enabled = false
        ratingChart.leftAxis.enabled = false
        ratingChart.rightAxis.enabled = false
        
        ratingChart.drawValueAboveBarEnabled = false
        
        ratingChart.isUserInteractionEnabled = false
    }
    
    //Star images
    func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage{
        let emptyStar = UIImage(named: "Star-50")!
        let halfStar = UIImage(named: "Star Half Empty Filled-50")!
        let fullStar = UIImage(named: "Star Filled-50")!
        
        if rating >= starNumber{
            return fullStar
        } else if rating + 0.5 == starNumber{
            return halfStar
        } else{
            return emptyStar
        }
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
