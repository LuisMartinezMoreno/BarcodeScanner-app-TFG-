//
//  ConsultProductViewController.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit
import ScanditBarcodeCapture

class ConsultProductViewController: UIViewController, MVVM_View {
    
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
    
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        initRecognition()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Remove results when the tracking starts
        results.removeAll()
    }
    
    func bindViewModel() {
        viewModel = ConsultProductViewModel()
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
}
