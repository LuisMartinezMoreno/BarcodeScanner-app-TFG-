//
//  MainViewModel.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation

class MainViewModel : MVVM_ViewModel {
    
    var codes = [String : DouglasProduct]()
    var products: [DouglasProduct]?
    
    func readProducts(){
        showLoading()
        Api.DouglasProducts.getProduct { [weak self] result in
            self?.handleResult(result, onSuccess: { arrayDouglasProducts in
                self?.products = arrayDouglasProducts
            })
            let defaults = UserDefaults.standard
            let savedArray = defaults.object(forKey: "SavedArray") as? [DouglasProduct] ?? [DouglasProduct]()
            if(!savedArray.isEmpty){
                for product in savedArray
                {
                    self?.products?.append(product)
                }
            }
        }
    }
}
