//
//  UserProfileModel.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

struct UserProfileModel : Codable {
    
    var name : String = ""
    var userId : String = ""
    var userStatus : String = ""
    var email : String = ""
    
    
    enum CodingKeys : String, CodingKey {
        case name = "name"
        case userId = "uid"
        case userStatus = "status"
        case email = "email"
    }
    
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.name = try container.decode(String.self, forKey: .name)
        }
        catch {
            self.name = ""
        }
        
        do {
            self.userId = try container.decode(String.self, forKey: .userId)
        }
        catch {
            self.userId = ""
        }
        
        do {
            self.email = try container.decode(String.self, forKey: .email)
        }
        catch {
            self.email = ""
        }
        
        
        self.userStatus = try container.decode(String.self, forKey: .userStatus)
        
    }
    
}
