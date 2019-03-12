//
//  StartChatResponse.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


class StartChatResponse : BaseResponse {
    
    var chatResponse : ChatResponse? = nil
    
    enum CodingKeys : String, CodingKey {
        case chatResponse = "response"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatResponse = try container.decode(ChatResponse.self, forKey: .chatResponse)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}

class ChatResponse : Codable{
    var chatSessionId: String = ""
    var chatStatus: String = ""
    var existingChat: Bool = false
    
    enum CodingKeys : String, CodingKey {
        case chatSessionId = "chat_session_id"
        case chatStatus = "chat_status"
        case existingChat = "existing_chat"
    }
}
