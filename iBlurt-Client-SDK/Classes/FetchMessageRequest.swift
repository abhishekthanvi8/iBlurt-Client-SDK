//
//  FetchMessageRequest.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

class FetchMessageRequest : Codable {
    
    var sessionId : String = ""
    
    private enum CodingKeys: String, CodingKey {
        case sessionId = "chat_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
    }
}
