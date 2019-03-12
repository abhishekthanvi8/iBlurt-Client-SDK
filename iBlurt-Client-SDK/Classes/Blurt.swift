//
//  Blurt.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 26/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

class Blurt {
    
    static var LICENSE_KEY = ""
    
}


struct NotificationEvent {
    var eventType: String?
    var chatId : String?
    var senderId: String?
    
    
    init(dict: [String:Any]) {
        if let obj = dict["TYPE"] {
            eventType = "\(obj)"
        }
        
        if let obj = dict["chat_id"] {
            chatId = "\(obj)"
        }
        
        if let obj = dict["sender"] {
            senderId = "\(obj)"
        }
    }
}
