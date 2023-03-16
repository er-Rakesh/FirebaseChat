//
//  ChatMessageVC.swift
//  MessageDemoKit
//
//  Created by Emizen tech iMac  on 06/03/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
import SDWebImage
import Photos
import AVKit
import AVFoundation
import QuickLook


struct Recording {
    let fileURL: URL
    let createdAt: Date
}

class ChatMessageVC: UIViewController, UITableViewDelegate, UITableViewDataSource,SetValue {
    
    var uId = ""
    var uPhoto = URL?.self
    var uname = ""
    
    var user2emails = ""
    var user2UID = ""
    var user2Image: URL?
    fileprivate let picker = UIImagePickerController()
    var logoImages: [UIImage] = []
    var imagess : UIImage?
    var videoURL = URL(string: "") //NSURL?
    var imageVideoType = ""
    var lat = ""
    var long = ""
    
    
    private var docReference: DocumentReference?
    var messages = NSMutableArray()
    var user : User?
    var db = Firestore.firestore()
    var ref = Database.database().reference()
    var storage = Storage.storage()
    var storageRef = Storage.storage().reference()
    
    //  private let channel: Channel? = nil
    var imageArry : [UIImage?] = [UIImage(named: "IMG_2")]
    var timer = Timer()
    var room_id = ""
    var channelId = String()
    var imgSend = Data()
    var imgFileName = String()
    var docURl = URL(string: "")
    
    
    var isRecording = false
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    
    @IBOutlet weak var tablemessage: UITableView!
    @IBOutlet weak var txt_Message: UITextField!
    @IBOutlet weak var btnAudioOutlet: UIButton!
    
    var GOOGLE_STATIC_MAP_BASE_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        GOOGLE_STATIC_MAP_BASE_URL =  "https://maps.google.com/maps/api/staticmap?markers=color:red|\(self.lat),\(self.long)&zoom=13&size=400x400&sensor=true&key=\("AIzaSyA81gjjpQGwZNSDDbiw5i56zMr8ITIz0tc")"
        
        
        tablemessage.register(UINib(nibName: "ChatMessageCell", bundle: nil), forCellReuseIdentifier: "ChatMessageCell")
        tablemessage.register(UINib(nibName: "ChatMessageLeftCell", bundle: nil), forCellReuseIdentifier: "ChatMessageLeftCell")
        tablemessage.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")
        tablemessage.register(UINib(nibName: "VideosCell", bundle: nil), forCellReuseIdentifier: "VideosCell")
        tablemessage.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")

        
        self.uId =  UserDefaults.standard.object(forKey: "uid") as! String
      //  self.uname =  UserDefaults.standard.object(forKey: "name") as! String
        
        // self.uPhoto =  UserDefaults.standard.object(forKey: "profileImg") as? UIImage
        print("login......userid",self.uId)
        print("withchat......userid",self.user2UID)
        print("withchat......userimage",self.user2Image)
        
        Create_Room_ID()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presentLocationPicker()
    }
    
    func Location(lat : String,long: String) {
        print("Location",lat, long)
        
        self.lat = lat
         self.long = long
      //   Constant.lat = lat
      //   Constant.lng = long
         let location = GOOGLE_STATIC_MAP_BASE_URL
         if #available(iOS 15.0, *) {
    //     self.loaderView.isHidden = false
         self.insertNewMessage(location, type: "map", name: "")
         } else {
         // Fallback on earlier versions
         }
         
    }
    private func presentLocationPicker() {
        
       
       /*  print(img,name)
         Eminame = name
         AAImage = img//"\(img)"
         print(AAImage)
         
         if Eminame == "Complet" {
         self.imgEmID.image = AAImage
         EmCompletView.isHidden = false
         EmTapHereView.isHidden = true
         
         }else{
         EmCompletView.isHidden = true
         EmTapHereView.isHidden = false
         
         }
         
         }
         */
        
        
        /*
        //  vc = story.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        let vc = LocationVC(coordinates: nil)
        vc.title = "Pick Location"
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
       // vc.delegate = self
        vc.actionLocationclicked = { (result) in
            print(result)
            self.dismiss(animated: true, completion: nil)
            let vc =  LSMapVC.getObject()
            vc.actionLocationclicked = { (lat,long) in
                print(lat,long)
                self.lat = lat
                self.long = long
                Constant.lat = lat
                Constant.lng = long
                let location = Constant.GOOGLE_STATIC_MAP_BASE_URL
                if #available(iOS 15.0, *) {
                    self.loaderView.isHidden = false
                    self.insertNewMessage(location, image: "map", name: "")
                } else {
                    // Fallback on earlier versions
                }
            }
            self.present(vc, animated: true)
        }
        self.present(vc, animated: true)
        */
    }
    
    @IBAction func btnAudioTapped(_ sender: UIButton) {
        if self.txt_Message.text!.count < 1{
            print("strt Recording...")
            isRecording = true
            sender.backgroundColor = .red
            sender.tintColor = .white
            self.recordingStart()
        }
        
    }
    @IBAction func btnLocationTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "LocationVC") as! LocationVC
        secondVC.delegate = self

        self.navigationController?.pushViewController(secondVC, animated: true)
       
    }
    
    
    @IBAction func btnAtteachImageSend(_ sender: Any) {
        
        self.showActionSheetWith(items: ["Camera","Photo Library","Video"], title: kAppName, message: "") { (stringT) in
            if stringT == "Camera"{

                self.picker.allowsEditing = true
                self.picker.sourceType = .camera
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
            }else if stringT == "Photo Library"{
                self.imageVideoType = "Photo Library"

                self.picker.allowsEditing = true
                self.picker.sourceType = .photoLibrary
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
            }else{
                self.imageVideoType = "Video"
                self.picker.allowsEditing = true
                self.picker.sourceType = .savedPhotosAlbum
                self.picker.mediaTypes = ["public.image", "public.movie"]
                self.picker.delegate = self
                self.present(self.picker, animated: true, completion: nil)
            }
           
            
        }
      //  self.insertNewMessage("\(self.imagess)", type:"image", name: "")
    }
    
    
    
    @IBAction func btnSend(_ sender: UIButton) {
        sender.backgroundColor = .clear
        sender.tintColor = .white
        //    let databasePath = databasePath
        if self.txt_Message.text!.count < 1 {
            print("Record Audio...")
            //   self.audioRecorder.stop()
            //      self.isRecording = false
            //      self.fetchRecording()
        }else{
            if #available(iOS 15.0, *) {
                //    self.loaderView.isHidden = false
                self.insertNewMessage(txt_Message.text ?? "", type: "message", name: "")
            } else {
                // Fallback on earlier versions
            }
        }
        self.tablemessage.reloadData()
    }
    
    
    //Create Room id For chat
    
    func Create_Room_ID(){
        var roomIdsArr = NSMutableArray() as! [String]
        roomIdsArr = [self.uId, user2UID]
        let sortedArray = roomIdsArr.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        room_id = sortedArray[0] + "-" + sortedArray[1]
        loadChat(room_id: room_id)
    }
    
    //get message From firebase
    func loadChat(room_id : String){
        //  self.loaderView.isHidden = false
        //        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
        let messagesRef = db.collection("chat").document(room_id).collection("messages")
        messagesRef.order(by: "timestamp", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.messages.removeAllObjects()
                for document in querySnapshot!.documents {
                    self.messages.add(document.data())
                    print(document.data())
                    
                    self.tablemessage.reloadData()
                    //      self.loaderView.isHidden = true
                    self.tablemessage.scrollToBottom(animated: true)
                }
            }
            //   self.loaderView.isHidden = true
        }
        //        })
    }
    /// Save Details On FireBase
    /// - Parameters:
    ///   - message: User type message to Share Some one on Chat
    ///   - image: Share Image and Media
    ///
    @available(iOS 15.0, *)
    func insertNewMessage(_ message: String,type : String,name : String) {
        let date = Date()
//        let formate = DateFormatter()
//        formate.dateFormat = "yyyy-MM-dd HH:mm:ss"//"HH:MM DD,MMM,yyyy"
//
//        let dateStr = date.formatted(date: .numeric, time: .shortened)
//
        let dateStr = date.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
        print(dateStr)
        
        
        var roomIdsArr = NSMutableArray() as! [String]
        roomIdsArr = [self.uId, user2UID]
        let sortedArray = roomIdsArr.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        room_id = sortedArray[0] + "-" + sortedArray[1]
        
        let messagesRef = db.collection("chat").document(room_id).collection("messages")
        //   let uId = UserDefaults.standard.object(forKey: Constant.firID) as! String
        var messageData : [String:Any] = [:]
        
        //Image is a type oF Content To Verify type Of Content User Want To Share
        if type == "message" {
            messageData = [
                "subtype" : "message",
                "senderName": uname,
                "text": message,
                "timestamp": dateStr,
                "id": uId
            ]
            
        }else if type == "image"{
            messageData = [
                "subtype" : "image",
                "senderName": uname,
                "docURL": message,
                "timestamp": dateStr,
                "docName" : name,
                "id": uId
            ]
        }else if type == "videos"{
            messageData = [
                "subtype" : "videos",
                "senderName": uname,
                "videos": message,
                "timestamp": dateStr,
                "docName" : name,
                "id": uId
            ]
        }else if type == "document"{
            messageData = [
                "type" : "document",
                "senderName": uname,
                "docURL": message,
                "timestamp": dateStr,
                "docName" : name,
                "id": uId
            ]
        }else if type == "map" {
            messageData = [
                "subtype" : "map",
                "senderName": uname,
                "docURL": message,
                "timestamp": dateStr,
                "lattitude" : lat,
                "longitude" : long,
                "id": uId
            ]
        }else if type == "audio"{
            messageData = [
                "subtype" : "audio",
                "senderName": uname,
                "docURL": message,
                "timestamp": dateStr,
                "docName" : name,
                "id": uId
            ]
        }else{
        
        
    }

        
        messagesRef.addDocument(data: messageData) { [self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref)")
                self.txt_Message.text = ""
           //  btnAudioOutlet.setImage(UIImage(systemName: "mic"), for: .normal)
                
            }
        }
        
        DispatchQueue.main.async {
            self.loadChat(room_id: self.room_id)
            self.tablemessage.reloadData()
            self.tablemessage.scrollToBottom(animated: true)
        }
        
    }
    func document(data: URL) {
      //  self.loaderView.isHidden = false
        print(data)
        var dataDoc = Data()
        do {
            dataDoc = try! Data(contentsOf: data)
            print(dataDoc.hashValue)
        }
        
        
        let docPath = "\(uId)\(Int(Date.timeIntervalSinceReferenceDate * 1000))\(data.lastPathComponent)"
        let metaData = StorageMetadata()
        metaData.contentType = "Document/\(data.pathExtension)"
        
        var spaceRefrense = storageRef.child(docPath)
        
        let storgePAth =  "gs://lifestyle-76494.appspot.com/Documents/\(docPath)"
        spaceRefrense = storage.reference(forURL: storgePAth)
        
        let dataTask = spaceRefrense.putData(dataDoc ?? Data()) { (metaData,error) in
            guard let medata = metaData else {
                print("Ufff some things Wrong")
                return
            }
            let size = metaData?.size
            spaceRefrense.downloadURL { ur, err in
                guard let downURL = ur  else{
                    print("ufff URL Not get")
                    return
                }
                print(downURL)
                if downURL != nil {
                    if #available(iOS 15.0, *) {
                        self.insertNewMessage((downURL.absoluteString), type:"document", name: data.lastPathComponent)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                print(ur)
            }
        }
    }
    func gallaryImage(imagess: UIImage, fileName: String) {
        //self.loaderView.isHidden = false
        
        let data = imagess.jpegData(compressionQuality: 1.0)
        let imagePath = "\(uId)\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        var spaceRefrense = storageRef.child(imagePath)
        
        let storgePAth =  "gs://messagedemokit.appspot.com/images/\(imagePath)"
        spaceRefrense = storage.reference(forURL: storgePAth)
        
        let dataTask = spaceRefrense.putData(data ?? Data()) { (metaData,error) in
            guard let medata = metaData else {
                print("Ufff some things Wrong")
                return
            }
            let size = metaData?.size
            spaceRefrense.downloadURL { ur, err in
                guard let downURL = ur  else{
                    print("ufff URL Not get")
                    return
                }
                
                if downURL != nil {
                    if #available(iOS 15.0, *) {
                        
                        self.insertNewMessage((ur!.absoluteString), type:"image", name: "")
                    } else {
                        // Fallback on earlier versions
                    }
                }
                print(ur)
                DispatchQueue.main.async {
                    self.tablemessage.reloadData()
                }
          //      let db = Firestore.firestore()
                
          //      db.collection("chat").document(self.uId).setData(["AccountTypeImageURL": ur],merge: true)
                

            }
        }
    }
    
    
    func gallaryvideo(videos: URL, fileName: String) {
        
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        do {
            let data = try Data(contentsOf: videos)
            let imagePath = "\(uId)\(Int(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
            let metaData = StorageMetadata()
            metaData.contentType = "videos"
            
            var spaceRefrense = storageRef.child(imagePath)
            
            let storgePAth =  "gs://messagedemokit.appspot.com/videos/\(imagePath)"
            spaceRefrense = storage.reference(forURL: storgePAth)
            
            let dataTask = spaceRefrense.putData(data ?? Data()) { (metaData,error) in
                guard let medata = metaData else {
                    print("Ufff some things Wrong")
                    return
                }
                let size = metaData?.size
                spaceRefrense.downloadURL { ur, err in
                    guard let downURL = ur  else{
                        print("ufff URL Not get")
                        return
                    }
                    
                    if downURL != nil {
                        if #available(iOS 15.0, *) {
                            
                            self.insertNewMessage((ur!.absoluteString), type:"videos", name: "")
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    print(ur)
                    DispatchQueue.main.async {
                        self.tablemessage.reloadData()
                    }
                    
                }
            }
        }catch let error {
            print(error.localizedDescription)
            
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     
            guard let ImageCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UITableViewCell() }
            guard let cellLeft = tableView.dequeueReusableCell(withIdentifier: "ChatMessageLeftCell", for: indexPath) as? ChatMessageLeftCell else{ return UITableViewCell() }
            
            guard let cellRight = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as? ChatMessageCell   else{ return UITableViewCell() }
            guard let cellVideo = tableView.dequeueReusableCell(withIdentifier: "VideosCell", for: indexPath) as? VideosCell   else{ return UITableViewCell() }
            guard let cellLocation = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell   else{ return UITableViewCell() }
          
       
        
            let data = messages[indexPath.row] as! NSDictionary
         
           let date = data["timestamp"] as! String
         //  let dateSplit : [String] = date.components(separatedBy: ",")
         //  let timeStr = dateSplit[1]
            let timeStr = date
        
        
            //While Sender Name and Current Login User Name Was Same Then Show RightSide Cells
            //Else Left side cell show
            let user2 = data["id"] as? String
            if self.uId == user2 {
                
                //   if (messages[indexPath.row] as AnyObject).sender as? String != self.uId{
                
                if (data["subtype"]) as? String == "message" {
                    cellRight.lblMessageRight?.text = data.object(forKey: "text") as? String
                    cellRight.lblTimeRight.text = timeStr
                    
                    return cellRight
                 
                }else if (data["subtype"]) as? String == "image" {
                    DispatchQueue.main.async {
                        
                        let imgURL = URL(string: (data.object(forKey: "docURL")) as? String ?? "")
                        let data = try? Data(contentsOf: imgURL!)
                        ImageCell.Image_View?.image = UIImage(data: data ?? Data())
                        ImageCell.imageTime.text = timeStr
                    }
                    //    ImageCell.Image_View.sd_setImage(with: URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg" as? String ?? ""))
                    //    ImageCell.Image_View.sd_setImage(with: URL(string: data["docURL"] as? String ?? ""))
                    return ImageCell
                }else if (data["subtype"]) as? String == "videos" {
                    DispatchQueue.main.async {
                        
                        let imgURL = URL(string: (data.object(forKey: "videos")) as? String ?? "")
                        let data = try? Data(contentsOf: imgURL!)
                        let avPlayer = AVPlayer(url: imgURL as! URL);
                        cellVideo.Avplayer?.playerLayer.player = avPlayer;
                        cellVideo.videoTime.text = timeStr

                    }
                    return cellVideo
                }else if (data["subtype"]) as? String == "map" {
                    DispatchQueue.main.async {
                        
                        let urlStr = (data.object(forKey: "docURL") as? String)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                        let imgURL = NSURL(string: urlStr ?? "" )
                        DispatchQueue.main.async {
                            let data = try? Data(contentsOf: (imgURL! as URL))
                            cellLocation.mapLocatioImage.image = UIImage(data: data ?? Data())
                        }
                        
                    }
                    return cellLocation
                }
                
                
            }else{
                

                if (data["subtype"]) as? String == "message"{
                    
                    cellLeft.lblMessageLeft?.text = data.object(forKey: "text") as? String
                    cellLeft.lblTimeLeft.text = timeStr
                    cellLeft.imgUserLeft.sd_setImage(with: URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg"))
                    
                    return cellLeft
                    
                }else if (data["subtype"]) as? String == "image" {
                    DispatchQueue.main.async {
                        
                        let imgURL = URL(string: (data.object(forKey: "docURL")) as? String ?? "")
                        let data = try? Data(contentsOf: imgURL!)
                        ImageCell.Image_View?.image = UIImage(data: data ?? Data())
                        ImageCell.imageTime.text = timeStr
                        //   ImageCell.Image_View.sd_setImage(with: URL(string: data["docURL"] as? String ?? ""))
                    }
                    
                    return ImageCell
                }else if (data["subtype"]) as? String == "videos" {
                    DispatchQueue.main.async {
                        
                        let imgURL = URL(string: (data.object(forKey: "videos")) as? String ?? "")
                        let data = try? Data(contentsOf: imgURL!)
                        
                     //   let url = NSURL(string: imgURL);
                        let avPlayer = AVPlayer(url: imgURL as! URL);
                        cellVideo.Avplayer?.playerLayer.player = avPlayer;
                        cellVideo.videoTime.text = timeStr

                    }
                    //    ImageCell.Image_View.sd_setImage(with: URL(string: "https://cdn.stocksnap.io/img-thumbs/960w/sea-ocean_5AQ9OI606F.jpg" as? String ?? ""))
                    //    ImageCell.Image_View.sd_setImage(with: URL(string: data["docURL"] as? String ?? ""))
                    return cellVideo
                }else if (data["subtype"]) as? String == "map" {
                    DispatchQueue.main.async {
                        
                        let urlStr = (data.object(forKey: "docURL") as? String)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                        let imgURL = NSURL(string: urlStr ?? "" )
                        DispatchQueue.main.async {
                            let data = try? Data(contentsOf: (imgURL! as URL))
                            cellLocation.mapLocatioImage.image = UIImage(data: data ?? Data())
                        }
                        
                    }
                    return cellLocation
                }
                
            }
            
            
            
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
            return cellLeft
       
      
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
extension ChatMessageVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: - Image picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if self.imageVideoType == "Photo Library" {
            let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            imagess =  chosenImage
            if let chosenImage = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [chosenImage], options: nil)
                let asset = result.firstObject
                print(asset?.value(forKey: "filename"))
                
                gallaryImage(imagess: imagess!, fileName: "\(asset)")
            }
            
            dismiss(animated: true, completion: nil)
        }else if self.imageVideoType == "Video" {
            
            
            videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL? as! URL
            print(videoURL!)
            do {
                let asset = AVURLAsset(url: videoURL as! URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                //  imgView.image = thumbnail
                //  videoURL =  asset
                gallaryvideo(videos: videoURL as! URL, fileName: "\(imgGenerator)")
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
            }
            dismiss(animated: true, completion: nil)
        }else{
            let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            imagess =  chosenImage
            if let chosenImage = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [chosenImage], options: nil)
                let asset = result.firstObject
                print(asset?.value(forKey: "filename"))
                
                gallaryImage(imagess: imagess!, fileName: "\(asset)")
            }
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated:true, completion: nil)
        }
        func documentsDirectory() -> URL
        {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
    }
}
//MARK: - Record Audio Functions and AVAudioRecorderDelegate
extension ChatMessageVC : AVAudioRecorderDelegate{
    func recordingStart(){
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date()).m4a")
        print(audioFilename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            isRecording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func fetchRecording() {
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        print(directoryContents)
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio))
            recordings.append(recording)
        }
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        let audioURL =  recordings[0].fileURL
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func uploadAudio(data: URL) {
        print(data)
        var dataDoc = Data()
        do {
            dataDoc = try! Data(contentsOf: data)
            print(dataDoc.hashValue)
        }
        
        
        let docPath = "\(uId)\(Int(Date.timeIntervalSinceReferenceDate * 1000))\(data.lastPathComponent)"
        let metaData = StorageMetadata()
        metaData.contentType = "Audio/\(data.pathExtension)"
        
        var spaceRefrense = storageRef.child(docPath)
        
        let storgePAth =  "gs://messagedemokit.appspot.com/Audio/\(docPath)"
        spaceRefrense = storage.reference(forURL: storgePAth)
        
        let dataTask = spaceRefrense.putData(dataDoc ?? Data()) { (metaData,error) in
            guard let medata = metaData else {
                print("Ufff some things Wrong")
                return
            }
            let size = metaData?.size
            spaceRefrense.downloadURL { ur, err in
                guard let downURL = ur  else{
                    print("ufff URL Not get")
                    return
                }
                print(downURL)
                if downURL != nil {
                    if #available(iOS 15.0, *) {
                        //       self.loaderView.isHidden = false
                        
                        self.insertNewMessage((downURL.absoluteString), type:"audio", name: data.lastPathComponent)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                print(ur)
            }
        }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //  self.loaderView.isHidden = false
        let timeInterVell = recorder.currentTime
        self.uploadAudio(data: recorder.url)
    }
    
    
    
}

//MARK: - UITEXTFIELD DELEGATE METHOD
extension ChatMessageVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //While Message TextField is impty That time Button Icon is Record else Send Arrow
        if textField.text!.count > 0{
            btnAudioOutlet.setImage(UIImage(systemName: "arrow.forward.circle"), for: .normal)
            return true
        }else if textField.text!.count < 1 { //mic
            btnAudioOutlet.setImage(UIImage(systemName: "arrow.forward.circle"), for: .normal)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        btnAudioOutlet.setImage(UIImage(systemName: "arrow.forward.circle"), for: .normal)
        textField.resignFirstResponder()  //if desired
        //        self.view.frame.origin.y = 0
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.count == 0{
            btnAudioOutlet.setImage(UIImage(systemName: "mic"), for: .normal)
            //            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
