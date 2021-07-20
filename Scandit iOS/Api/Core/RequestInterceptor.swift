//
//  RequestInterceptor.swift
//  Scandit iOS
//
//  Created by 67881458 on 20/05/2020.
//  Copyright © 2020 Informática El Corte Inglés S.A. All rights reserved.
//

import Foundation
import Alamofire

enum RefreshTokenError: Error {
    case badRequestBody
}

final class RequestInterceptor: Alamofire.RequestInterceptor {
    
    let refreshUrlRequest : URLRequestConvertible!
    let refreshingSemaphore : DispatchSemaphore
    let dispatchQueue: DispatchQueue
    
    init(refreshUrlRequest: URLRequestConvertible) {
        self.refreshUrlRequest = refreshUrlRequest
        self.refreshingSemaphore = DispatchSemaphore(value: 1)
        self.dispatchQueue = DispatchQueue(label: "interceptorQueue", qos: .utility, attributes: .concurrent)
    }
    //adaptador de la request
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        self.dispatchQueue.async(qos: .background, flags: .enforceQoS) {
            
            if self.refreshingSemaphore.wait(timeout: DispatchTime.now() + 20) == .timedOut {
                completion(.failure(AppError.unexpectedError))
                return
            }
            
            guard let authToken = SessionManager.shared().getSessionToken() else {
                return //TODO: ERROR??
            }
            
            var urlRequest = urlRequest
            
            /// Set the Authorization header value using the access token.
            urlRequest.setValue("Bearer " + authToken, forHTTPHeaderField: "Authorization")
            
            completion(.success(urlRequest))
            
            self.refreshingSemaphore.signal()
            
        }
        
    }
    private func refreshToken(completion: @escaping(Result<AuthCredentials?, Error>) -> Void) {
        
        guard let token = SessionManager.shared().getAuthToken(),
              let refreshToken = SessionManager.shared().getRefreshToken() else {
            print("WARNING: TRY TO REFRESH TOKEN WITH EMPTY SESSION")
            return
        }
        
        print("REFRESH TOKEN------")
        print("User role: \(SessionManager.shared().activeUserRole.keystoreSessionId)")
        print("Current token: \(token)")
        print("Refresh token \(refreshToken)")
        
        let parameters : Parameters = ["token" : token,
                                       "refreshToken" : refreshToken]
        
        let bodyEncoder = JSONEncoding()
        
        do {
            let refreshRequest = try bodyEncoder.encode(self.refreshUrlRequest, with: parameters)
            ApiCore.shared().request(refreshRequest, completion: completion)
        } catch {
            completion(.failure(RefreshTokenError.badRequestBody))
            print("CANNOT ENCODE REFRESH BODY PARAMETERS")
        }
        
    }
}
