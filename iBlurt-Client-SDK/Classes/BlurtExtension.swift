//
//  BlurtExtension.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class BlurtThemeButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = BlurtTheme.buttonBgColor.cgColor
        self.setTitleColor(BlurtTheme.buttonTextColor, for: .normal)
        self.setTitle(self.titleLabel?.text?.uppercased(), for: .normal)
    }
}


extension Encodable {
    var asDictionary: Dictionary<String, Any>? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? Dictionary }
    }
}



/// Instantiating ViewController from Main Storyboard
protocol IncarnatableFromBlurtStoryboard {}
extension IncarnatableFromBlurtStoryboard {
    static func fromMainStoryboard(name: String = "Blurt", bundle: Bundle? = nil) -> Self {
        let identifier = String(describing: self)
        guard let viewController = UIStoryboard(name: name, bundle: bundle).instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Cannot instantiate view controller of type " + identifier + " from Main Storyboard")
        }
        return viewController
    }
}
extension UIViewController: IncarnatableFromBlurtStoryboard {}

extension String {
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension Int
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


extension UINavigationItem {
    
    
    
    func setSubTitle(subtitle:String) {
        
        let one = UILabel()
        one.text = "Blurt"
        one.textColor = UIColor.black
        one.font = UIFont.systemFont(ofSize: 17)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.textColor = UIColor.black
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        two.sizeToFit()
        
        
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        
        
        self.titleView = stackView
    }
}

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
}

// Hiding keyboard inside view controller
extension UIViewController {
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
