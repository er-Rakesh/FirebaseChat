//
//  Helper.swift
//
//  Created by wolf.
//  Copyright © 2020 Subhu aka wolf . All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

//import JTProgressHUD
import UserNotifications

public class Helper : NSObject{
    
    private static var sharedH: Helper = {
        return Helper()
    }()
    
    
    private override init() {
        super.init()
    }
    
    class func shared() -> Helper {
        return sharedH
    }
    
    class func setFirstRun(){
        UserDefaults.standard.set("NO", forKey: "FirstRun")
        UserDefaults.standard.synchronize()
    }
    class func isFirstRun() -> Bool{
        if UserDefaults.standard.object(forKey: "FirstRun") != nil{
            return false
        }else{
            return true
        }
        
    }
    
    public func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }
    
    public class func isNetworkAvailable() -> Bool {
        
        var zeroAddress        = sockaddr_in()
        zeroAddress.sin_len    = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
    
    func getTimeStamp() -> String {
        return String(format: "%.f",(Date().timeIntervalSince1970 * 1000))
    }
    
    func convertDateToTimestamp(date:String, format:String) -> Double{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: date)
        return (date?.timeIntervalSince1970)!
    }
    
    func convertTimeStamp(timeStamp:Double ,toTimeFormat:String) -> String{
        
        let fromDate = Date(timeIntervalSince1970: timeStamp/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = toTimeFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: fromDate)
    }
    
    func convertDateFormater(date: String,inputDateFormate: String , outputDateFormate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormate
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = outputDateFormate
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        var timeStamp = ""
        if (date != nil)
        {
            timeStamp = dateFormatter.string(from: date!)
        }
        return timeStamp
    }
    
    func convertStringDate(date: String,inputDateFormate: String , outputDateFormate: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormate
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let datea = dateFormatter.date(from: date)
        return datea!
    }
    
    func dateInFormat(DateFormat: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: Date())
    }
    
    func changeRootStoryBoard(sbName:String) {
        let storyboard = UIStoryboard(name:sbName, bundle: nil).instantiateInitialViewController()
        var options = UIWindow.TransitionOptions()
        options.direction = .toRight
        options.duration = 0.0
        options.style = .easeInOut
        UIApplication.shared.windows.first?.setRootViewController(storyboard!, options: options)
    }
    
    func changeRootViewController(sbName:String, vc:String) {
        let storyboard = UIStoryboard(name:sbName, bundle: nil).instantiateViewController(withIdentifier: vc)
        var options = UIWindow.TransitionOptions()
        options.direction = .toBottom
        options.duration = 0.0
        options.style = .easeInOut
        UIApplication.shared.windows.first?.setRootViewController(storyboard, options: options)
    }
    
    func changeRootLogout(sbName:String,navC:String, vc:String) {
        let navi = UIStoryboard(name:sbName, bundle: nil).instantiateViewController(withIdentifier: navC) as! UINavigationController
        let viewC = UIStoryboard(name:sbName, bundle: nil).instantiateViewController(withIdentifier: vc)
//        let storyboard = UIStoryboard(name:sbName, bundle: nil).instantiateViewController(withIdentifier: vc)
        navi.viewControllers = [viewC]
        var options = UIWindow.TransitionOptions()
        options.direction = .toBottom
        options.duration = 0.0
        options.style = .easeInOut
        UIApplication.shared.windows.first?.setRootViewController(navi, options: options)
    }
    
    
    func setDeviceID(value:String){
        
        UserDefaults.standard.set(value, forKey: "deviceID")
        UserDefaults.standard.synchronize()
    }
    
    func getAuthToken() -> String {
        return (UserDefaults.standard.object(forKey: "AuthToken") ?? "1234656") as! String
    }
    
    
    func setAuthToken(value:String){
        UserDefaults.standard.set(value, forKey: "AuthToken")
        UserDefaults.standard.synchronize()
    }
    
    func getFCMToken() -> String {
        return (UserDefaults.standard.object(forKey: "FCMToken") ?? "1234656") as! String
    }
    
    
    func setFCMToken(value:String){
        UserDefaults.standard.set(value, forKey: "FCMToken")
        UserDefaults.standard.synchronize()
    }
    
    func getDeviceID() -> String {
        return UserDefaults.standard.object(forKey: "deviceID") as? String ?? "13456"
    }
    
    func setCartKey(value:String){
        UserDefaults.standard.set(value, forKey: "CartKey")
        UserDefaults.standard.synchronize()
    }
    
    func getCartKey() -> String {
        return UserDefaults.standard.object(forKey: "CartKey") as? String ?? ""
    }
    
    func setLogin(value:Bool) {
        UserDefaults.standard.set(value, forKey: "login")
        UserDefaults.standard.synchronize()
    }
    
    func isLogin() -> Bool {
        if UserDefaults.standard.object(forKey: "login") != nil{
            return UserDefaults.standard.object(forKey: "login") as! Bool
        }else{
            return false
        }
    }
    
    func setPushONOFF(value:Bool) {
        UserDefaults.standard.set(value, forKey: "PushONOFF")
        UserDefaults.standard.synchronize()
    }
    
    func getPushONOFF() -> Bool {
        if UserDefaults.standard.object(forKey: "PushONOFF") != nil{
            return UserDefaults.standard.object(forKey: "PushONOFF") as! Bool
        }else{
            return true
        }
    }
    
    func setUserData(userID:String,Firstname:String,Lastname:String, mobileNumber:String, image:String,countryCode:String,email:String) {
        UserDefaults.standard.set(userID, forKey: "userID")
        UserDefaults.standard.set(Firstname, forKey: "firstName")
        UserDefaults.standard.set(Lastname, forKey: "lastName")
        UserDefaults.standard.set(mobileNumber, forKey: "mobileNumber")
        UserDefaults.standard.set(image, forKey: "imagePro")
        UserDefaults.standard.set(countryCode, forKey: "countryCode")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.synchronize()
    }
    
    func setProfileImage(value:String){
        UserDefaults.standard.set(value, forKey: "imagePro")
        UserDefaults.standard.synchronize()
    }
    
    func getProfileImage()->String{
        return UserDefaults.standard.object(forKey: "imagePro") as?  String  ?? ""
    }
    
//    func setUserData(value:UserData){
//        UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: "UserData")
//        UserDefaults.standard.synchronize()
//    }
//    
//    func getUserData() -> UserData?{
//        var userAddress: UserData!
//        if let data = UserDefaults.standard.value(forKey: "UserData") as? Data {
//            userAddress = try? PropertyListDecoder().decode(UserData.self, from: data)
//            return userAddress!
//        } else {
//            return nil
//        }
//        
//    }
    //
    func deleteDefaultAddress(){
        UserDefaults.standard.set(nil, forKey: "DefaultAddress")
        UserDefaults.standard.synchronize()
    }
    
    func getMobileCode()->String{
        return UserDefaults.standard.object(forKey: "countryCode") as?  String  ?? ""
    }
    
    func getMobileNumber()->String{
        return UserDefaults.standard.object(forKey: "mobileNumber") as?  String  ?? ""
    }
    
    func getUserFullName()->String{
        return (UserDefaults.standard.object(forKey: "firstName") as! String) + " " + (UserDefaults.standard.object(forKey: "lastName") as! String)
    }
    
    func getFirstName()->String{
        return (UserDefaults.standard.object(forKey: "firstName") as! String)
    }
    
    func getLastName()->String{
        return  (UserDefaults.standard.object(forKey: "lastName") as! String)
    }
    
    func getUserRating()->String{
        return UserDefaults.standard.object(forKey: "avg_rating") as! String
    }
    
    func getUserData() -> NSDictionary {
        return ["firstName":UserDefaults.standard.object(forKey: "firstName") as? String ?? "self",                "lastName":UserDefaults.standard.object(forKey: "lastName") as? String ?? "",
                "mobileNumber":UserDefaults.standard.object(forKey: "mobileNumber") as! String,"countryCode":UserDefaults.standard.object(forKey: "countryCode") as! String,"email":UserDefaults.standard.object(forKey: "email") as! String] as NSDictionary
    }
    
    func getUserID() -> String {
        return (UserDefaults.standard.object(forKey: "userID") as? String ) != nil ? UserDefaults.standard.object(forKey: "userID") as! String : ""
    }
    
    func getEmail() -> String {
        if UserDefaults.standard.object(forKey: "email") != nil{
            return UserDefaults.standard.value(forKey: "email") as! String
        }else{
            return ""
        }
    }
    
    func setEmail(value:String){
        UserDefaults.standard.set(value, forKey: "email")
        UserDefaults.standard.synchronize()
    }
    
    func getUsername() -> String {
        if UserDefaults.standard.object(forKey: "username") != nil{
            return UserDefaults.standard.value(forKey: "username") as! String
        }else{
            return ""
        }
    }
    
    func setUsername(value:String){
        UserDefaults.standard.set(value, forKey: "username")
        UserDefaults.standard.synchronize()
    }
    
    func getPassword() -> String {
        if UserDefaults.standard.object(forKey: "password") != nil{
            return UserDefaults.standard.value(forKey: "password") as! String
        }else{
            return ""
        }
    }
    
    func setPassword(value:String){
        UserDefaults.standard.set(value, forKey: "password")
        UserDefaults.standard.synchronize()
    }
    
    func appDelegate () -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    // MARK: - Alert
    func showAlert(msg:String) {
        let alert = UIAlertController(title: kAppName, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first?.rootViewController?.topMostViewController() .present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: --------- CONVERT DECTIONARY NULL TO NIL
    func convertAllDictionaryValueToNil(_ dict: NSMutableDictionary) -> NSDictionary
    {
        
        let arrayOfKeys = dict.allKeys as NSArray
        for i in 0..<arrayOfKeys.count
        {
            if (dict.object(forKey: arrayOfKeys.object(at: i))) is NSNull
            {
                dict .setObject("" as AnyObject, forKey: arrayOfKeys.object(at: i) as! String as NSCopying)
            }
        }
        
        return dict
    }
    
    func Logout() {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.changeRootLogout(sbName: "Main", navC: "NavC", vc: "LoginVC")
//            self.changeRootStoryBoard(sbName: "Main")
//            self.changeRootViewController(sbName: "Main", vc: "LoginVC")
        }
        //        let di = self.getDeviceID()
        //        let email = self.getEmail()
        //        let password = self.getPassword()
        
        //self.setDeviceID(value: di)
        //        self.setEmail(value: email)
        //        self.setPassword(value: password)
        
        
        Helper.setFirstRun()
        
    }
    
    public class func isPresented(view:UIViewController) -> Bool {
        if view.presentingViewController != nil {
            return true
        } else if view.navigationController?.presentingViewController?.presentedViewController == view.navigationController  {
            return true
        } else if view.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
}

