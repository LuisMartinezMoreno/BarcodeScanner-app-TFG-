//
//  ProductRouter.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/5/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import Alamofire

enum ProductRouter: RequestGenerator{
    
    case getProducts
    //Principio de la url
    internal var baseUrl: String {Environment.baseURL}
    //fin de la url
    internal var path: String {
        return Endpoint.catalogo
    }
    
    internal var method: HTTPMethod {
        switch self {
        case .getProducts:
            return .get
        }
    }
    
}
