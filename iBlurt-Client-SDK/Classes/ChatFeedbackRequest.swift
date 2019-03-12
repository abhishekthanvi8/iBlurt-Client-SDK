//
//  ChatFeedbackRequest.swift
//  Blurt
//
//  Created by Abhishek Thanvi on 08/03/19.
//  Copyright © 2019 Abhishek Thanvi. All rights reserved.
//

import Foundation

struct ChatFeedbackRequest  : Codable {
    
    var userId : String = ""
    var chatId : String = ""
    var rating : Int = 0
    
    
    enum CodingKeys : String, CodingKey {
        case userId = "user_id"
        case chatId = "chat_id"
        case rating = "rating"
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(chatId, forKey: .chatId)
        try container.encode(rating, forKey: .rating)
        
        
    }
    
}
