//
//  UserAvailablityRequest.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


struct UserAvailablityRequest  : Codable {
    var email : String = ""
    
    
    enum CodingKeys : String, CodingKey {
        case email = "email"
        
    }
}
