//
//  ScanBarcodeViewController.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 10/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
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
    private var codigoEan:String = ""
    
    @IBOutlet weak var scanView: DesignableView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var bottomSheet: DesignableView!
    @IBOutlet weak var numberOfScans: DesignableLabel!
    @IBOutlet weak var changeCameraButton: DesignableButton!
    private var advancedOverlay: BarcodeTrackingAdvancedOverlay!
    
    var codes = [String : DouglasProduct]()
    private var arrayProductos: [DouglasProduct] = []
    
    var productScanned : Bool = false
    var quantity:Int = 0;
    
    private var cancellableBag = Set<AnyCancellable>()
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.observeForErrors()
        initBottomSheet()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initScan(camera: Camera.default!)
        
        //Allow codebar capture
        barcodeCapture.isEnabled = true
        
        //Switch on the camera
        camera?.switch(toDesiredState: .on)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        productsTableView.rowHeight = 50
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Switch off the camera and the codebar capture
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
        context.removeAllModes()
    }
    
    func setArray(array: [DouglasProduct]){
        arrayProductos = array
    }
    
    func bindViewModel() {
        viewModel = ScanBarcodeViewModel()
        self.viewModel.codes = self.codes
    }
    
    //MARK: Scanner functions
    
    private func initScan(camera: Camera){
        
        context = DataCaptureContext.licensed
        self.camera = camera
        context.setFrameSource(camera, completionHandler: nil)
        let recommendedCameraSettings = BarcodeCapture.recommendedCameraSettings
        recommendedCameraSettings.preferredResolution = .fullHD
        self.camera?.apply(recommendedCameraSettings)
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
        
        barcodeCapture.isEnabled = true
        self.camera?.switch(toDesiredState: .on)
        //Optional
        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        captureView.addOverlay(overlay)
    }
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture, didScanIn session: BarcodeCaptureSession, frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcodes.first else {
            return
        }
        let tam:Int = arrayProductos.count
        var i:Int = 0
        var flag:Bool = false
        codigoEan = barcode.data!
        while(i<tam){
            if(codigoEan == arrayProductos[i].ean){
                flag = true;
            }
            i+=1
        }
        if(!flag){
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
        }else{
//            print("producto ya registrado")
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
        resetScreen()
    }
    @IBAction func addButton(_ sender: Any) {
        guard let labelText = quantityLabel.text else {return}
        if(!productScanned){
            return
        }
        quantity = Int(labelText)!
        self.viewModel.numberOfProducts.updateValue(Int(labelText)!, forKey: self.viewModel.scannedProduct.ean!)
        self.numberOfScans.text = String(self.viewModel.numberOfProducts.count)
        self.numberOfScans.isHidden = false
        productsTableView.reloadData()
        resetScreen()
    }
    
    private func resetScreen(){
        barcodeCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
        quantityLabel.text! = "Introduce una cantidad"
        productLabel.text = "No se han escaneado productos"
        productScanned = false
    }
    @IBAction func changeCamera(_ sender: Any) {
        context.removeAllModes()
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
        if(camera?.position == .worldFacing){
            let cam = Camera(position: .userFacing)!
            cam.switch(toDesiredState: .on)
            initScan(camera: cam)
            changeCameraButton.setTitle("Cámara trasera", for: .normal)
        }
        else{
            changeCameraButton.setTitle("Cámara frontal", for: .normal)
            initScan(camera: Camera.default!)
        }
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
                self.numberOfScans.frame = CGRect(x: self.numberOfScans.frame.origin.x, y: self.quantityLabel.frame.origin.y-24, width: self.numberOfScans.frame.size.width, height: self.numberOfScans.frame.size.height)
            })
        }
        else if(gestureRecognizer.translation(in: self.view).y > 0){ //DRAG DOWN
            UIView.animate(withDuration: 1.0, animations: {
                self.bottomSheet.frame = CGRect(x: self.bottomSheet.frame.origin.x, y: self.view.frame.size.height, width: self.bottomSheet.frame.size.width, height: self.bottomSheet.frame.size.height)
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
        let keys = Array(self.viewModel.numberOfProducts)
        let (code,number) = keys[indexPath.row]
        let product = self.viewModel.codes[code]
        let cell : ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        cell.productCodeLabel.text = code
        cell.productNameLabel.text = product?.description
        cell.quantityLabel.text = String(number)
        cell.stepper.value = Double(number)
        return cell
    }
    
    @IBAction func AddElement(_ sender: Any) {
//        print(productScanned)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destVC = segue.destination as? AddProductViewController {
            destVC.setCodigoEan(code: codigoEan)
            destVC.setQuantity(quantity: Int(quantityLabel.text!) ?? 200)
            destVC.setArray(array: arrayProductos)
        }
        
        
    }
}

