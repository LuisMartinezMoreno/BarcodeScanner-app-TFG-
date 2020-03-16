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
    var price : Double?
    
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
    
    /*init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        ean = try container.decode(String.self, forKey: .ean)
        description = try container.decode(String.self, forKey: .description)
        price = try container.decode(Double.self, forKey: .price)
        data = try container.decode(T.self, forKey: .data)
    }
    
    enum CodingKeys : String, CodingKey {
        case code = "CodeArticle"
        case description
        case ean = "CodeEAN"
        case price = "SalePrice"
        case data
    }*/
}
