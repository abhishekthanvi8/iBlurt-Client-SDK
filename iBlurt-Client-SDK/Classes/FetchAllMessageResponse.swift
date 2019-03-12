//
//  FetchAllMessageResponse.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

class FetchAllMessageResponse : BaseResponse {
    
    var conversation : [ConversationModel]? = nil
    
    enum CodingKeys: String, CodingKey {
        case conversation = "response"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conversation = try container.decode([ConversationModel].self, forKey: .conversation)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
}
