//
//  ConsultProductViewController.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 01/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import UIKit
import ScanditBarcodeCapture

class ConsultProductViewController: UIViewController, MVVM_View, UITableViewDataSource {
    
    
    // MARK: Atributtes
    
    typealias ViewModel = ConsultProductViewModel
    
    var viewModel: ConsultProductViewModel!
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    private var barcodeTracking: BarcodeTracking!
    private var captureView: DataCaptureView!
    private var overlay: BarcodeTrackingBasicOverlay!
    
    private var results: [String: Barcode] = [:]
    
    @IBOutlet weak var scannerView: DesignableView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var pauseButton: DesignableButton!
    
    private var advancedOverlay: BarcodeTrackingAdvancedOverlay!
    private var overlays: [Int: StockOverlay] = [:]
    private var arrayProductos: [DouglasProduct] = []
    
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
//        print("viewDidLoad")
        super.viewDidLoad()
        bindViewModel()
        initPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        results.removeAll()
        initRecognition()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        barcodeTracking.isEnabled = false
        camera?.switch(toDesiredState: .off)
        context.removeAllModes()
    }
    
    func bindViewModel() {
        viewModel = ConsultProductViewModel()
    }
    
    private func initPlaceholder(){
        let placeholder = UILabel()
        placeholder.text = "\"Comience a escanear productos para ver su estado\""
        placeholder.frame.size.height = 42
        placeholder.numberOfLines = 2
        placeholder.textColor = UIColor.gray
        placeholder.textAlignment = .left
        placeholder.tag = 1
    }
    
    private func initRecognition() {
//        print("initRecoginition")
        context = DataCaptureContext.licensed
        
        camera = Camera.default
        context.setFrameSource(camera, completionHandler: nil)
        
        let cameraSettings = BarcodeTracking.recommendedCameraSettings
        cameraSettings.preferredResolution = .fullHD
        camera?.apply(cameraSettings, completionHandler: nil)
        
        let settings = BarcodeTrackingSettings()
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        
        barcodeTracking = BarcodeTracking(context: context, settings: settings)
        barcodeTracking.addListener(self)
        
        captureView = DataCaptureView(context: context, frame: scannerView.bounds)
        captureView.context = context
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scannerView.addSubview(captureView)
        scannerView.sendSubviewToBack(captureView)
        
        barcodeTracking.isEnabled = true
        camera?.switch(toDesiredState: .on)
        overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: captureView)
        advancedOverlay = BarcodeTrackingAdvancedOverlay(barcodeTracking: barcodeTracking, view: captureView)
        advancedOverlay.delegate = self
    }
    
    private func stockOverlay(for trackedCode: TrackedBarcode) -> StockOverlay? {
        let identifier = trackedCode.identifier
//        print("Identifier: ",identifier)
//        print("trackedCode",trackedCode.barcode.data as Any)
//        print("tipo",type (of:trackedCode.barcode))
        var overlay: StockOverlay
        let producto = getProduct(eanCode: trackedCode.barcode.data!)
        
        if overlays.keys.contains(identifier) {
            overlay = overlays[identifier]!
        } else {
            // Get the information you want to show from your back end system/database.
            if(producto != nil){
                overlay = StockOverlay(with: StockModel(description: producto!.description, price: (producto!.price)! as String,discountPrice: producto!.discountPrice, totalPrice: 6, uds: producto?.quantity))
            }
            else{
                overlay = StockOverlay(with: StockModel (description: "unknown product",
                                                         price:"0" ,discountPrice: 0, totalPrice: 0, uds: 0 )
                                       
                )}
            overlays[identifier] = overlay
        }
        return overlay
    }
    
    private func getProduct(eanCode: String) ->DouglasProduct?{
        
        var i:Int = 0
        let tam:Int = self.arrayProductos.count
        while i < tam
        {
            if(eanCode == self.arrayProductos[i].ean){
                return self.arrayProductos[i]
            }
            i+=1
        }
        
        let tam2:Int = self.arrayProductos.count
        var j:Int = 0
        while j < tam2
        {
            if(eanCode == self.arrayProductos[j].ean){
                return self.arrayProductos[j]
            }
            j+=1
        }
        return nil
    }
    
    //MARK: Button function
    
    @IBAction func pauseScan(_ sender: Any) {
        if(camera?.currentState == FrameSourceState.off){
            barcodeTracking.isEnabled = true
            camera?.switch(toDesiredState: .on)
            results.removeAll()
            pauseButton.setTitle("Pausar scan", for: .normal)
            initPlaceholder()
        }
        else{
            barcodeTracking.isEnabled = false
            camera?.switch(toDesiredState: .off)
            pauseButton.setTitle("Reiniciar scan", for: .normal)
        }
    }
    
    func setArray(array: [DouglasProduct]){
        arrayProductos = array
    }

    
}

extension ConsultProductViewController: BarcodeTrackingListener {
    // This function is called whenever objects are updated and it's the right place to react to the tracking results.
    func barcodeTracking(_ barcodeTracking: BarcodeTracking,
                         didUpdate session: BarcodeTrackingSession,
                         frameData: FrameData) {
        DispatchQueue.main.async { [weak self] in
            session.trackedBarcodes.values.compactMap({ $0.barcode }).forEach {
                if let self = self, let data = $0.data, !data.isEmpty {
                    let eanCode = $0.data
                    let tam:Int = self.arrayProductos.count
                    var i:Int = 0
                    while i < tam
                    {
                        if(eanCode! == self.arrayProductos[i].ean){
//                            print("COINCIDE",eanCode as Any)
                        }
                        i+=1
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productCode = Array(results.keys)[indexPath.row]
        let product = self.viewModel.codes[productCode]
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "promotionCell", for: indexPath)
        if(product?.discountPrice != 0){      /* PROMOTION PRODUCT CELL */
            let dateFormatterStart = DateFormatter()
            dateFormatterStart.dateFormat = "dd/MM/yyyy"
            let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "dd/MM/yyyy"
        }
        return cell
    }
}

extension ConsultProductViewController: BarcodeCaptureListener {
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        let recognizedBarcodes = session.newlyRecognizedBarcodes
        for barcode in recognizedBarcodes {
//            print("reconocido:",barcode)
        }
    }
}

extension ConsultProductViewController: BarcodeTrackingAdvancedOverlayDelegate {
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                        viewFor trackedBarcode: TrackedBarcode) -> UIView? {
        return stockOverlay(for: trackedBarcode)
    }
    
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                        anchorFor trackedBarcode: TrackedBarcode) -> Anchor {
        // The offset of our overlay will be calculated from the top center anchoring point.
        return .topCenter
    }
    
    func barcodeTrackingAdvancedOverlay(_ overlay: BarcodeTrackingAdvancedOverlay,
                                        offsetFor trackedBarcode: TrackedBarcode) -> PointWithUnit {
        // We set the offset's height to be equal of the 100 percent of our overlay.
        // The minus sign means that the overlay will be above the barcode.
        return PointWithUnit(x: FloatWithUnit(value: 0, unit: .fraction),
                             y: FloatWithUnit(value: -1, unit: .fraction))
    }
}
