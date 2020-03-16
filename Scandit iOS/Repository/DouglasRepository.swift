//
//  DouglasRepository.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 13/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import ObjectMapper

class DouglasRepository {
    
    func readProducts(completion: @escaping ([Product]) -> Void) -> Void{
        if let path = Bundle.main.path(forResource: "data_sample", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

                if let jsonResult = jsonResult as? [[String: Any]]{
                    let products = Mapper<Product>().mapArray(JSONArray: jsonResult)
                    completion(products)
                  }
              } catch {
                   return
              }
        }
    }
}
