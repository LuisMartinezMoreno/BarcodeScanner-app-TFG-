//
//  Product.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 13/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import ObjectMapper

class Product : Mappable {
    
    var code : String?
    var ean : String?
    var description : String?
    var price : String?
    
    required init?(map: Map) {
        
    }
    init() {
        
    }
    
    func mapping(map: Map) {
        code <- map["CodeArticle"]
        ean <- map["CodeEAN"]
        description <- map["Description"]
        price <- map["SalePrice"]
    }
    
    func verifyStock() -> StockState{
        return .NeedStock
    }
    
}
