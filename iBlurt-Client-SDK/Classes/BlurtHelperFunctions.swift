//
//  BlurtHelperFunctions.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation
import UIKit


///  Showing alertbox with single action
///
/// - Parameters:
///   - errorTitle: Title of the alert string
///   - errorMessage: alert message string
///   - sender: UIViewController from where the function is called
func showAlertBox(errorTitle: String ,errorMessage: String, sender :UIViewController) {
    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    sender.present(alert, animated: true, completion: nil)
}


/// Showing alertbox when internet is not connected
///
/// - Parameter sender: UIViewController from where the function is called
//func showNetWorkErrorBox( sender :UIViewController) {
//    let alert = UIAlertController(title: "Network Error", message: "Please enable your data or wifi connection.", preferredStyle: UIAlertControllerStyle.alert)
//    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//    sender.present(alert, animated: true, completion: nil)
//}

func showNetWorkErrorBox() {
    
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1
    
    let alert2 = UIAlertController(title: "Network Error", message: "Please enable your data or wifi connection.", preferredStyle: .alert)
    let defaultAction2 = UIAlertAction(title: "OK", style: .default, handler: { action in
    })
    alert2.addAction(defaultAction2)
    
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alert2, animated: true, completion: nil)
}



/// Showing alertbox with Single Action Button (For eg: OK)
///
/// - Parameters:
///   - errorTitle: Title of the alert string
///   - errorMessage: alert message string
///   - sender: UIViewController from where the function is called
///   - action: action to be performed when action button clicked
func showAlertBoxwithAction(errorTitle: String ,errorMessage: String, sender :UIViewController, action : UIAlertAction) {
    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(action)
    sender.present(alert, animated: true, completion: nil)
}



/// Showing alertbox with Two Action Buttons (For eg: OK , Cancel)
///
/// - Parameters:
///   - errorTitle: Title of the alert string
///   - errorMessage: alert message string
///   - sender: UIViewController from where the function is called
///   - actionOk: action to be performed when OK action button clicked
///   - actionCancel: action to be performed when Cancel action button clicked
func showAlertBoxwithTwoAction(errorTitle: String ,errorMessage: String, sender :UIViewController, actionOk : UIAlertAction, actionCancel : UIAlertAction) {
    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(actionOk)
    alert.addAction(actionCancel)
    sender.present(alert, animated: true, completion: nil)
}


func getSocketDataDictonary(_ data: [Any]) -> [String: AnyObject]{
    var notificationDict = [String: AnyObject]()
    
    let dataArray = data as NSArray
    let dataString = dataArray[0] as! NSDictionary
    notificationDict = dataString as! [String : AnyObject]
    return notificationDict
}
