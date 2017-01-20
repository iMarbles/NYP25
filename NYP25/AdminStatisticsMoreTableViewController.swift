//
//  AdminStatisticsMoreTableViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 19/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminStatisticsMoreTableViewController: UITableViewController, IValueFormatter {
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SiDM"]
    
    let colors = [GlobalDM.sbmCol, GlobalDM.sclCol, GlobalDM.sdnCol, GlobalDM.segCol, GlobalDM.shsCol, GlobalDM.sitCol, GlobalDM.sidmCol]


    
    var eventList : [Event] = []
    var attendanceList : [EventAttendance] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        sortEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schools.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! AdminStatisticsMoreTableViewCell

        // Configure the cell...
        cell.schoolLbl.text = schools[(indexPath as IndexPath).row]
        cell.schoolLbl.textColor = colors[(indexPath as IndexPath).row]
        createChartFor(schoolChart: cell.lineChart, percentChange: cell.percentLbl, atIndex: (indexPath as IndexPath).row)
        
        cell.isUserInteractionEnabled = false

        return cell
    }
    
    func createChartFor(schoolChart: LineChartView, percentChange: UILabel, atIndex : Int){
        //Get number of people per event by school
        let sch = schools[atIndex]
        var numInEvent : [Int] = []
        
        for event in eventList{
            let eventId = event.eventId
            var eventCount = 0
            
            for attendee in attendanceList{
                if attendee.school == sch {
                    let local = attendee.events.first(where: {$0.eventId == eventId})
                    
                    if local != nil{
                        if local?.checkIn != nil{
                            eventCount += 1
                        }
                    }
                }
            }
            
            numInEvent.append(eventCount)
        }
        
        //Get last two events, get the difference
        if numInEvent.count >= 2{
            let secondLastEvent = numInEvent[numInEvent.count - 2]
            let lastEvent = numInEvent[numInEvent.count - 1]
            
            //Calculate the change
            if lastEvent > secondLastEvent{
                //Positive change
                if secondLastEvent != 0{
                    let diff = lastEvent - secondLastEvent
                    let change = (Double(diff)/Double(secondLastEvent)) * 100
                    
                    if checkIfDecimal(number: change){
                        percentChange.text = "+" + String(format: "%.02f", change) + "%"
                    }else{
                        percentChange.text = "+" + String(format: "%.00f", change) + "%"
                    }

                    
                }else{
                    percentChange.text = "-%"
                }
                percentChange.textColor = UIColor(red: 0, green: 0.6, blue: 0.2, alpha: 1.0)
                
            }else if lastEvent < secondLastEvent{
                //Negative change
                let diff = secondLastEvent - lastEvent
                let change = (Double(diff)/Double(lastEvent)) * 100
                
                if checkIfDecimal(number: change){
                    percentChange.text = "-" + String(format: "%.02f", change) + "%"
                }else{
                    percentChange.text = "-" + String(format: "%.00f", change) + "%"
                }
                
                percentChange.textColor = UIColor.red
            }else{
                percentChange.textColor = UIColor.black
                percentChange.text = "No Change"
            }
        }else{
            percentChange.textColor = UIColor.black
            percentChange.text = "No Change"
        }
    
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<eventList.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(numInEvent[i]))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Attendees")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        schoolChart.data = lineChartData
        
        //Customization
        schoolChart.legend.enabled = false
        schoolChart.chartDescription?.text = ""
        
        schoolChart.xAxis.enabled = false
        schoolChart.leftAxis.enabled = false
        schoolChart.rightAxis.enabled = false
        
        schoolChart.isUserInteractionEnabled = false
        
        lineChartDataSet.colors = [colors[atIndex]]
        lineChartDataSet.circleColors = [colors[atIndex]]
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.circleHoleRadius = 0
        //lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = colors[atIndex]
        
        schoolChart.lineData?.setValueFormatter(self)
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
    
    func checkIfDecimal(number: Double) -> Bool{
        if (number - floor(number) > 0.000001) {
            return true
        }else{
            return false
        }
    }
    
    //For onload
    func sortEvents(){
        var tempList : [Event] = []
        for event in eventList{
            //Conditions for it to appear on graph
            
            //Only after event has passed ->
            let today = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyyMMdd"
            let formatDate = formatter.string(from: today)

            if event.date != nil{
                if event.date! <= formatDate{
                    tempList.append(event)
                }
            }
        }
        
        tempList.sort { (a, b) -> Bool in
            if a.date! < b.date!{
                return true
            }else{
                return false
            }
        }
        
        eventList = tempList
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
