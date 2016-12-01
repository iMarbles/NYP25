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
    
    //Login User
    static func loginUser(username: String, password: String) -> Void{
        
        let ref = FIRDatabase.database().reference().child("users/")
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                for user in snapshot.children
                {
                    let u = user as! FIRDataSnapshot
                    if(u.key == username){
                        //Do hashing to determine password (for future)
                        //var hashPwd = sha256(password)
                        
                        if(password == u.childSnapshot(forPath: "password").value as! String){
                            //Check if user is admin, save uId, password
                            
                        }
                    }
                }
            })
    } //End of login user function
    
}
