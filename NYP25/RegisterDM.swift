
import UIKit
import Firebase

class RegisterDM: NSObject {
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
    
    static func createUser(user : String) {
//        let ref = FIRDatabase.database().reference()
//        ref.child("users/").child("new").setValue(user)
    }
    
    //Login User
    static func getUsers(admin: String, username: String, onComplete: @escaping (Array<Student>) -> Void) {

        let ref = FIRDatabase.database().reference().child("users/")
        
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                for user in snapshot.children
                {
                    var sList : Array<Student> = Array()
                    let u = user as! FIRDataSnapshot
                    
                    let s = Student()
                    
                    s.userId = u.key.lowercased()
                    s.username = (u.childSnapshot(forPath: "username").value as! String).lowercased()
                    
                    sList.append(s)
                    
                    
                }
//               onComplete(sList)
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
