//
//  UserEventDetailsViewController.swift
//  NYP25
//
//  Created by Kenneth on 1/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import MapKit

class UserEventDetailsViewController: UIViewController {
    
    var event: Event?
    
    @IBOutlet weak var eventBannerImg:UIImageView!
    @IBOutlet weak var eventLbl:UILabel!
    @IBOutlet weak var dateLbl:UILabel!
    @IBOutlet weak var venueLbl:UILabel!
    @IBOutlet weak var descLbl:UILabel!
    @IBOutlet weak var mapWidget:MKMapView!
    @IBOutlet weak var btnImg:UIImageView!
    @IBOutlet weak var btnLbl:UILabel!
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    func goBtn(img: AnyObject) {
        let alertController = UIAlertController(title: "Nice", message: "Something happens in the background", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        let e : Event = event!
        
        eventLbl.text = e.name
        
        if e.date != nil && e.startTime != nil{
            let day = GlobalDM.getDayNameBy(stringDate: e.date!)
            let time = GlobalDM.getTimeInHrBy(stringTime: e.startTime!)
            dateLbl.text = "\(day) @ \(time)"
        }
        
        venueLbl.text = e.address
        descLbl.text = e.desc
        
        if(e.imageUrl != nil){
            GlobalDM.loadImage(imageView: eventBannerImg, url: e.imageUrl!)
        }
        
        btnImg.image = UIImage(named: "btngreen")
        btnLbl.text = "I'm going!"
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = e.address;
        
        // Set the region to an associated map view's region
        request.region = mapWidget.region
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Match found")
                
                for item in response!.mapItems {
//                    print("Name = \(item.name)")
//                    print("Phone = \(item.phoneNumber)")
                    
                    self.matchingItems.append(item as MKMapItem)
//                    print("Matching items = \(self.matchingItems.count)")
                    
                   
                    
                    
                    var allAnnMapRect = MKMapRectNull
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapWidget.addAnnotation(annotation)
                    
                        let thisAnnMapPoint = MKMapPointForCoordinate(annotation.coordinate)
                        let thisAnnMapRect = MKMapRectMake(thisAnnMapPoint.x, thisAnnMapPoint.y, 1000, 1000)
                        allAnnMapRect = MKMapRectUnion(allAnnMapRect, thisAnnMapRect)
                    
                    
                    //Set inset (blank space around all annotations) as needed...
                    //These numbers are in screen CGPoints...
                    let edgeInset = UIEdgeInsetsMake(60, 65, 30, 40)
                    
                    self.mapWidget.setVisibleMapRect(allAnnMapRect, edgePadding: edgeInset, animated: true)

                    break; // break from loop after first annotation is dropped
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(goBtn(img:)))
        btnImg.isUserInteractionEnabled = true
        btnImg.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
