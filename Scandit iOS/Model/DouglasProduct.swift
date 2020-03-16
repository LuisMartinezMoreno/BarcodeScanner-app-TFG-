//
//  DouglasProduct.swift
//  Douglas
//
//  Created by Alejandro Docasal on 13/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import ObjectMapper

class DouglasProduct : Product {

    var season : Int?
    var discountPrice : Int?
    var dateStartPromo : Int?
    var dateEndPromo : Int?
    var quantity : Int?
    var size : Int?
    var sizeformat : String?
    var qte : Int?
    
    required init?(map: Map) {
        super.init(map: map)
       }
    
   override init(){
        super.init()
    }
     override func mapping(map: Map) {
        super.mapping(map: map)
        season <- map["Season"]
        discountPrice <- map["DiscountPrice"]
        dateStartPromo <- map["DateStartPromo"]
        dateEndPromo <- map["DateEndPromo"]
        quantity <- map["Quantity"]
        size <- map["Size"]
        sizeformat  <- map["sizeFormat"]
        qte <- map["QTE"]
    }
}
