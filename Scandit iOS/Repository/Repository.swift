//
//  Repository.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 16/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation

protocol Repository : AnyObject {
    associatedtype ProductType: Codable
    
    func readProducts(completion: @escaping ([DouglasProduct]?) -> Void) -> Void
}


//extension Repository {
//    
//    func readProducts(completion: @escaping ([ProductType]?) -> Void) {
//        do {
//            var products:[ProductType]?
//            Api.getProducts(completion: {(solution) ->Void in
//                do{
//                    print(type(of:try solution.get()))
//                    print(try solution.get())
//                    products = try solution.get()
//                    
//                }
//                catch{
//                    print("Error")
//                }
//                completion(products)
//            })
//        }
//    }
//}
/**
 func readProducts(completion: @escaping ([ProductType]?) -> Void) {
 if let path = Bundle.main.path(forResource: mustBeSettable, ofType: "json") {
 do {
 let decoder = JSONDecoder()
 decoder.dateDecodingStrategy = .iso8601
 var products:[ProductType]?
 Api.getProducts<ProductType>(completion: {(solution) ->Void in
 do{
 print(type(of:solution.get()))
 print(solution.get())
 products2 = solution.get()
 
 }
 catch{
 print("Error")
 }
 completion(products2)
 })
 
 //------------------------------
 let data = (try? Data(contentsOf: URL(fileURLWithPath: path))) ?? nil
 //let str = String(decoding: data!, as: UTF8.self)
 //print("data ",str)
 do{
 products = try decoder.decode([ProductType].self, from: data!)
 }
 catch{
 print(error)
 }
 completion(products)
 }
 }
 }
 */
