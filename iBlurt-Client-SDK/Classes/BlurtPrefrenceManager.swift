//
//  BlurtPrefrenceManager.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 26/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation


class BlurtPrefrenceManager {
    
    static let userDefaults = UserDefaults.standard
    
    static var FCM_TOKEN = "firebase_token"
    static var USER_DETAILS = "user_details"
    static var CHAT_SESSION_ID = "session_id"
    
    static  func set(value: AnyObject, key : String) {
        userDefaults.set(value, forKey: key)
    }
    
    static func get(key : String) -> AnyObject? {
        return userDefaults.object(forKey: key) as AnyObject
    }
    
    static func remove(key : String) {
        userDefaults.removeObject(forKey: key)
    }
    
    static func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    static func getUserData() ->  UserProfileModel? {
        var userProfile:  UserProfileModel? = nil
        if isKeyPresentInUserDefaults(key: USER_DETAILS) {
            if let userData = BlurtPrefrenceManager.get(key: USER_DETAILS) as? Data{
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(UserProfileModel.self, from: userData) as UserProfileModel{
                    userProfile = user
                }
            }
        }
        return userProfile
    }
    
}
