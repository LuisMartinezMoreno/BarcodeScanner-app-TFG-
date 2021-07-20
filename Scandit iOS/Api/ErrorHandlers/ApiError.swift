//
//  ApiError.swift
//
//  Created by Bienvenido Fernández Lora on 17/12/2018.
//  Copyright © 2018 Informática El Corte Inglés. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiErrorProtocol : LocalizedError {
    var code: String? {get}
    var description : String? {get}
    var url: String? {get set}
}

struct ApiError: ApiErrorProtocol, Decodable {

    var code : String?
    var description : String?
    var url: String?
    
    var errorDescription: String? {
        return description
    }
    
    
    init(code: String, message: String?, url: String? = nil) {
        self.code = code
        self.description = message
        self.url = url
    }
    
    init(_ afError: AFError) {
        self.code = "\(afError.responseCode ?? 0)"
        self.description = afError.localizedDescription
    }
    
}
