//
//  BlurtProgress.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


import SKActivityIndicatorView

class BlurtProgress {
    
    static func showProgressBar(){
        SKActivityIndicator.show()
        // SKActivityIndicator.show("", userInteractionStatus: false)
    }
    
    static func dismissProgressBar(){
        SKActivityIndicator.dismiss()
    }
    
}
