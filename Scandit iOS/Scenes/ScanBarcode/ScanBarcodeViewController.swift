//
//  ScanBarcodeViewController.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit

class ScanBarcodeViewController: UIViewController, MVVM_View {
    
    // MARK: Atrributes
    typealias ViewModel = ScanBarcodeViewModel

    var viewModel: ScanBarcodeViewModel!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
    }

}
