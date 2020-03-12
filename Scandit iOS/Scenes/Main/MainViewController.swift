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
    
    

    @IBOutlet weak var consultProductView: DesignableView!
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
         let consultGesture = UITapGestureRecognizer(target: self, action:  #selector (self.navigateConsult(_:)))
         self.consultProductView.addGestureRecognizer(consultGesture)
         let scanGesture = UITapGestureRecognizer(target: self, action:  #selector (self.navigateScan(_:)))
         self.scanButtonView.addGestureRecognizer(scanGesture)
    }
    
    
    @objc func navigateConsult(_ sender:UITapGestureRecognizer){
        self.performSegue(withIdentifier: "consultSegue", sender: self)
    }
    
    @objc func navigateScan(_ sender:UITapGestureRecognizer){
        self.performSegue(withIdentifier: "scanSegue", sender: self)
    }
    

}
