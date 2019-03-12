//
//  BlurtValidateViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 24/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit

class BlurtValidateViewController: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Blurt.LICENSE_KEY = Bundle.main.object(forInfoDictionaryKey: "BlurtLicenseKey") as! String
        print(Blurt.LICENSE_KEY)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        self.callUserAvailabilityAPI()
    }
    
    
    
    func callUserAvailabilityAPI() -> Void {
        if (emailTF.text?.isEmpty)! {
            showAlertBox(errorTitle: "Error", errorMessage: "Please Enter Email", sender: self)
        }else{
            BlurtProgress.showProgressBar()
            var request = UserAvailablityRequest()
            request.email = emailTF.text!
            
            //Calling API
            BlurtApi.findUserAvailability(request: request){ result in
                switch result {
                case .success(let data):
                    if data.errorStatus{
                        showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                    }else{
                        let vc = BlurtOTPViewController.fromMainStoryboard()
                        vc.userEmail = self.emailTF.text!
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                    BlurtProgress.dismissProgressBar()
                case .failure(let error):
                    BlurtProgress.dismissProgressBar()
                    print("Falied to Check User Availability :  ",error.localizedDescription)
                }
            }
        }
    }
    
}
