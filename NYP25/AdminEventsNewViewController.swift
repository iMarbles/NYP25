//
//  AdminEventsNewViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 23/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventsNewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    @IBOutlet weak var eventImage : UIImageView!
    @IBOutlet weak var nameTb : UITextField!
    @IBOutlet weak var dateTb : UITextField!
    @IBOutlet weak var startTimeTb : UITextField!
    @IBOutlet weak var endTimeTb : UITextField!
    @IBOutlet weak var locationTb : UITextField!
    @IBOutlet weak var badgeImage : UIImageView!
    @IBOutlet weak var descTb : UITextView!
    @IBOutlet weak var visbleSwitch : UISwitch!
    
    var event : Event? = nil
    var isEventImage : Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descTb.delegate = self
        descTb.textColor = UIColor.lightGray
        descTb.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descTb.layer.borderWidth = 1.0;
        descTb.layer.cornerRadius = 5.0;
        
        if event == nil{
            event = Event()
        }
        
        //To dismiss keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Date related
    @IBAction func selectDate(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTb.text = dateFormatter.string(from: sender.date)
        
        let dbFormat = DateFormatter()
        dbFormat.dateFormat = "yyyyMMdd"
        event?.date = dbFormat.string(from: sender.date)
    }
    
    @IBAction func selectStartTime(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleStartTime(sender:)), for: .valueChanged)
    }
    
    @IBAction func selectEndTime(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleEndTime(sender:)), for: .valueChanged)
    }
    
    func handleStartTime(sender: UIDatePicker) {
        event?.startTime = formatTimeForDb(time: sender)
        startTimeTb.text = formatTime(time: sender)
    }
    
    func handleEndTime(sender: UIDatePicker){
        event?.endTime = formatTimeForDb(time: sender)
        endTimeTb.text = formatTime(time: sender)
    }
    
    //Reusable format time code
    func formatTime(time : UIDatePicker) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let formatTime = dateFormatter.string(from: time.date)
        return formatTime
    }
    
    func formatTimeForDb(time : UIDatePicker) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        
        let formatTime = dateFormatter.string(from: time.date)
        return formatTime
    }
    
    //Uploading of images
    @IBAction func uploadImagePressed(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        isEventImage = true
        
        self.present(picker, animated: true)
    }
    
    
    @IBAction func uploadBadgePressed(sender : AnyObject){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        isEventImage = false
        
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if isEventImage{
            self.eventImage.image = chosenImage
            eventImage.isHidden = false
        }else{
            self.badgeImage.image = chosenImage
        }

        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true)
    }
    
    //Desc box
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter event description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //Saving of event
    @IBAction func saveEvent(){
        if(descTb.textColor == UIColor.lightGray){
            event?.desc = ""
        }else{
            event?.desc = descTb.text
        }
        
        event?.name = nameTb.text!
        
        var eventData : NSData?
        if(eventImage.image != nil){
            eventData = UIImageJPEGRepresentation(eventImage.image!, 0.8)! as NSData
        }

        var badgeData : NSData?
        if(badgeImage.image != nil){
            badgeData = UIImageJPEGRepresentation(badgeImage.image!, 0.8)! as NSData
        }
       
        if(visbleSwitch.isOn){
            if(validateFields() == ""){
                event?.status = "O"
                
                AdminEventDM.createEvent(event: event!, eventImage: eventData, eventBadge: badgeData)
            }else{
                //Failed validation
                let uiAlert = UIAlertController(title: "Incomplete Fields", message: validateFields(), preferredStyle: UIAlertControllerStyle.alert)
                
                uiAlert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                
                self.present(uiAlert, animated: true, completion: nil)
            }
        }else{
            //No need to validate, just save
            event?.status = "C"
            
            AdminEventDM.createEvent(event: event!, eventImage: eventData, eventBadge: badgeData)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func validateFields() -> String{
        var errMsg = ""
        
        if eventImage.image == nil{
            errMsg += "Please upload an event image \n"
        }
        if nameTb.text == ""{
            errMsg += "Please enter event title \n"
        }
        if dateTb.text == ""{
            errMsg += "Please enter date \n"
        }
        if startTimeTb.text == "" {
            errMsg += "Please enter start time \n"
        }
        if endTimeTb.text == ""{
            errMsg += "Please enter end time \n"
        }
        if locationTb.text == ""{
            errMsg += "Please select a location \n"
        }
        if badgeImage.image == nil{
            errMsg += "Please upload a badge icon"
        }
        if descTb.text == ""{
            errMsg += "Please enter a description"
        }
        
        return errMsg
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMap"{
            let mapController = segue.destination as! AdminEventsMapViewController
            mapController.event = event
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationTb.text = event?.address
    }

}
