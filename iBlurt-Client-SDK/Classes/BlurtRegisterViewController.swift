//
//  BlurtRegisterViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 24/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit

class BlurtRegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var termPolicyLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var email = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTF.text = email
        
    }
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        self.creatUserAccountAPI()
    }
    
    
    func creatUserAccountAPI() -> Void {
        if (emailTF.text?.isEmpty)! {
            showAlertBox(errorTitle: "Error", errorMessage: "Please Enter Email", sender: self)
        }else if (nameTF.text?.isEmpty)! {
            showAlertBox(errorTitle: "Error", errorMessage: "Please Enter Name", sender: self)
        }else{
            BlurtProgress.showProgressBar()
            //Calling API
            BlurtApi.createCustomerAccount(request: createAccountRequest()){ result in
                switch result {
                case .success(let data):
                    if data.errorStatus{
                        showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                    }else{
                        self.openWelcomeScreen(userProfile: data.userProfile!)
                    }
                    BlurtProgress.dismissProgressBar()
                case .failure(let error):
                    BlurtProgress.dismissProgressBar()
                    print("Falied to Register User :  ",error)
                }
            }
        }
    }
    
    func createAccountRequest() -> CreateAccountRequest {
        var request = CreateAccountRequest()
        request.email = emailTF.text!
        request.name = nameTF.text!
        request.deviceType = DEVICE_TYPE
        request.licenseKey = Blurt.LICENSE_KEY
        request.locale = userLocale!
        request.appVersion = SDK_VERSION
        
        return request
    }
    
    
    func openWelcomeScreen(userProfile: UserProfileModel) -> Void {
        let encoder = JSONEncoder()
        BlurtPrefrenceManager.set(value:try! encoder.encode(userProfile) as AnyObject, key: BlurtPrefrenceManager.USER_DETAILS)
        let vc = BlurtWelcomeViewController.fromMainStoryboard()
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    
    
}
