//
//  BlurtWelcomeViewController.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 24/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import UIKit

class BlurtWelcomeViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var termPloicyLabel: UILabel!
    @IBOutlet weak var startChatButton: UIButton!
    var userProfile:  UserProfileModel? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userProfile = BlurtPrefrenceManager.getUserData()
        self.userNameLabel.text = "Hi, " + (userProfile?.name)!
        
    }
    
    
    @IBAction func startChatButtonAction(_ sender: Any) {
        callStartChatAPI()
    }
    
    
    
    func callStartChatAPI() -> Void {
        BlurtProgress.showProgressBar()
        let request = BaseRequest()
        request.userId = (userProfile?.userId)!
        
        // Calling Start Chat API
        BlurtApi.startChat(request: request){ result in
            switch result {
            case .success(let data):
                if data.errorStatus{
                    showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                }else{
                    let vc = BlurtChatViewController.fromMainStoryboard()
                    vc.chatSessionId = (data.chatResponse?.chatSessionId)!
                    self.navigationController?.pushViewController(vc, animated: true)
                    print(data.errorMessage)
                }
                BlurtProgress.dismissProgressBar()
            case .failure(let error):
                BlurtProgress.dismissProgressBar()
                print("Falied to Start Chat :  ",error)
            }
        }
    }
    
}
