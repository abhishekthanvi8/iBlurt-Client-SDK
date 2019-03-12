//
//  APIRouter.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    //Auth APIs
    case userAvailability(userAvailablityRequest: UserAvailablityRequest)
    case validateUser(userValidateRequest: UserValidateRequest)
    case createCustomerAccount(createAccountRequest: CreateAccountRequest)
    
    //Chat APIs
    case startChat(baseRequest: BaseRequest)
    case getAllMessagesBySessionId(fetchMessageRequest: FetchMessageRequest)
    case updateSocketId(updateSocketIdRequest: UpdateSocketIdRequest)
    case updateFcmToken(fcmRequestModel: FcmRequestModel)
    case sendChatFeedback(fcmRequestModel: ChatFeedbackRequest)
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .userAvailability:
            fallthrough
        case .validateUser:
            fallthrough
        case .createCustomerAccount:
            fallthrough
        case .startChat:
            fallthrough
        case .getAllMessagesBySessionId:
            fallthrough
        case .updateSocketId:
            fallthrough
        case .sendChatFeedback:
            fallthrough
        case .updateFcmToken:
            return .post
            
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .userAvailability:
            return USER_AVAIL
        case .validateUser:
            return USER_VALIDATE
        case .createCustomerAccount:
            return CREATE_USER
        case .startChat:
            return START_CHAT
        case .getAllMessagesBySessionId:
            return FETCH_MESSAGES
        case .updateSocketId:
            return UPDATE_SOCKET_ID
        case .updateFcmToken:
            return UPDATE_FCM
        case .sendChatFeedback:
            return CHAT_FEEDBACK
        }
    }
    
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .userAvailability(let userAvail):
            return userAvail.asDictionary
        case .validateUser(let validateRequest):
            return validateRequest.asDictionary
        case .createCustomerAccount(let request):
            return request.asDictionary
        case .startChat(let request):
            return request.asDictionary
        case .getAllMessagesBySessionId(let request):
            return request.asDictionary
        case .updateSocketId(let request):
            return request.asDictionary
        case .updateFcmToken(let request):
            return request.asDictionary
        case .sendChatFeedback(let request):
            return request.asDictionary
        }
    }
    
    
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = K.getBaseUrl()
        let finalUrl = try url.asURL()
        
        var urlRequest = URLRequest(url: (finalUrl.appendingPathComponent(path)))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
    
}


// MARK: - Defined Constant Keys used in API calls and Server BaseUrls
struct K {
    struct Server {
        static let STAGING = "https://blurtdemo.bitnamiapp.com/"
        static let PRODUCTION = "https://goblurt.in/"
    }
    
    static func getBaseUrl() -> String {
        var url = ""
        
        #if DEBUG
        url =  K.Server.STAGING
        #else
        url =  K.Server.PRODUCTION
        #endif
        
        return url
    }
    
    
}

