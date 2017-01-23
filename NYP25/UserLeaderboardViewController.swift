//
//  UserLeaderboardViewController.swift
//  NYP25
//
//  Created by sjtan on 23/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Charts

class UserLeaderboardViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
