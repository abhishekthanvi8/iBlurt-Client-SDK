//
//  UserValidateRequest.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


struct UserValidateRequest  : Codable {
    var email : String = ""
    var otp : String = ""
    var licenseKey: String = ""
    
    
    enum CodingKeys : String, CodingKey {
        case email = "email"
        case otp = "otp"
        case licenseKey = "lc"
        
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(otp, forKey: .otp)
        try container.encode(licenseKey, forKey: .licenseKey)
        
    }
    
    
}
