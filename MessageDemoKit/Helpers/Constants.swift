//
//  Constants.swift
//
//  Created by wolf.
//  Copyright © 2020 Subhu aka wolf . All rights reserved.
//

import Foundation
import UIKit


typealias SSCompletionBlock               =  (_ result: NSDictionary, _ error: Error?, _ success: Bool, _ message:String) -> Void
typealias SSBCompletionBlock              =  (_ result: NSDictionary, _ message: String, _ success: String) -> Void
typealias SSBUrlBlock                     =  (_ url: URL?, _ message: String, _ success: Bool) -> Void



let kAppName:String                       =  "AtoZ"



let APPDELEGATE                           =  UIApplication.shared.delegate as! AppDelegate
//let SceneDe = SceneDelegate.


let No_Internet                           =  "Internet connection not available."
let Error_msg                             =  "Something went wrong! Please try again or later."


