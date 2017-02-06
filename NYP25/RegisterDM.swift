
import UIKit
import Firebase
import FirebaseStorage

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
    
    
    
    //Login User
    static func getUsers(admin: String, username: String, onComplete: @escaping (Array<Student>) -> Void) {

        let ref = FIRDatabase.database().reference().child("users/")
        
        var sList : Array<Student> = Array()
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                for user in snapshot.children
                {
                    let u = user as! FIRDataSnapshot
                    
                    let s = Student()
                    
                    s.userId = u.key.uppercased()
                    s.username = (u.childSnapshot(forPath: "username").value as! String).lowercased()
                    sList.append(s)
                    
                }
               onComplete(sList)
        })
    }
    
    static func uploadDisplayPic(dp: NSData, adm: String) {
        let storage = FIRStorage.storage().reference().child("/UserPhoto/\(adm)")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        storage.put(dp as Data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                
                //store downloadURL at database
                FIRDatabase.database().reference().child("users/\(adm)").updateChildValues(["displayPhotoUrl" : downloadURL])
            }
            
        }
    }
    
    static func createAccount(s : Student, dp : NSData?){
        let ref = FIRDatabase.database().reference().child("users/\(s.userId)/")
//        s.userId = adminNumber!
//        s.isAdmin = 0
//        s.password = password!//sending as plaintext first, DM should hash
//        s.school = school!
//        s.name = fullName!
//        s.username = username!
//        s.points = 0
//        s.bio = bioTv.text
        
        let sha : Data = sha256(s.password)!
        let hashed =  sha.map { String(format: "%02hhx", $0) }.joined()
        ref.setValue([
            "bio" : s.bio!,
            "isAdmin" : 0,
            "name" : s.name,
            "points" : 0,
            "school" : s.school,
            "username" : s.username,
            "password" : hashed
            ])
        
            uploadDisplayPic(dp: dp!, adm: s.userId)
        
        let ref2 = FIRDatabase.database().reference().child("users/\(s.userId)/badges/default")
        ref2.updateChildValues(["icon" : "https://firebasestorage.googleapis.com/v0/b/nyp25-e7815.appspot.com/o/Badges%2FqcBBexbc5.png?alt=media&token=767798a4-e6bf-4e8e-ac99-f03714430edf", "isDisplay" : 1])

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
    }}
