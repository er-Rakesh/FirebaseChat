//
//  MessageVC.swift
//  AtoZ
//
//  Created by Emizen Tech Subhash on 01/04/22.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}


struct FireMessage{
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    let content: String
    let sentDate: Int64
    let sender: String
    let chennalID: String
    
    
    
    init(user: String, content: String,chennalID:String) {
        sender = user
        self.content = content
        sentDate = Date().millisecondsSince1970
        id = nil
        self.chennalID = chennalID
    }
    
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let sentDate = data["timestamp"] as? Int64,
            let senderId = data["senderID"] as? String,
            let message = data ["message"] as? String,
            let chennalID = data ["channelId"] as? String
                
        else {
            return nil
        }
        
        id = document.documentID
        self.sentDate = sentDate
        self.sender = senderId
        self.content = message
        self.chennalID = chennalID
    }
}

// MARK: - DatabaseRepresentation
extension FireMessage: DatabaseRepresentation {
    var representation: [String: Any] {
        let rep: [String: Any] = [
            "timestamp": sentDate,
            "senderID": sender,
            "message" : content,
            "channelId":chennalID
        ]
        return rep
    }
}

// MARK: - Comparable
extension FireMessage: Comparable {
    static func == (lhs: FireMessage, rhs: FireMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: FireMessage, rhs: FireMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}



struct FireChennal{
    
    let reciverID :String
    
    let lastMessage: String
    let lastmessageTime: Int64
    let senderID: String
    let chennalID: String
    let particepent :[String]
    let particepentData : ChatUsers
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard
            let particepents = data["particepent"] as? NSArray,
            let particepentData = data["particepentData"] as? NSArray,
            let reciverId = data["reciverId"] as? String,
            let lastMessage = data ["lastMessage"] as? String,
            let chennalID = data ["channelId"] as? String,
            let lastmessageTime = data ["lastmessageTime"] as? Int64,
            let senderID = data ["senderID"] as? String
             
                
        else {                  
            return nil
        }
        
        var parti : ChatUsers?
        for i in particepentData{
            if let dic  = i as? NSDictionary{
                if dic["userID"] as! String != Helper.shared().getUserID(){
                    let userData = ChatUsersData(userName:(dic["userData"] as! NSDictionary)["userName"] as! String, userimage: (dic["userData"] as! NSDictionary)["userimage"] as! String, fcmT:(dic["userData"] as! NSDictionary)["fcm"] as? String ?? "")
                    parti =  ChatUsers(userData: userData, userID:dic["userID"] as! String)
                }
            }//(dic["userData"] as! NSDictionary)["fcm"] as! String
            //dlj1DZQTYEH0m4-mIlKGc9:APA91bGl0fhRIJKaGTtCPquod4JPXwdgIwOqPrNQ6RpFsPb5sQfv3L7zW5ou3D1-zWNGGgaI4n5Kw1Zh-Em_BbZjbK4SMj3N5KpRo71Yeptq7XUMHxPCHx7Ck0ZbW8PgasGOM9OWjaWU
        }
        
        self.reciverID = reciverId
        self.lastMessage = lastMessage
        self.lastmessageTime = lastmessageTime
        self.senderID = senderID
        self.chennalID = chennalID
        self.particepent = particepents as! [String]
        self.particepentData = parti!
    }
}

//// MARK: - DatabaseRepresentation
//extension FireChennal: DatabaseRepresentation {
//    var representation: [String: Any] {
//        let rep: [String: Any] = [
//            "timestamp": sentDate,
//            "senderID": sender,
//            "message" : content,
//            "channelId":chennalID
//        ]
//        return rep
//    }
//}

// MARK: - Comparable
extension FireChennal: Comparable {
    static func == (lhs: FireChennal, rhs: FireChennal) -> Bool {
        return lhs.chennalID == rhs.chennalID
    }
    
    static func < (lhs: FireChennal, rhs: FireChennal) -> Bool {
        return lhs.lastmessageTime < rhs.lastmessageTime
    }
}

// MARK: - Parti
struct ChatUsers {
    
    let userData: ChatUsersData
    let userID: String
    var isOnline : Bool = false
    
    init(userData: ChatUsersData, userID: String) {
        self.userData = userData
        self.userID = userID
    }
}

// MARK: - UserData
struct ChatUsersData {
    let userName: String
    let userimage: String
    let fcmToken:String?
    init(userName: String, userimage: String,fcmT:String) {
        self.userName = userName
        self.userimage = userimage
        self.fcmToken = fcmT
    }
}
