//
//  Utility.swift
//  MVVMLogin
//
//  Created by TBS17 on 3/16/21.
//

import Foundation
import MKProgress

func showProgressIn(viewcotroller: UIViewController){
    MKProgress.config.circleBorderColor = .orange
    MKProgress.config.hudType = .radial
}

func hideProgress(){
    MKProgress.hide()
}

func apiLog(url: String, params: [String : AnyHashable], error: String, response: [String : Any]) {    
    print("*********************************************************")
    print("API : \(url)")
    print("---------------------------------------------------------")
    print("Params   : \(params)")
    print("---------------------------------------------------------")
    print("API error : \(error)")
    print("---------------------------------------------------------")
    print("API Response : \(response)")
    print("*********************************************************")
}

func topViewController() -> UIViewController?{
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if var topController = keyWindow?.rootViewController {
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        while let navViewController = topController as? UINavigationController {
            if let vc = navViewController.viewControllers.first{
                topController = vc
            }
        }

        return topController;
    }
    return nil
}

func alertView(viewController : UIViewController, title: String?, message: String?, buttons: [String], alertViewStyle: UIAlertController.Style, completionHandler: @escaping((_ index : Int) -> Void)) {
    let win = UIWindow(frame: UIScreen.main.bounds)
    let vc = UIAlertController(title: title, message: message, preferredStyle: alertViewStyle)
    for (index, button) in buttons.enumerated() {
        let actionStyle : UIAlertAction.Style = (button == AlertButtonTitle.CANCEL && alertViewStyle == .actionSheet) ? .cancel : .default
        let action = UIAlertAction(title: button, style: actionStyle) { (action) in
            win.isHidden = true
            win.removeFromSuperview()
            completionHandler(index)
        }
        vc.addAction(action)
    }
    let topVC = UIViewController()
    topVC.view.backgroundColor = .clear
    win.rootViewController = topVC
    win.windowLevel = .alert + 1
    win.makeKeyAndVisible()
    topVC.present(vc, animated: true, completion: nil)
}

func getDateFromString(_ date:String) -> Date?{
    return Date.init(dateString: date)
}

func getStringFromData(_ date:Date) -> String?{
    let format = DateFormatter()
    format.dateFormat = "MMM d, yyyy"
    return format.string(from: date)
}

extension Date {
    init(dateString:String) {
        self = Date.iso8601Formatter.date(from: dateString)!
    }

    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                          .withTime,
                                          .withDashSeparatorInDate,
                                          .withColonSeparatorInTime]
        return formatter
    }()
}
