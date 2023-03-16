//
//  ChatMessageVC.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 06/03/23.
//

import UIKit

class ChatMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var user2Name = ""
    var user2UID = ""
    var user2Image: URL?
    var uId = ""
    
    @IBOutlet weak var chatmessage: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.uId =  UserDefaults.standard.object(forKey: "uid") as! String
        print("login......userid",self.uId)
        print("withchat......userid",self.user2UID)
        Create_Room_ID()
    }
    

    //Create Room id For chat
    
    func Create_Room_ID(){
        var roomIdsArr = NSMutableArray() as! [String]
        roomIdsArr = [self.uId, user2UID]
//        let sortedArray = roomIdsArr.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
//        room_id = sortedArray[0] + "-" + sortedArray[1]
//        loadChat(room_id: room_id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//Channel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
  //      let data =  Channel[indexPath.row] as! NSDictionary
  //      cell.lblMessage.text? = data["name"] as? String ?? ""
        
  //      cell.Imageview.sd_setImage(with: URL(string: data["profileImg"] as! String), placeholderImage: UIImage(named: ""))
        
        //    cell.Imageview.image = UIImage(named: data["profileImg"] as? String)
        
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
//        let dict = Channel[indexPath.row] as! NSDictionary
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc  = storyBoard.instantiateViewController(withIdentifier: "ChatMessageVC") as! ChatMessageVC
//        vc.user2Name = dict["name"] as? String ?? ""
//        vc.user2UID = dict["userId"] as? String ?? ""
//        vc.user2Image = dict["profileImg"] as? URL
//        self.navigationController?.pushViewController(vc, animated:true)
//
        
    }
    
}


