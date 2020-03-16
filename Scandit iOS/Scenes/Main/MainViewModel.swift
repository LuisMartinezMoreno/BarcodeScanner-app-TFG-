//
//  MainViewModel.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation

class MainViewModel : MVVM_ViewModel {
    
    var products = [Product]()
    var codes = [String : Product]()
    var numberOfProducts = [String: Int]()
    
    fileprivate let repository = DouglasRepository()
    
    func readProducts(){
        repository.readProducts(){
            result in self.products = result
            for product in self.products {
                self.codes.updateValue(product, forKey: product.ean!)
            }
        }
    }
}
