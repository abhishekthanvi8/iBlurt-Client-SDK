//
//  BlurtFeedbackViewController.swift
//  Blurt
//
//  Created by Abhishek Thanvi on 08/03/19.
//  Copyright © 2019 Abhishek Thanvi. All rights reserved.
//

import UIKit
import Cosmos

class BlurtFeedbackViewController: UIViewController {
    
    
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var submitButton: UIButton!
    var chatSessionId = ""
    var updateNavigationStack = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.updateNavigationStack {
            self.navigationController?.viewControllers.remove(at: self.navigationController!.viewControllers.count - 2)
        }
        
    }
    
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.callSendChatFeedback()
    }
    
    func callSendChatFeedback() -> Void {
        if ratingView.rating == 0.0 {
            showAlertBox(errorTitle: "Error", errorMessage: "Please select star rating", sender: self)
        }else{
            BlurtProgress.showProgressBar()
            var request = ChatFeedbackRequest()
            request.chatId = self.chatSessionId
            request.rating = Int(self.ratingView.rating)
            request.userId = BlurtPrefrenceManager.getUserData()?.userId ?? "0"
            //Calling API
            BlurtApi.sendChatFeedback(request: request){ result in
                switch result {
                case .success(let data):
                    if data.errorStatus{
                        showAlertBox(errorTitle: "Error", errorMessage: data.errorMessage, sender: self)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    BlurtProgress.dismissProgressBar()
                case .failure(let error):
                    BlurtProgress.dismissProgressBar()
                    print("Falied to send User feedback :  ",error.localizedDescription)
                }
            }
        }
    }
    
}
