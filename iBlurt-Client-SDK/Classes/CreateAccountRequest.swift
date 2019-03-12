//
//  CreateAccountRequest.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


struct CreateAccountRequest  : Codable {
    
    var licenseKey : String = ""
    var appVersion : String = ""
    var deviceType : String = ""
    var locale : String = ""
    var email : String = ""
    var name : String = ""
    
    enum CodingKeys : String, CodingKey {
        case licenseKey = "lc"
        case appVersion = "av"
        case deviceType = "dt"
        case locale = "locale"
        case email = "email"
        case name = "name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(appVersion, forKey: .appVersion)
        try container.encode(deviceType, forKey: .deviceType)
        try container.encode(locale, forKey: .locale)
        try container.encode(name, forKey: .name)
        try container.encode(licenseKey, forKey: .licenseKey)
        
    }
    
}
