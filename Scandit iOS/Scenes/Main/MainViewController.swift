//
//  MainViewController.swift
//  Scandit iOS
//
//  Created by 67883058 on 04/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MVVM_View {
    
    // MARK: Attributes
    
    var viewModel: MainViewModel!

    typealias ViewModel = MainViewModel
    
    

    @IBOutlet weak var scanButtonView: DesignableView!
    @IBOutlet weak var barCodeImage: UIImageView!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.initView()
    }
    func bindViewModel() {
          
      }
    
    func initView(){
        
    }
    

}
