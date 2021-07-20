//
//  RequestGenerator.swift
//  Scandit iOS
//
//  Created by 67881458 on 20/05/2020.
//  Copyright © 2020 Informática El Corte Inglés S.A. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestGenerator: URLRequestConvertible {
    var baseUrl: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var queryParameters: Parameters? {get}
    var bodyParameters: Parameters? {get}
    
    func asURLRequest() throws -> URLRequest
}

extension RequestGenerator {
    
    internal var path: HTTPMethod {
        return .get
    }
    internal var method: HTTPMethod {
        return .get
    }
    
    internal var bodyParameters: Parameters? {
        return nil
    }
    
    internal var queryParameters: Parameters? {
        return nil
    }
    
    func codableToParameters<T : Codable>(_ obj: T) -> Parameters? {
        
        do {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
            let data = try encoder.encode(obj)
            
            guard var parameters = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Parameters else {
                return nil
            }
            
            //FILTER AND FIX BOOLEANS NSNUMBERS TO GET {TRUE,FALSE} INSTEAD OF {0, 1}
            parameters.forEach { (key, value) in
                if let number = value as? NSNumber,
                    CFGetTypeID(number as CFTypeRef) == CFBooleanGetTypeID() {
                    parameters.updateValue(number.isEqual(to: NSNumber(value: true)), forKey: key)
                }
            }
            return parameters
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let baseUrl = try self.baseUrl.asURL()

        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        
        if let bodyParameters = bodyParameters {
            let bodyEncoder = JSONEncoding()
            urlRequest = try bodyEncoder.encode(urlRequest, with: bodyParameters)
        }
        
        if let queryParameters = queryParameters {
            let urlEncoder = URLEncoding.init(destination: .queryString,
                                              arrayEncoding: .brackets,
                                              boolEncoding: .literal)
            
            urlRequest = try urlEncoder.encode(urlRequest, with: queryParameters)
        }
        
        return urlRequest
    }
}
