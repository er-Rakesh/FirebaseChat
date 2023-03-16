//
//  LoginVC.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 01/03/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics
import GoogleSignIn
import Firebase


class LoginVC: UIViewController {
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    private var chennalReference: CollectionReference?
    private let database = Firestore.firestore()
        // var userData = [String:Any]()

  //  let email = "example@gmail.com"
  //  let password = "testtest"
    
     var currentUId = ""
     var emails = ""
   //  var name = "example"
     var photourl = URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
//                handle = Auth.auth().addStateDidChangeListener { auth, user in
//                    // ...
//                }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //  Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        /*
         Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
         if let error = error as? NSError {
         
     
         } else {
         print("User signs up successfully")
         print("authResult",authResult)
         let newUserInfo = Auth.auth().currentUser
         let email = newUserInfo?.email
         
         }
         }
         */
    
        Auth.auth().signIn(withEmail: EmailText.text!, password: passwordText.text!) { authResult, error in
            // ...
            
             if let user = authResult {
             // The user's ID, unique to the Firebase project.
             // Do NOT use this value to authenticate with your backend server,
             // if you have one. Use getTokenWithCompletion:completion: instead.
                 let uid = user.user.uid
                 let emails = user.user.email ?? ""
                 let photourl = user.user.photoURL
                 UserDefaults.standard.set(uid, forKey: "userID")
             var multiFactorString = "MultiFactor: "
                 for info in user.user.multiFactor.enrolledFactors {
             multiFactorString += info.displayName ?? "[DispayName]"
             multiFactorString += " "
              }
     
                 
                 let userData = ["userID":uid ,
                                 "email": emails ,
                                 "image": "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg",
                                 "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
                 self.currentUId = uid
                 self.emails = emails
                 print(userData)
                 var ref: DatabaseReference!
                 ref = Database.database().reference()
                 ref.child("Channels").child(self.currentUId).setValue(userData)
                  UserDefaults.standard.set(uid, forKey: "uid")
             //     UserDefaults.standard.set(self.name, forKey: "name")
                  UserDefaults.standard.set(self.photourl, forKey: "image")

                 print("ref --", ref!)

                       
                  }
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc  = storyBoard.instantiateViewController(withIdentifier: "userListVC") as! userListVC
           
            vc.currentUId = self.currentUId
            vc.email = self.emails
           // vc.userImage = self.photourl
            self.navigationController?.pushViewController(vc, animated:true)
             }
             
            
        
     /*
        //MARK: - sign in firbase & Register
       
            
        //    Auth.auth().signIn(withEmail: EmailText.text!, password: passwordText.text!) { authResult, error in

            Auth.auth().signIn(withEmail: EmailText.text!, password: passwordText.text!) { response,error in
            //    let userName = self.userDefault.value(forKey: Constant.userName) as! String
                if response != nil {
                    let userID = Auth.auth().currentUser?.uid
                    let userEmail = Auth.auth().currentUser?.email
                    let userData = ["userId":userID ?? "",
                                    "email": userEmail ?? "",
                                    "profileImg": "",
                                   // "phoneNumber": password ,
                                   // "password": password ,
                                    "name": "Nikiii",
                                    "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]
                    
                    print(userData)
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("users").child(userID!).setValue(userData)
                    print("ref --", ref!)
                    
                }else{
                    print(error?.localizedDescription)
                }
            }
        
        */
       
        }
    
}
