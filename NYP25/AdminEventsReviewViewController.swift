//
//  AdminEventsReviewViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 28/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminEventsReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var overallLbl : UILabel!
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    @IBOutlet weak var totalUserLbl : UILabel!
    
    @IBOutlet weak var barChart : HorizontalBarChartView!
    
    
    var event : Event?
    var feedbacks : [EventFeedback] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupReviews()
    }
    
    func setupReviews(){
        if event?.feedbackList != nil{
            feedbacks = (event?.feedbackList)!
            totalUserLbl.text = String(feedbacks.count)
            
            var userRating : [Int] = []
            
            //Calculating the average reviews -> sum of all reviews / people
            var totalRating = 0.0
            
            var oneStar = 0
            var twoStar = 0
            var threeStar = 0
            var fourStar = 0
            var fiveStar = 0
            
            for review in feedbacks{
                totalRating += Double(review.rating)
                
                if review.rating == 1{
                    oneStar += 1
                }
                if review.rating == 2{
                    twoStar += 1
                }
                if review.rating == 3{
                    threeStar += 1
                }
                if review.rating == 4{
                    fourStar += 1
                }
                if review.rating == 5{
                    fiveStar += 1
                }
            }
            
            userRating.append(oneStar)
            userRating.append(twoStar)
            userRating.append(threeStar)
            userRating.append(fourStar)
            userRating.append(fiveStar)
            
            if totalRating != 0 {
                let avgRating = totalRating / Double(feedbacks.count)
                overallLbl.text = String(format: "%.1f", avgRating)
                
                star1.image = getStarImage(starNumber: 1, forRating: avgRating)
                star2.image = getStarImage(starNumber: 2, forRating: avgRating)
                star3.image = getStarImage(starNumber: 3, forRating: avgRating)
                star4.image = getStarImage(starNumber: 4, forRating: avgRating)
                star5.image = getStarImage(starNumber: 5, forRating: avgRating)
            }else{
                overallLbl.text = "0.0"
            }
            
            let chartRating = [1, 2, 3, 4, 5]
            setChart(dataPoints: chartRating, values: userRating)
        }
    }
    
    func getStarImage(starNumber: Double, forRating rating: Double) -> UIImage{
        let emptyStar = UIImage(named: "Star-50")!
        let halfStar = UIImage(named: "Star Half Empty Filled-50")!
        let fullStar = UIImage(named: "Star Filled-50")!
        
        if rating >= starNumber{
            return fullStar
        } else if rating + 0.5 == starNumber{
            return halfStar
        }else{
            return emptyStar
        }
    }
    
    func setChart(dataPoints: [Int], values: [Int]) {
        barChart.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        //for each of the ratings
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Rating")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.setDrawValues(false)
        
        barChart.data = chartData
        
        //Customization
        let red = UIColor.red
        let orange = UIColor.orange
        let yellow = UIColor(red:0.87, green:0.87, blue:0.13, alpha:1.0)
        let lightGreen = UIColor(red:0.20, green:0.80, blue:0.20, alpha:1.0)
        let darkGreen = UIColor(red:0.00, green:0.40, blue:0.00, alpha:1.0)
        let color = [red, orange, yellow, lightGreen, darkGreen]
        chartDataSet.colors = color
        
        barChart.legend.enabled = false
        barChart.chartDescription?.text = ""
        
        barChart.xAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.rightAxis.enabled = false
        
        barChart.drawValueAboveBarEnabled = false
        
        barChart.isUserInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! AdminEventReviewTableViewCell
        
        let currentFeedback = feedbacks[(indexPath as IndexPath).row]
        
        cell.star1.image = getStarImage(starNumber: 1, forRating: Double(currentFeedback.rating))
        cell.star2.image = getStarImage(starNumber: 2, forRating: Double(currentFeedback.rating))
        cell.star3.image = getStarImage(starNumber: 3, forRating: Double(currentFeedback.rating))
        cell.star4.image = getStarImage(starNumber: 4, forRating: Double(currentFeedback.rating))
        cell.star5.image = getStarImage(starNumber: 5, forRating: Double(currentFeedback.rating))
        
        cell.usernameLbl.text = currentFeedback.username
        
        cell.reviewLbl.text = currentFeedback.comment
        
        tableView.isUserInteractionEnabled = false
        tableView.rowHeight = UITableViewAutomaticDimension
         tableView.estimatedRowHeight = 140
        
        return cell
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
