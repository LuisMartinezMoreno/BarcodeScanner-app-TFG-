//
//  MainViewController.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MVVM_View {
    
    // MARK: Attributes
    
    var viewModel: MainViewModel!
    
    typealias ViewModel = MainViewModel
    private var arrayProductos: [DouglasProduct] = []
    
    
    @IBOutlet weak var consultProductView: DesignableView!
    @IBOutlet weak var scanButtonView: DesignableView!
    @IBOutlet weak var barCodeImage: UIImageView!
    @IBOutlet weak var iecisaImage: UIImageView!
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.initView()
    }
    func bindViewModel() {
        viewModel = MainViewModel()
        viewModel.readProducts()
    }
    
    func initView(){
        iecisaImage.image = iecisaImage.image?.withRenderingMode(.alwaysTemplate)
        iecisaImage.tintColor = UIColor.init(named: "primaryColor")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is ScanBarcodeViewController){
            let destinationVC = segue.destination as? ScanBarcodeViewController
            if arrayProductos.count == 0 {
                destinationVC?.setArray(array: self.viewModel.products!)
            }
            else{
                print("TAM ARRAY PRODUCTOS",arrayProductos.count)
                destinationVC?.setArray(array: arrayProductos)
            }
        }
        if(segue.destination is ConsultProductViewController){
            let destinationVC = segue.destination as? ConsultProductViewController
            if(arrayProductos.count == 0){
                destinationVC?.setArray(array: self.viewModel.products!)}
            else{
                print("TAM ARRAY PRODUCTOS",arrayProductos.count)
                destinationVC?.setArray(array: arrayProductos)}
        }
    }
    func setArray(array: [DouglasProduct]){
        arrayProductos = array
    }
    
}
