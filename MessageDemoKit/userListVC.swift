//
//  userListVC.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 01/03/23.
//

import UIKit


import Firebase
//import FirebaseStorage
import FirebaseAuth
//import FBSDKCoreKit
//import FBSDKLoginKit
import FirebaseDatabase
//import JSQMessagesViewController
import FirebaseFirestore
import FirebaseCore
import SDWebImage



class userListVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
  //  var userArray = [String:Any]()
  //  var uid = ""
  //  var photourl = URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg")
    var email = ""
    var currentUId = Auth.auth().currentUser?.uid
       
    
    private let database = Firestore.firestore()
    private var chennalReference: CollectionReference?
    
  //  private var chennals: [FireChennal] = []
    
    @IBOutlet weak var TableUserList: UITableView!

    let ref = Database.database().reference()
    var Channel = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.23, green:0.73, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.title = "Messages"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        self.currentUId =  UserDefaults.standard.object(forKey: "uid") as! String
      

        print(currentUId)
        print(email)
    //    print(userImage)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   //     self.tabBarController?.tabBar.isHidden = false
        self.getAllUsersFirebae()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    private func getToChennals() {
//
//        let docRef = database.collection("chat").document()
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
//
//    }
    
    func getAllUsersFirebae() {
        self.Channel.removeAllObjects()
        let userRef = ref.child("Channels")
        
     // let currentUId = UserDefaults.standard.string(forKey: Constant.firID)
        userRef.observe(.childAdded) { snapshot,arg  in
            print(snapshot)

            guard let userData = snapshot.value as? [String: Any],
                    
                  let emails = userData["email"] as? String ,
                  let userId = userData["userID"] as? String,
                  let userImage = userData["image"] as? String
                    
                  
            else { return }


            if userId != self.currentUId {
                let userArray = ["email":emails,"userId":userId,"image":userImage] // //Message(text: text, sender: sender)
                self.Channel.add(userArray)
            }
            print(self.Channel)
         //   self.Channel.add(self.userArray)
            self.TableUserList.reloadData()
           
        }
        
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Channel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userlistCell", for: indexPath) as! userlistCell
       let data =  Channel[indexPath.row] as! NSDictionary
        cell.lblMessage.text? = data["email"] as? String ?? ""
        cell.Imageview.sd_setImage(with: URL(string: data["image"] as! String))

        
      //  cell.Imageview.sd_setImage(with: URL(string: data["image"] as! String), placeholderImage: UIImage(named: ""))

     //   cell.Imageview.image = UIImage(named: data["image"] as? String ?? "")
        
    //    cell.Imageview?.image = UIImage(systemName: "google.png")
        /*
         cell.lblTime.text = Helper.shared().convertTimeStamp(timeStamp: Double(chennals[indexPath.row].lastmessageTime), toTimeFormat: "hh:mm a")
         cell.lblNewCount.isHidden = true
         cell.lblOnlineOffline.isHidden = true
         cell.lblMessage.text = chennals[indexPath.row].lastMessage
         
         cell.lblUserName.text = chennals[indexPath.row].particepentData.userData.userName
         cell.imgUser.kf.setImage(with: URL(string: chennals[indexPath.row].particepentData.userData.userimage),placeholder: UIImage(named: "AppIcon"))
         */
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //  return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = Channel[indexPath.row] as! NSDictionary
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc  = storyBoard.instantiateViewController(withIdentifier: "ChatMessageVC") as! ChatMessageVC
                 vc.user2emails = dict["emails"] as? String ?? ""
                 vc.user2UID = dict["userId"] as? String ?? ""
                 vc.user2Image = dict["image"] as? URL
               self.navigationController?.pushViewController(vc, animated:true)
        
      
    }
    
}
