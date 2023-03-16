//
//  ChatVC.swift
//  AtoZ
//
//  Created by Emizen Tech Subhash on 01/04/22.
//

import UIKit

import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase


class ChatVC: UIViewController {
    
    
//    @IBOutlet weak var lblUserName:UILabel!
//    @IBOutlet weak var lblOnlineOffline:UILabel!
//    @IBOutlet weak var btnVideoCall:UIBarButtonItem!
//    @IBOutlet weak var btnAudioCall:UIBarButtonItem!
//
//
//    @IBOutlet weak var imgUser: UIImageView!
//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var tableMessage:UITableView!
//    @IBOutlet weak var txtMessage:UITextField!
//    @IBOutlet weak var btnSend:UIButton!
    
    
    private let database = Firestore.firestore()
    private var messageReference: CollectionReference?
    
    private var messages: [FireMessage] = []
    private var messagesNew: [[FireMessage]] = []
    
    private var messageListener: ListenerRegistration?
    
    
    
    var channel: String?
    
    var recId:Int?
    var recName:String?
    var recProfileImage:String?
    
    var fireUser : ChatUsers?
    // var myId = String()
    // var friendId = String()
    //var chennalID = String()
    //  let currentuser = sender(senderID: "self", displayName:"ios Academy")
    //  let otheruser = sender(senderID: "self", displayName:"ios Academy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
        /*
        //        getVideoToken()
       // self.channel = self.videoTokenData.channelName
         CheckUserBlockOrNot()
        self.setData() 
        
        btnSend.setTitle("", for: .normal)
        txtMessage.delegate = self
        tableMessage.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")
        let chanelId = Helper.shared().randomString(length: 12)
        
        let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
        let receiverID = "\(recId ?? 0)"
        if channel?.count ?? 0 == 0{
            CheckChanelAlreadyCreated(sendID: uid, recID: receiverID, pass: "First")
            Firestore.firestore().collection("User").document("\(uid)").updateData(["isViewId":"\(recId ?? 0)"])
        }else{
            listenToMessages()
            Firestore.firestore().collection("User").document("\(uid)").updateData(["isViewId":"\(fireUser?.userID ?? "0")"])
        }
       
        NotificationCenter.default.addObserver(self, selector: #selector(UpdateViewUserId), name: NSNotification.Name("ChangeViewuserID"), object: nil)
        
       // friendId = "62"
    }
    

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
        Firestore.firestore().collection("User").document("\(uid)").updateData(["isViewId":"0"])
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @objc func UpdateViewUserId(_ nott:NSNotification){
        let di = nott.userInfo as? [String:Any]
        if di?["type"] as? String == "forground"{
            let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
            Firestore.firestore().collection("User").document("\(uid)").updateData(["isViewId":"\(fireUser?.userID ?? "0")"])
        }else{
            let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
            Firestore.firestore().collection("User").document("\(uid)").updateData(["isViewId":"0"])
        }
    }
    
    fileprivate func appendMessageData() {

        let groupList: [Date : [FireMessage]] = Dictionary.init(grouping: messages) { (element) -> Date in
            let dt = Date(milliseconds: element.sentDate)
            let dtft = DateFormatter()
            dtft.dateFormat = "dd-MM-yyyy"
            let stdt = dtft.string(from: dt)
            let dtNew = dtft.date(from: stdt)
            return dtNew ?? Date()
        }

        let groupedKey: [Date] = groupList.keys.sorted()
        self.messagesNew.removeAll()
        groupedKey.forEach { (element) in
            self.messagesNew.append(groupList[element] ?? [])
        }
        self.tableMessage.reloadData()
    
        DispatchQueue.main.async {
            let rw = (self.messagesNew.last?.count ?? 0)
            let sec = self.messagesNew.count ?? 0
            if rw > 0 && sec > 0{
                self.tableMessage.scrollToRow(at: (IndexPath(row: rw-1, section: sec-1)), at: .bottom, animated: true)
            }
        }
    }
    
    private func listenToMessages() {
        
        guard channel != nil else {
           // navigationController?.popViewController(animated: true)
            CreateChannelFirstTime()
            return
        }
        
        messageReference = database.collection("channel/\(channel!)/Message")
        
        messageListener = messageReference?.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                self.appendMessageData()
            })
            
        }
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
       // listenToMessages()

      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        self.txtMessage.resignFirstResponder()
        messageListener?.remove()
    }
    
    func CheckChanelAlreadyCreated(sendID:String,recID:String,pass:String){
        let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
        let receiverID = "\(recId ?? 0)"
        database.collection("channel").whereField("senderID", isEqualTo: sendID).whereField("reciverId", isEqualTo: recID).getDocuments(completion: { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            if snapshot.documents.count>0{
                snapshot.documents.forEach { change in
                    
                    guard let chennal = FireChennal(document: change) else {
                        return
                    }
                    self.channel = chennal.chennalID
                    print(chennal)
                    self.fireUser = chennal.particepentData
                    self.setData()
                    self.listenToMessages()
                    
                }
            }else{
                if pass == "Second"{
                  print("Channel not found")
                    self.channel = nil
                    self.CreateChannelFirstTime()
                }else{
                    self.CheckChanelAlreadyCreated(sendID: recID, recID: sendID, pass: "Second")
                }
              
            }

            
        })
        
//        database.collection("channel").whereField("senderID", isEqualTo: receiverID).whereField("reciverId", isEqualTo: uid).getDocuments(completion: { [weak self] querySnapshot, error in
//            guard let self = self else { return }
//            guard let snapshot = querySnapshot else {
//                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
//                return
//            }
//            snapshot.documents.forEach { change in
//
//                guard let chennal = FireChennal(document: change) else {
//                    return
//                }
//
//                print(chennal)
//
//            }
//
//        })
    }
    func setData(){
      
        self.imgUser.sd_setImage(with: URL(string: MainImageUrlPost +  (fireUser?.userData.userimage ?? "") ), placeholderImage: UIImage(named: "groupPlaceholder"))
        self.lblName.text = fireUser?.userData.userName ?? "Unknown"
    }
    
    func CreateChannelFirstTime() {
        let chanelId = Helper.shared().randomString(length: 20)
        let senID = uDefault.value(forKey: APP_USER_ID) as? Int ?? 0
        

//        self.myId = self.fireUser?.userID ?? ""
//        self.friendId = message.sender
        self.channel = chanelId
        var buddyFcmToken:String?
         Firestore.firestore().collection("User").document("\(recId ?? 0)").getDocument { dsp, er in
            let di = dsp?.data()
            buddyFcmToken = di?["fcm"] as? String
             let chennalDoc = [
                 "channelId" :chanelId,
                 "senderID":"\(senID)",
                 "lastMessage":"",
                 "lastmessageTime": Date().millisecondsSince1970,
                 "reciverId":"\(self.recId ?? 0)",
                 "particepent"  : ["\(self.recId ?? 0)", "\(senID)"],
                 "particepentData" : [["userData" :["userName":uDefault.value(forKey: APP_USER_NAME) as? String ?? "","userimage":uDefault.value(forKey: App_User_Img) as? String ?? "","fcm":uDefault.value(forKey: APP_FCM_TOKEN) as? String ?? ""], "userID":"\(senID)"],["userData" :["userName":self.recName ?? "unnamed","userimage":self.recProfileImage ?? "","fcm":buddyFcmToken ?? ""], "userID":"\(self.recId ?? 0)"]]
                 
             ] as [String : Any]
             print(chennalDoc)
            
            // let chatD = ChatUsersData(userName: uDefault.value(forKey: APP_USER_NAME) as? String ?? "", userimage:uDefault.value(forKey: App_User_Img) as? String ?? "", fcmT: uDefault.value(forKey: APP_FCM_TOKEN) as? String ?? "")
             let chatchatUDForUDetailData = ChatUsersData(userName: self.recName ?? "", userimage: self.recProfileImage ?? "", fcmT: buddyFcmToken ?? "")
             self.fireUser =  ChatUsers(userData: chatchatUDForUDetailData, userID:"\(self.recId ?? 0)")
             self.setData()
             self.listenToMessages()
             self.database.collection("channel").document(chanelId).setData(chennalDoc)
            
        }

    }
    
    // MARK: - Helpers
    private func save(_ message: FireMessage) {
        messageReference?.addDocument(data: message.representation) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            
            self.tableMessage.scrollToBottom(animated: true)
        }
        
        //
        let messageDoc = [
            "channelId" :message.chennalID,
            "senderID":message.sender,
            "lastMessage":message.content,
            "lastmessageTime":message.sentDate,
            "reciverId":self.fireUser?.userID ?? ""
        ] as [String : Any]
        
        
        
        let newRef  =  self.database.collection("channel").document(channel!)
        newRef.setData(messageDoc)
        
        let chennalDoc = [
            "channelId" :message.chennalID,
            "senderID":message.sender,
            "lastMessage":message.content,
            "lastmessageTime":message.sentDate,
            "reciverId":self.fireUser?.userID ?? "",
            "particepent"  : [self.fireUser?.userID, message.sender],
            "particepentData" : [["userData" :["userName":uDefault.value(forKey: APP_USER_NAME) as? String ?? "","userimage":uDefault.value(forKey: App_User_Img) as? String ?? "","fcm":uDefault.value(forKey: APP_FCM_TOKEN) as? String ?? ""], "userID":message.sender],["userData" :["userName":self.fireUser?.userData.userName,"userimage":self.fireUser?.userData.userimage,"fcm":fireUser?.userData.fcmToken ?? ""], "userID":self.fireUser?.userID ?? ""]]
            
        ] as [String : Any]
//        self.myId = self.fireUser?.userID ?? ""
//        self.friendId = message.sender
       // self.chennalID = message.chennalID
        database.collection("channel").document(self.channel!).setData(chennalDoc)
    }
    
    private func insertNewMessage(_ message: FireMessage) {
        if messages.contains(message) {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        //        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        //        let shouldScrollToBottom = tableMessage.isAtBottom && isLatestMessage
        
       // tableMessage.reloadData()
      //  tableMessage.scrollToRow(at: (IndexPath(row: messages.count-1, section: 0)), at: .bottom, animated: true)
        
        //        if shouldScrollToBottom {
        //            tableMessage.scrollToBottom(animated: true)
        //        }

    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = FireMessage(document: change.document) else {
            return
        }
        insertNewMessage(message)
    }
    
   
    // MARK: - @IBAction
    
    @IBAction func backBtnDidTap(sender:UIBarButtonItem){
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func sendBtnDidTap(sender:UIButton){
        if channel == nil{
            return
        }
      //  var idsss = Helper.shared().getUserID()
        let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
 
        if txtMessage.text?.replacingOccurrences(of: " ", with: "").count ?? 0 > 0{
            let fm = FireMessage(user:uid, content:txtMessage.text!, chennalID: channel!)
            save(fm)
            sendPushNotification(message: txtMessage.text ?? "send", fcmtoken: fireUser?.userData.fcmToken ?? "")
            txtMessage.text = ""
            txtMessage.resignFirstResponder()
            
           
        }
        
//        if txtMessage.text?.replacingOccurrences(of: " ", with: "").count ?? 0 > 0{
//            let fm = FireMessage(user: Helper.shared().getUserID(), content:txtMessage.text!, chennalID: channel!)
//            save(fm)
//            txtMessage.text = ""
//        }
    }
        
    func sendPushNotification(message: String, fcmtoken: String) {
//        var token: String?
//        for person in self.users {
//            if toUser == person.username && person.firebaseToken != nil {
//                token = person.firebaseToken
//            }
//        }
        Firestore.firestore().collection("User").document("\(fireUser?.userID ?? "0")").getDocument { dsp, er in
            let di = dsp?.data()
            let viedID = di?["isViewId"] as? String
            let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
            if uid == viedID{
                print("dont send Notification")
            }else{
                if fcmtoken != nil {
                    var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("key=AAAArhZ5WcA:APA91bE8mwihBDMfTCUhJMACN36EoT00RlLZeNPU-7Goyz7N8lOR7wHuNhixQK3dZUegZyJvq0j0qNMc8FR0vp2pSIbVLF5mSq5pq5vXvFEX290ttlbG8sqTdyA6qiexdARgdIDCl09d", forHTTPHeaderField: "Authorization")
                    let json = [
                        "to" : fcmtoken,
                        "priority" : "high",
                        "notification" : [
                            "body" : message,
                            "title": "Received a new message from \(uDefault.value(forKey: APP_USER_NAME) ?? "User")"
                            
                           
                        ],
                        "data":["type":"chatMessage","recId":uid]
                    ] as [String : Any]
                    print(json)
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        request.httpBody = jsonData
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, error == nil else {
                                print("Error=\(error)")
                                return
                            }

                            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                                // check for http errors
                                print("Status Code should be 200, but is \(httpStatus.statusCode)")
                                print("Response = \(response)")
                            }

                            let responseString = String(data: data, encoding: .utf8)
                            print("responseString = \(responseString)")
                        }
                        task.resume()
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }

    }
    
    
    @IBAction func videoCallBtnDidTap(sender:UIButton){
//        if self.videoTokenData == nil{
//            //            self.getVideoToken(moveToCall: true)
//            return
//        }
//        DispatchQueue.main.async {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoCallVC") as! VideoCallVC
//            vc.tokenData = self.videoTokenData
//            vc.delegate = APPDELEGATE
//            APPDELEGATE.appleCallKit.tokenAgoraData = self.videoTokenData
//            APPDELEGATE.appleCallKit.startOutgoingCall(of: self.fireUser.userID)
//            self.present(vc, animated: true)
//        }
        
    }
    
//    @IBAction func audioCallBtnDidTap(sender:UIButton){
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "IncomingCallVC") as! IncomingCallVC
//        vc.tokenData = self.videoTokenData
//        vc.delegate = APPDELEGATE
//        APPDELEGATE.appleCallKits.tokenAgoraData = self.videoTokenData
//        APPDELEGATE.appleCallKits.startOutgoingCallAudio(of: self.fireUser.userID)
//        self.present(vc, animated: true)
//    }
    
    
}
extension ChatVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        messagesNew.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  messagesNew[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uid = "\(uDefault.value(forKey: APP_USER_ID) ?? 0)"
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let mNew = messagesNew[indexPath.section]
        if mNew[indexPath.row].sender == uid{
            cell.update(type: .right, message: mNew[indexPath.row], userImage: "")
        }else{
            cell.update(type: .left, message: mNew[indexPath.row], userImage: MainImageUrlPost + (fireUser?.userData.userimage ?? ""))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lblDate = UILabel(frame: CGRect(x: 20, y: 5, width: tableView.frame.width-40, height: 30))
        lblDate.textAlignment = .center
        lblDate.textColor = .appGrayColor
        let dtu = messagesNew[section]
        let dt = Date(milliseconds: dtu.first?.sentDate ?? 0)
        let com = Calendar.current.compare(dt ?? Date(), to: Date(), toGranularity: .day)
        if com == .orderedSame{
            lblDate.text = "Today"
        }else{
            let dtft = DateFormatter()
            dtft.dateFormat = "dd MMM yyyy"
            let stdt = dtft.string(from: dt)
            lblDate.text = stdt
        }
        

        vi.addSubview(lblDate)
        return vi
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
    
}


extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
          self.view.endEditing(true)
      }

}

extension ChatVC{
    func CheckUserBlockOrNot() {
        self.showLoader()
       
     
        let mut = UserChatUserIsBlockMutation(userChatUserIsBlockId: recId ?? 0)

        Apollo.shared.client.perform(mutation: mut) { result in
            self.hideLoader()
            switch result {
             case .success(let graphQLResult):
               
                if graphQLResult.data == nil || graphQLResult.errors != nil{
                    print(graphQLResult.errors as Any)
                     let errDi =  graphQLResult.errors?.first?.extensions
                    let erMsg = errDi?["code"] as? String
                    self.showToast(message: graphQLResult.errors?.first?.message ?? erMsg ?? "Something went wrong,please try again")
                }else{
 
                    print(graphQLResult.data as Any)
                   let st = graphQLResult.data?.userChatUserIsBlock.status ?? ""
                    if st == "0"{
                        self.showToast(message: "User Blocked")
                        //self.navigationController?.popViewController(animated: true)
                        self.txtMessage.isUserInteractionEnabled = false
                    }
                  
                    
                    //self.GetUserListByHobbyIdApi()
                }
                
             case .failure(let error):
               print("Failure! Error: \(error)")
                self.showToast(message: error.localizedDescription )
             }
        }
    }
}

*/
