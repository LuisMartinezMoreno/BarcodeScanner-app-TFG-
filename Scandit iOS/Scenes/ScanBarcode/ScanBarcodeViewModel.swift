//
//  ScanBarcodeViewModel.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import Combine
import ScanditBarcodeCapture

class ScanBarcodeViewModel: MVVM_ViewModel {
    
    var codes = [String : DouglasProduct]()
    var numberOfProducts = [String : Int]()
    private var context : DataCaptureContext!
    private var camera : Camera?
    
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
           
            print("result",result)
        }
    }
    @Published var scannedProduct : DouglasProduct = DouglasProduct()
    
}
