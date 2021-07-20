//
//  ApiProducts.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import Alamofire

extension Api {
    //saca el JSON de productos
    struct DouglasProducts {
        static func getProduct(completion: @escaping(Result<[DouglasProduct]?, Error>) ->Void){
            ApiCore.shared().request(ProductRouter.getProducts,completion: completion)
        }
    }
}

