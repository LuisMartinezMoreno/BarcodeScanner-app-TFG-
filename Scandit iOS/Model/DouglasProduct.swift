//
//  DouglasProduct.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation

class DouglasProduct : Codable, NSCoding {
    var code : String?
    var ean : String?
    var description : String?
    var price : String!
    var season : Int?
    var discountPrice : Float?
    var dateStartPromo : Date!
    var dateEndPromo : Date!
    var quantity : Int?
    var size : Int?
    var sizeformat : String?
    var qte : Int?
    
    //constructor vacio
    init(){}
    
    //constructor de registro
    init(code2: String, ean2: String, description2: String, price2: String, season2: Int, discountPrice2: Float, dateStartPromo2: Date, dateEndPromo2: Date, quantity2: Int, size2: Int, sizeFormat2: String, qte2: Int){
        code = code2
        ean = ean2
        description = description2
        price = price2
        season = season2
        discountPrice = discountPrice2
        dateStartPromo = dateStartPromo2
        dateEndPromo = dateEndPromo2
        quantity = quantity2
        size = size2
        sizeformat = sizeFormat2
        qte = qte2
    }
    
    //Decoder de scandit
    required init?(coder: NSCoder) {
        let formatter = DateFormatter.productDateFormat
        self.code = coder.decodeObject(forKey: "code") as? String ?? ""
        self.ean = coder.decodeObject(forKey: "ean")as? String ?? ""
        self.description = coder.decodeObject(forKey: "description")as? String ?? ""
        self.price = coder.decodeObject(forKey: "price")as? String ?? ""
        self.season = coder.decodeObject(forKey: "season") as? Int ?? 0
        self.discountPrice = coder.decodeObject(forKey: "discountPrice") as? Float ?? 0
        dateStartPromo  = formatter.date(from: "dateStartPromoString")
        dateEndPromo = formatter.date(from: "dateEndPromoString")
        self.quantity = coder.decodeObject(forKey: "quantity") as? Int ?? 0
        self.size = coder.decodeObject(forKey: "size")as? Int ?? 0
        self.sizeformat = coder.decodeObject(forKey: "sizeformat") as? String ?? ""
        self.qte = coder.decodeObject(forKey: "qte") as? Int ?? 0
    }
    
    //decoder de los json
    required init(from decoder: Decoder) throws {
        let formatter = DateFormatter.productDateFormat
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.ean = try container.decode(String.self, forKey: .ean)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(String.self, forKey: .price)
        self.season = try container.decode(Int.self, forKey: .season)
        self.discountPrice = try container.decode(Float.self, forKey: .discountPrice)
        let dateStartPromoString = try container.decode(String.self, forKey: .dateStartPromo)
        let dateEndPromoString = try container.decode(String.self, forKey: .dateEndPromo)
        dateStartPromo  = formatter.date(from: dateStartPromoString)!
        print(dateStartPromo!)
        print(type(of: dateStartPromo))
        dateEndPromo = formatter.date(from: dateEndPromoString)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.size = try container.decode(Int.self, forKey: .size)
        self.sizeformat = try container.decode(String.self, forKey: .sizeformat)
        self.qte = try container.decode(Int.self, forKey: .qte)
    }
    
    enum CodingKeys:String, CodingKey {
        case code = "CodeArticle",
             ean = "CodeEAN" ,
             description = "Description",
             price = "SalePrice",
             season = "Season",
             discountPrice = "DiscountPrice",
             dateStartPromo = "DateStartPromo",
             dateEndPromo =  "DateEndPromo",
             quantity = "Quantity",
             size = "Size",
             sizeformat = "sizeFormat",
             qte = "QTE"
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try (container.encode(code, forKey: .code))
        try (container.encode(ean, forKey: .ean))
        try (container.encode(description, forKey: .description))
        try (container.encode(price, forKey: .price))
        try (container.encode(season, forKey: .season))
        try (container.encode(discountPrice, forKey: .discountPrice))
        try (container.encode(dateStartPromo, forKey: .dateStartPromo))
        try (container.encode(dateEndPromo, forKey: .dateEndPromo))
        try (container.encode(quantity, forKey: .quantity))
        try (container.encode(size, forKey: .size))
        try (container.encode(sizeformat, forKey: .sizeformat))
        try (container.encode(qte, forKey: .qte))
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(code, forKey: "code")
        coder.encode(ean, forKey: "ean")
        coder.encode(description, forKey: "description")
        coder.encode(price, forKey: "price")
        coder.encode(season, forKey: "season")
        coder.encode(discountPrice, forKey: "discountPrice")
        coder.encode(dateStartPromo, forKey: "dateStartPromo")
        coder.encode(dateEndPromo, forKey: "dateEndPromo")
        coder.encode(quantity, forKey: "quantity")
        coder.encode(size, forKey: "size")
        coder.encode(sizeformat, forKey: "sizeformat")
        coder.encode(qte, forKey: "qte")
    }
    
    func verifyStock() -> StockState{
        guard let value = self.quantity else {return .NeedStock}
        if(value < 5){
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
