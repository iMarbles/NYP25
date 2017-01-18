//
//  UserLeaderboardController.swift
//  NYP25
//
//  Created by sjtan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Foundation
import Charts

class UserLeaderboardController: UIViewController {
    
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
    
    
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SiDM"]
    var schoolCount : [Int] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardChart.noDataText = "No event data available"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
}
