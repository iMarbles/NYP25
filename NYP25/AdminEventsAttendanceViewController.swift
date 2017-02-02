//
//  AdminEventsAttendanceViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import AVFoundation

class AdminEventsAttendanceViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var topbar: UIView!
    
    //From segue
    var event : Event?
    
    //For QR
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing without device
        
        let adminNo = "142519G"
        AdminEventDM.checkIfUserExist(adminNo: adminNo, onComplete: {(student) in
            if student.userId != "" {
                //Create event attendance
                AdminEventDM.createAttendance(student: student, event: self.event!, onComplete: {(msg) in
                    if msg == "OK"{
                        self.messageLabel.text = "Attendance Taken"
                    }
                })
            }else{
                self.messageLabel.text = "Invalid QR Code"
            }
        })
        
        
        // Do any additional setup after loading the view.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.orange.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            //Logic to handle the attendance
            if metadataObj.stringValue != nil {
                //messageLabel.text = metadataObj.stringValue
                let decodedMsg = metadataObj.stringValue
                
                AdminEventDM.checkIfUserExist(adminNo: decodedMsg!, onComplete: {(student) in
                    if student.userId != "" {
                        //Create event attendance
                        AdminEventDM.createAttendance(student: student, event: self.event!, onComplete: {(msg) in
                            if msg == "OK"{
                                self.qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
                                self.messageLabel.text = "Attendance Taken"
                            }
                        })
                    }else{
                        self.messageLabel.text = "Invalid QR Code"
                    }
                })
            }
        }
    }
    
    @IBAction func closeQRModal(sender: Any){
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
