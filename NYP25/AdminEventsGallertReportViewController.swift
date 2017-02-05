//
//  AdminEventsGallertReportViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 5/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class AdminEventsGallertReportViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
     var reportList : [SocialFlag]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell")! as UITableViewCell
        
        cell.textLabel?.text = reportList?[(indexPath as IndexPath).row].flagReason
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    @IBAction func backBtnPressed(sender: Any)
    {
        dismiss(animated: true, completion: nil)
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
