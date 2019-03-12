//
//  UpdateSocketIdRequest.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 27/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

class UpdateSocketIdRequest : Codable {
    
    var userId : String = ""
    var socketId : String = ""
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case socketId = "socket_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(socketId, forKey: .socketId)
    }
}
