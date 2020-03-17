//
//  ScanBarcodeViewModel.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import Combine

class ScanBarcodeViewModel: MVVM_ViewModel {
    
    var codes = [String : Product]()
    var numberOfProducts = [String : Int]()
    

    @Published var scannedProduct : Product = Product()
    
}
