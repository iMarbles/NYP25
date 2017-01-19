//
//  AdminStatisticsMoreTableViewCell.swift
//  NYP25
//
//  Created by Zhen Wei on 19/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminStatisticsMoreTableViewCell: UITableViewCell {
    @IBOutlet weak var schoolLbl : UILabel!
    @IBOutlet weak var percentLbl : UILabel!
    @IBOutlet weak var lineChart : LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
