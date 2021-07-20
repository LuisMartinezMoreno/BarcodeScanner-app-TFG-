//
//  ApiCore.swift
//  Scandit iOS
//
//  Created by 67881458 on 20/05/2020.
//  Copyright © 2020 Informática El Corte Inglés S.A. All rights reserved.
//

//SINGLETON CLASS THAT CONTAINS ALL CORE OPERATIONS OVER THE REST API.

import Foundation
import Alamofire
import Combine

final class ApiCore {
    
    private var manager: Alamofire.Session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 999999
        configuration.timeoutIntervalForResource = 999999
        
        #if AVOID_SSL_VERIFY
        
        let serverTrustManager = ServerTrustManager(
            evaluators: [(URL(string: Environment.baseURL)?.host)!: DisabledTrustEvaluator(), //TODO: REVISAR SSL
                         (URL(string: Environment.iecisaBaseUrl)?.host)!: DisabledTrustEvaluator()])
        
        return  Alamofire.Session(
            configuration: configuration,
            serverTrustManager: serverTrustManager
        )
        
        #else
        
        return Alamofire.Session(
            configuration: configuration
        )
        
        #endif
        
    }()
    
    private static var sharedInterceptor: RequestInterceptor?
    
    private static var sharedApiService: ApiCore = {
        let apiService = ApiCore()
        return apiService
    }()
    
    class func shared() -> ApiCore {return sharedApiService}
    
    private init() {}
    
    class func setInterceptor(_ interceptor: RequestInterceptor) {
        ApiCore.sharedInterceptor = interceptor
    }
    
    @discardableResult
    func authenticatedRequest<T: Decodable>(_ request: URLRequestConvertible,
                                            completion:@escaping (Result<T?, Error>) -> Void) -> Request {
        return self.request(request, requiresAuth: true, completion: completion)
    }
    
    @discardableResult
    func request<T: Decodable>(_ request: URLRequestConvertible,
                               completion:@escaping (Result<T?, Error>) -> Void) -> Request {
        return self.request(request, requiresAuth: false, completion: completion)
    }
    
    ///GENERIC REQUEST.
    @discardableResult
    private func request<T: Decodable>(_ request: URLRequestConvertible,
                                       requiresAuth: Bool,
                                       completion:@escaping (Result<T?, Error>) -> Void) -> Request {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.productDateFormat)
        
        if requiresAuth && ApiCore.sharedInterceptor == nil {
            print("Warning: Requires auth but no interceptor is provided in ApiCore config")
        }
        
        return self.manager.request(request, interceptor: requiresAuth ? ApiCore.sharedInterceptor : nil)
            .validate(statusCode: 200..<300)
            .responseDecodable(decoder: decoder, emptyResponseCodes: [200, 201, 204, 205]){[weak self] (response: AFDataResponse<T>) in
                
                switch response.result {
                case .success(let decodable):
                    completion(.success(decodable))
                case .failure(let afError):
                    
                    /// Parche para controlar respuestas validas (204) con body vacío
                    switch afError {
                    case .responseSerializationFailed(let reason):
                        if case .inputDataNilOrZeroLength = reason {
                            completion(.success(nil))
                        } else if case .invalidEmptyResponse = reason {
                            completion(.success(nil))
                        } else {
                            completion(.failure(afError))
                        }
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .timedOut:
                        completion(.failure(AppError.unexpectedError))
                    default:
                        
                        if let error = self?.processAppErrors(decoder, response) {
                            completion(.failure(error))
                        } else {
                            completion(.failure(AppError.unexpectedError))
                        }
                        
                    }
                }
                
            }
    }
    
    func processAppErrors<T:Decodable>(_ decoder: JSONDecoder, _ response: AFDataResponse<T>?) -> Error? {
        
        if let data = response?.data {
            
            do {
                var apiError = try decoder.decode(ApiError.self, from: data)
                apiError.url = response?.request?.url?.absoluteString
                return apiError
            } catch {
            }
            
            do {
                
                let apiErrorArr = try decoder.decode(Array<ApiError>.self, from: data)
                var description = String()
                
                apiErrorArr.forEach { (apiError) in
                    if let desc = apiError.description {
                        description.append("<p>" + desc + "</p>")
                    }
                }
                
                return ApiError(code: "", message: description, url: response?.request?.url?.absoluteString)
                
            } catch {
                let errorMessage = String(data: data, encoding: String.Encoding.utf8)?.replacingOccurrences(of: "\"", with: "")
                return ApiError(code: "\(response?.response?.statusCode ?? 0)", message: errorMessage, url: response?.request?.url?.absoluteString)
            }
            
        } else {
            return AppError.unexpectedError
        }
        
    }
    
    ///CANCEL ALL PENDING REQUESTS
    func cancelAllRequests() {
        self.manager.session.getAllTasks { tasks in
            tasks.forEach {$0.cancel()}
        }
    }
    
}
