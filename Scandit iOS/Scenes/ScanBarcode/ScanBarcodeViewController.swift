//
//  ScanBarcodeViewController.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit
import ScanditBarcodeCapture
import Combine

class ScanBarcodeViewController: UIViewController, MVVM_View, BarcodeCaptureListener, UIGestureRecognizerDelegate, UITableViewDataSource{
    
    // MARK: Atrributes
    typealias ViewModel = ScanBarcodeViewModel

    var viewModel: ScanBarcodeViewModel!
    
    @IBOutlet weak var quantityLabel: DesignableLabel!
    private var context : DataCaptureContext!
    private var camera : Camera?
    private var barcodeCapture: BarcodeCapture!
    private var captureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    private let feedback = Feedback.default
    @IBOutlet weak var scanView: DesignableView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var bottomSheet: DesignableView!
    @IBOutlet weak var numberOfScans: DesignableLabel!
    
    var codes = [String : Product]()
    var productScanned : Bool = false
    
    private var cancellableBag = Set<AnyCancellable>()

    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.observeForErrors()
        initScan()
        initBottomSheet()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Allow codebar capture
        barcodeCapture.isEnabled = true
        
        //Switch on the camera
        camera?.switch(toDesiredState: .on)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Switch off the camera and the codebar capture
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }
    func bindViewModel() {
        viewModel = ScanBarcodeViewModel()
        self.viewModel.codes = self.codes
        self.viewModel.$scannedProduct.receive(on: DispatchQueue.main).sink{
            result in
            guard let description = result.description, let ean = result.ean else {return}
            self.productLabel.text = description + " \(ean)"
            self.productScanned = true
        }.store(in: &cancellableBag)
    }
    
    //MARK: Scanner functions
    
    private func initScan(){
        
        context = DataCaptureContext.licensed
        camera = Camera.default
        context.setFrameSource(camera, completionHandler: nil)
        
        let recommendedCameraSettings = BarcodeCapture.recommendedCameraSettings
        recommendedCameraSettings.preferredResolution = .fullHD
        camera?.apply(recommendedCameraSettings)
        let settings = BarcodeCaptureSettings()
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        
        barcodeCapture = BarcodeCapture(context: context,settings: settings)
        
        barcodeCapture.feedback.success = Feedback(vibration: .default, sound: nil)
        barcodeCapture.addListener(self)

        captureView = DataCaptureView(context: context, frame: scanView.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scanView.addSubview(captureView)
        
        //Optional
        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
    }
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcodes.first else {
            return
        }
        
        //Code recognised will be highlighted
        self.overlay.brush = BarcodeCaptureOverlay.defaultBrush
        
        //Vibration emitted
        feedback.emit()
        
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
        if let data = barcode.data{
            guard let product = self.viewModel.codes[data] else {return}
            self.viewModel.scannedProduct = product
        }
    }
    
    //MARK: Buttons actions
    
    @IBAction func increment(_ sender: UIButton) {
        guard let labelText = quantityLabel.text else {return}
        guard let buttonText = sender.titleLabel?.text else {return}
        if(labelText == "Introduce una cantidad"){ // FIRST ITERATION
            quantityLabel.text = ""
        }
        
        quantityLabel.text! += "\(buttonText)"
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        quantityLabel.text! = "Introduce una cantidad"
        barcodeCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
        productLabel.text = "No se han escaneado productos"
        productScanned = false
    }
    @IBAction func addButton(_ sender: Any) {
        guard let labelText = quantityLabel.text else {return}
        if(!productScanned){
            return
        }
        else if(labelText == "Introduce una cantidad"){
            self.viewModel.setError(CustomErrors.noQuantity)
            return
        }
        self.viewModel.numberOfProducts.updateValue(Int(labelText)!, forKey: self.viewModel.scannedProduct.ean!)
        self.numberOfScans.isHidden = false
        productsTableView.reloadData()
        
    }
    
    //MARK: Bottom Sheet
    
     func initBottomSheet(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged))
        numberOfScans.addGestureRecognizer(gesture)
        numberOfScans.isUserInteractionEnabled = true
        gesture.delegate = self
        productsTableView.dataSource = self
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if(gestureRecognizer.translation(in: self.view).y < 0){ // DRAG UP
        UIView.animate(withDuration: 1.0, animations: {
            self.bottomSheet.frame = CGRect(x: self.bottomSheet.frame.origin.x, y: self.quantityLabel.frame.origin.y, width: self.bottomSheet.frame.size.width, height: self.bottomSheet.frame.size.height)
        })

        UILabel.animate(withDuration: 1.0, animations: {
            self.numberOfScans.frame = CGRect(x: self.numberOfScans.frame.origin.x, y: self.quantityLabel.frame.origin.y, width: self.numberOfScans.frame.size.width, height: self.numberOfScans.frame.size.height)
        })
      }
        else if(gestureRecognizer.translation(in: self.view).y > 0){ //DRAG DOWN
            UIView.animate(withDuration: 1.0, animations: {
                self.bottomSheet.frame = CGRect(x: self.bottomSheet.frame.origin.x, y: self.view.frame.size.height-16, width: self.bottomSheet.frame.size.width, height: self.bottomSheet.frame.size.height)
                   })
            UILabel.animate(withDuration: 1.0, animations: {
                self.numberOfScans.frame = CGRect(x: self.numberOfScans.frame.origin.x, y: self.view.frame.size.height-48, width: self.numberOfScans.frame.size.width, height: self.numberOfScans.frame.size.height)
              })
            }
        }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfProducts.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as UITableViewCell
        return cell
     }
     
}
