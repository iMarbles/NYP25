//
//  LoginDM.swift
//  NYP25
//
//  Created by iOS on 1/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class LoginDM: NSObject {
    //SHA256
    static func sha256(_ string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    
    //Login User
    static func loginUser(username: String, password: String, onComplete: @escaping () -> Void){
        //No such user
        GlobalDM.CurrentUser = User()
        GlobalDM.CurrentUser!.userId = "NIL"

        let ref = FIRDatabase.database().reference().child("users/")
        
        let shaData = sha256(password)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        print(shaHex)
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                for user in snapshot.children
                {
                    let u = user as! FIRDataSnapshot
                    print(u.key)
        
                    if(u.key == username){
                        //Do hashing to determine password (for future)
                        if(shaHex == u.childSnapshot(forPath: "password").value as! String){
                            //Check if user is admin, save uId, password
                            //Not admin
                            //print("IsAdmin: \(u.childSnapshot(forPath: "isAdmin").value as! Int)")
                            if(u.childSnapshot(forPath: "isAdmin").value as! Int == 0){
                                GlobalDM.CurrentUser!.userId = u.key
                                GlobalDM.CurrentUser!.isAdmin = 0
                                //Might add additional fields to load user data
                            }else if(u.childSnapshot(forPath: "isAdmin").value as! Int == 1){
                                //Is Admin
                                GlobalDM.CurrentUser!.userId = u.key
                                GlobalDM.CurrentUser!.isAdmin = 1
                                GlobalDM.CurrentUser!.password = u.childSnapshot(forPath: "password").value as! String
                                GlobalDM.CurrentUser!.school = u.childSnapshot(forPath: "school").value as! String
                            }
                            break;
                        }
                    }
                }
                
                onComplete()
            })
    }
    
    //Admin checking of password
    static func checkPassword(password : String) -> Bool {
        var same = false
        
        let shaData = sha256(password)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        
        if shaHex == GlobalDM.CurrentUser!.password{
            same = true
        }
        
        return same
    }
    
    //Admin changing of password
    static func changePasswordTo(newPwd : String){
        let shaData = sha256(newPwd)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        
         let ref = FIRDatabase.database().reference().child("users/\(GlobalDM.CurrentUser!.userId)")
        
        ref.updateChildValues(["password" : shaHex])
        
        GlobalDM.CurrentUser?.password = shaHex
    }
}
