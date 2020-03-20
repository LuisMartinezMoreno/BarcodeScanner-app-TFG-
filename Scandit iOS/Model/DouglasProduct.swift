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
        quantity = Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 1, upper: 100)))
        size <- map["Size"]
        sizeformat  <- map["sizeFormat"]
        qte <- map["QTE"]
        dateStartPromo = Date().millisecondsSince1970
        dateEndPromo = (dateStartPromo ?? 0) + ((Int.random(in: ClosedRange<Int>(uncheckedBounds: (lower: 1, upper: 30))))*24*60*60*60)
    }
    
    override func verifyStock() -> StockState{
        guard let value = self.quantity else {return .NeedStock}
        if(value < 10){
            return .NeedStock
        }
        
        else if(value < 30){
            return .LowStock
        }
        else{
            return .inStock
        }
    }
    
}
enum StockState {
    case NeedStock
    case LowStock
    case inStock
    
    var description: String {
        switch self {
        case .NeedStock:
            return "Reponer Stock"
        case .LowStock:
            return "Existencias bajas en Stock"
        case .inStock:
            return "En Stock"
        }
    }
}
