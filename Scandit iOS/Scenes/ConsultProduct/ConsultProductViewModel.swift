//
//  ConsultProductViewModel.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation

class ConsultProductViewModel : MVVM_ViewModel {
    
    var codes = [String : DouglasProduct]()
    var products = [DouglasProduct]()
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
