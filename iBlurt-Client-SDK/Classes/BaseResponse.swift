//
//  BaseResponse.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

public class BaseResponse : Codable {
    var errorStatus: Bool = false
    var errorMessage: String = ""
    var message: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case errorMessage = "err_msg"
        case errorStatus = "err_status"
        case message = "message"
    }
    
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.message = try container.decode(String.self, forKey: .message)
        }
        catch {
            self.message = ""
        }
        
        
        
        
    }
    
}
