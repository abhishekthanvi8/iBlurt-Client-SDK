//
//  ConversationModel.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation
import RealmSwift

public class ConversationModel : Object, Codable {
    
    @objc dynamic var messageId : Int = 0
    @objc dynamic var msgTempId: Int = 0
    @objc dynamic var message : String = ""
    @objc dynamic var senderId : String = ""
    @objc dynamic var timestamp : String = ""
    @objc dynamic var messageStatus : String? = ""
    @objc dynamic var sessionId : String? = ""
    
    
    enum CodingKeys : String, CodingKey {
        case messageId = "msg_id"
        case message = "msg"
        case senderId = "sentBy"
        case timestamp = "timestamp"
        case messageStatus = "status"
        case sessionId = "chat_id"
        
    }
    
    override public static func primaryKey() -> String? {
        return "msgTempId"
    }
}
