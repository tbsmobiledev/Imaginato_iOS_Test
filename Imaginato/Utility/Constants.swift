//
//  Constants.swift
//  MVVMLogin
//
//  Created by TBS17 on 3/16/21.
//

import Foundation
import UIKit

//MARK:- GLOBAL CONSTANTS
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let defaults = UserDefaults.standard

//MARK:- GLOBAL KEY STRINGS
let kAppName                                = "Imaginato"
let kSuccess                                = "status"
let kMessage                                = "message"
let kSomethingWentWrong                     = "Something Went Wrong, Try Again."
let kStatusCode200                          = 200
let kStatusCode201                          = 201
let kStatusCode204                          = 204
let kStatusCode400                          = 400
let kNoInternet                             = "No Internet Connection."

struct AlertButtonTitle {
    static let OK                           = "Ok"
    static let YES                          = "Yes"
    static let NO                           = "No"
    static let CANCEL                       = "Cancel"
}

struct Strings {
    static let emailPrompt                  = "Please enter a valid Email Id"
    static let passwordPrompt               = "Please enter a valid Password, Password should be 6 to 15 characters long."
}
