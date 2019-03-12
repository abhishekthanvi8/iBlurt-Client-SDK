//
//  AuthResponseModel.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation

class AuthResponseModel : BaseResponse {
    
    
    var userProfile : UserProfileModel? = nil
    
    enum CodingKeys: String, CodingKey {
        case userProfile = "response"
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userProfile = try container.decode(UserProfileModel.self, forKey: .userProfile)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
}
