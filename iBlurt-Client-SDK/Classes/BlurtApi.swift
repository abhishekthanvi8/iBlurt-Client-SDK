//
//  BlurtApi.swift
//  SocketDemo
//
//  Created by Abhishek Thanvi on 25/09/18.
//  Copyright © 2018 Abhishek Thanvi. All rights reserved.
//

import Foundation
import Alamofire
import XCGLogger


class BlurtApi {
    
    
    /// Performing Network Requests
    ///
    /// - Parameters:
    ///   - route: URL with paramters required for the specific API call
    ///   - decoder: decodes response in json for mapping in model class
    ///   - completion: completion handler
    /// - Returns: Response of the API call.
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        return AF.request(route)
            .debugLog()
            .responseJSONDecodable (decoder: decoder){(response: DataResponse<T>)  in
                completion(response.result)
        }
    }
    
    ///
    ///
    /// - Parameters:
    ///   - findUserAvailability:
    ///   - completion:
    static func findUserAvailability(request: UserAvailablityRequest, completion: @escaping (Result<BaseResponse>) -> Void) {
        performRequest(route: APIRouter.userAvailability(userAvailablityRequest: request), completion: completion)
    }
    
    
    
    ///
    ///
    /// - Parameters:
    ///   - validateUser:
    ///   - completion:
    static func validateUser(request: UserValidateRequest, completion:@escaping (Result<AuthResponseModel>)->Void) {
        performRequest(route: APIRouter.validateUser(userValidateRequest: request), completion: completion)
    }
    
    ///
    ///
    /// - Parameters:
    ///   - createCustomerAccount:
    ///   - completion:
    static func createCustomerAccount(request: CreateAccountRequest, completion:@escaping (Result<AuthResponseModel>)->Void) {
        performRequest(route: APIRouter.createCustomerAccount(createAccountRequest: request), completion: completion)
    }
    
    
    ///
    ///
    /// - Parameters:
    ///   - startChat:
    ///   - completion:
    static func startChat(request: BaseRequest, completion:@escaping (Result<StartChatResponse>)->Void) {
        performRequest(route: APIRouter.startChat(baseRequest: request), completion: completion)
    }
    
    
    ///
    ///
    /// - Parameters:
    ///   - getMessageAPI:
    ///   - completion:
    static func getMessageAPI(request: FetchMessageRequest, completion:@escaping (Result<FetchAllMessageResponse>)->Void) {
        performRequest(route: APIRouter.getAllMessagesBySessionId(fetchMessageRequest: request), completion: completion)
    }
    
    
    ///
    ///
    /// - Parameters:
    ///   - updateSocketIdAPI:
    ///   - completion:
    static func updateSocketId(request: UpdateSocketIdRequest, completion:@escaping (Result<BaseResponse>)->Void) {
        performRequest(route: APIRouter.updateSocketId(updateSocketIdRequest: request), completion: completion)
    }
    
    
    
    
    ///
    ///
    /// - Parameters:
    ///   - updateFcmTokenAPI:
    ///   - completion:
    static func updateFcmToken(request: FcmRequestModel, completion:@escaping (Result<BaseResponse>)->Void) {
        performRequest(route: APIRouter.updateFcmToken(fcmRequestModel: request), completion: completion)
    }
    
    ///
    ///
    /// - Parameters:
    ///   - sendChatFeedback:
    ///   - completion:
    static func sendChatFeedback(request: ChatFeedbackRequest, completion:@escaping (Result<BaseResponse>)->Void) {
        performRequest(route: APIRouter.sendChatFeedback(fcmRequestModel: request), completion: completion)
    }
    
    
}

//// MARK: -
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        // log.debug("=======================================")
        debugPrint("=======================================")
        // log.debug(self)
        debugPrint(self)
        //  log.debug("=======================================")
        debugPrint("=======================================")
        #endif
        return self
    }
}


