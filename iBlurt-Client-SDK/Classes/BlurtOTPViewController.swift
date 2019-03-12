//
//  BlurtOTPViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 24/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit

class BlurtOTPViewController: UIViewController {
    
    
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var thirdTF: UITextField!
    @IBOutlet weak var fourthTF: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var userEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTF.delegate = self as? UITextFieldDelegate
        secondTF.delegate = self as? UITextFieldDelegate
        thirdTF.delegate = self as? UITextFieldDelegate
        fourthTF.delegate = self as? UITextFieldDelegate
        
        
        firstTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        secondTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        thirdTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        fourthTF.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        
        if (text?.utf16.count)! >= 1 {
            switch textField{
            case firstTF:
                secondTF.becomeFirstResponder()
            case secondTF:
                thirdTF.becomeFirstResponder()
            case thirdTF:
                fourthTF.becomeFirstResponder()
            case fourthTF:
                fourthTF.resignFirstResponder()
            default:
                break
            }
        }else if (text?.utf16.count)! == 0{
            switch textField{
            case fourthTF:
                thirdTF.becomeFirstResponder()
            case thirdTF:
                secondTF.becomeFirstResponder()
            case secondTF:
                firstTF.becomeFirstResponder()
            case firstTF:
                firstTF.resignFirstResponder()
            default:
                break
            }
        }
    }
    
    
    @IBAction func resendButtonAction(_ sender: Any) {
        self.callUserAvailabilityAPI()
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        self.callValidateUserAPI()
    }
    
    
    
    func callUserAvailabilityAPI() -> Void {
        BlurtProgress.showProgressBar()
        var request = UserAvailablityRequest()
        request.email = userEmail
        
        //Calling User Availability API
        BlurtApi.findUserAvailability(request: request){ result in
            switch result {
            case .success(let data):
                if data.errorStatus{
                    showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                }else{
                    showAlertBox(errorTitle: "success", errorMessage: "OTP send to your email", sender: self)
                }
                BlurtProgress.dismissProgressBar()
            case .failure(let error):
                BlurtProgress.dismissProgressBar()
                print("Falied to Check User Availability :  ",error)
            }
        }
    }
    
    
    
    func callValidateUserAPI() -> Void {
        
        if (self.firstTF.text?.isEmpty)! || (self.secondTF.text?.isEmpty)! || (self.thirdTF.text?.isEmpty)! || (self.fourthTF.text?.isEmpty)! {
            
            showAlertBox(errorTitle: "Error", errorMessage: "Please Enter OTP", sender: self)
            return
        }
        
        BlurtProgress.showProgressBar()
        var request = UserValidateRequest()
        request.email = userEmail
        request.otp = self.firstTF.text! + self.secondTF.text! + self.thirdTF.text! + self.fourthTF.text!
        request.licenseKey = Blurt.LICENSE_KEY
        
        //Calling Validate User API
        BlurtApi.validateUser(request: request){ result in
            switch result {
            case .success(let data):
                if data.errorStatus{
                    showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                }else{
                    if data.userProfile?.userStatus == NEW_USER{
                        self.openRegisterScreen()
                    }else if data.userProfile?.userStatus == USER_FOUND{
                        self.openWelcomeScreen(userProfile: data.userProfile!)
                    }
                }
                BlurtProgress.dismissProgressBar()
            case .failure(let error):
                BlurtProgress.dismissProgressBar()
                print("Falied to Validate User :  ",error)
            }
        }
    }
    
    
    func openRegisterScreen() -> Void {
        let vc = BlurtRegisterViewController.fromMainStoryboard()
        vc.email = self.userEmail
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    
    func openWelcomeScreen(userProfile: UserProfileModel) -> Void {
        let encoder = JSONEncoder()
        BlurtPrefrenceManager.set(value:try! encoder.encode(userProfile) as AnyObject, key: BlurtPrefrenceManager.USER_DETAILS)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Blurt", bundle: nil)
        let welcomeVC = storyBoard.instantiateViewController(withIdentifier: "WelNA") as! UINavigationController
        self.present(welcomeVC, animated: true, completion: nil)
        
    }
    
    
}
