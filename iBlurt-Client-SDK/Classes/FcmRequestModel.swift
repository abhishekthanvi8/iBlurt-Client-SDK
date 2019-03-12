//
//  FcmRequestModel.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

struct FcmRequestModel  : Codable {
    
    var userId : String = ""
    var fcmToken : String = ""
    var deviceType : String = ""
    var role : String = ""
    
    
    enum CodingKeys : String, CodingKey {
        case userId = "uuid"
        case fcmToken = "fcm_token"
        case deviceType = "dv"
        case role = "role"
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(fcmToken, forKey: .fcmToken)
        try container.encode(deviceType, forKey: .deviceType)
        try container.encode(role, forKey: .role)
        
        
    }
    
}
