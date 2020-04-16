//
//  ConsultProductViewController.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
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
    
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        registerTableViewCells()
        initPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove results when the tracking starts
        results.removeAll()
        productsTableView.rowHeight = 200
        productsTableView.dataSource = self
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
        self.viewModel.readProducts()
    }
    
    func registerTableViewCells(){
        let stockCell = UINib(nibName: "StockTableViewCell", bundle: nil)
        self.productsTableView.register(stockCell, forCellReuseIdentifier: "stockCell")
        let correctCell = UINib(nibName: "CorrectTableViewCell", bundle: nil)
        self.productsTableView.register(correctCell, forCellReuseIdentifier: "correctCell")
        let promotionCell = UINib(nibName: "PromotionTableViewCell", bundle: nil)
        self.productsTableView.register(promotionCell, forCellReuseIdentifier: "promotionCell")
    }
    
    private func initPlaceholder(){
        let placeholder = UILabel()
        placeholder.text = "\"Comience a escanear productos para ver su estado\""
        placeholder.frame.size.height = 42
        placeholder.frame.origin.x = productsTableView.frame.origin.x
        placeholder.center.y = (productsTableView.frame.size.height/3)
        placeholder.frame.size.width = (productsTableView.frame.size.width)
        placeholder.numberOfLines = 2
        placeholder.textColor = UIColor.gray
        placeholder.textAlignment = .left
        placeholder.tag = 1
        productsTableView.addSubview(placeholder)
    }
    
    private func initRecognition() {
        
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
        //Optional
        overlay = BarcodeTrackingBasicOverlay(barcodeTracking: barcodeTracking, view: captureView)
        
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
            self.productsTableView.viewWithTag(1)?.removeFromSuperview()
        }
        productsTableView.reloadData()
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
                    self.results[data] = $0
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
        guard let season = product!.season, let pStock = product!.quantity, let offer = product!.discountPrice else {return UITableViewCell()}
        guard let discountPrice = product?.discountPrice else {return UITableViewCell()}
        guard let size = product!.size, let sizeFormat = product!.sizeformat else {return UITableViewCell()}
        guard let price = product!.price else {return UITableViewCell()}
        let dprice = price.replacingOccurrences(of: ",", with: ".")
        guard let finalprice = Double(dprice) else {return UITableViewCell()}
        let newprice = Int((Double(offer) / finalprice)*100)
        
        
        let stock = product!.verifyStock()
        if(product?.discountPrice != 0){      /* PROMOTION PRODUCT CELL */
            let cell : PromotionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "promotionCell", for: indexPath) as! PromotionTableViewCell
            guard let start = product?.dateStartPromo else {return UITableViewCell()}
            let date = Date(milliseconds: start)
            let dateFormatterStart = DateFormatter()
            dateFormatterStart.dateFormat = "dd/MM/yyyy"
            guard let end = product?.dateEndPromo else {return UITableViewCell()}
            let dateEnd = Date(milliseconds: end)
            let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "dd/MM/yyyy"
            cell.productNameLabel.text = product!.description
            cell.product = product!
            cell.priceLabel.text = " " + "\(product!.price!)" + " € "
            cell.newPriceLabel.text = " NEW \(discountPrice) € "
            cell.sizeLabel.text = "\(size)" + " " + "\(sizeFormat)"
            cell.seasonNumberLabel.text = "\(season)"
            cell.numberStock.text = "\(pStock)"
            cell.offerLabel.text = "\(newprice)" + " %"
            cell.promotionLabel.text = "Desde \(dateFormatterStart.string(from: date)) hasta \(endDateFormatter.string(from: dateEnd))"
            return cell
        }
        else if(stock == .NeedStock || stock == .LowStock){      /* LOW STOCK CELL */
            
            let cell : StockTableViewCell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockTableViewCell
            cell.product = product!
            cell.productNameLabel.text = product!.description
            cell.priceLabel.text = " " + "\(product!.price!)" + " € "
            cell.sizeLabel.text = "\(size)" + " " + "\(sizeFormat)"
            cell.seasonNumberLabel.text = "\(season)"
            cell.numberStock.text = "\(pStock)"
            cell.offerLabel.text = "\(newprice)" + " %"
            cell.stateLabel.text = stock.description
            if(stock == .NeedStock){
                cell.stateLabel.textColor = UIColor.orange
            }
            else{
                cell.stateLabel.textColor = UIColor.green
            }
            return cell
        }
        else{      /* CORRECT STATE CELL */
            let cell : CorrectTableViewCell = tableView.dequeueReusableCell(withIdentifier: "correctCell", for: indexPath) as! CorrectTableViewCell
            cell.productNameLabel.text = product!.description
            cell.product = product!
            cell.priceLabel.text = " " + "\(product!.price!)" + " € "
            cell.sizeLabel.text = "\(size)" + " " + "\(sizeFormat)"
            cell.seasonNumberLabel.text = "\(season)"
            cell.numberStock.text = "\(pStock)"
            cell.offerLabel.text = "\(newprice)" + " %"
            return cell
        }
    }
}
