//
//  DefaultLoadingIndicatorHandler.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import SVProgressHUD

final class DefaultLoadingIndicatorHandler {
    
    private static let LOADING_TIMER = 0.4
    private static let TIMEOUT_TIMER = 40.0
    
    private var loadingRequestsCount = 0
    private var dispatchSemaphone: DispatchSemaphore
    private var timer: Timer?
    private var timeoutTimer: Timer?
    
    private static var sharedHandler: DefaultLoadingIndicatorHandler = {
        let handler = DefaultLoadingIndicatorHandler()
        return handler
    }()
    
    class func shared() -> DefaultLoadingIndicatorHandler {return sharedHandler}
    
    init() {
        self.dispatchSemaphone = DispatchSemaphore(value: 1)
    }
    
    var loadingHandler : LoadingIndicatorHandler = {loading in
        
        var count : Int {
            get {
                shared().loadingRequestsCount
            }
            
            set (newValue){
                shared().loadingRequestsCount = newValue
            }
        }
        
        var timer: Timer? {
            get {
                shared().timer
            }
            
            set(newValue) {
                shared().timer = newValue
            }
        }
        
        var timeoutTimer : Timer? {
            get {
                shared().timeoutTimer
            }
            
            set(newValue) {
                shared().timeoutTimer = newValue
            }
        }
        
        shared().dispatchSemaphone.wait()
        
        if loading {
            
            count += 1
            
            if count == 1 {
                timer = Timer.scheduledTimer(withTimeInterval: LOADING_TIMER, repeats: false) {timer in
                    SVProgressHUD.show(withStatus: NSLocalizedString("Cargando", comment: ""))
                }
                
                timeoutTimer = Timer.scheduledTimer(withTimeInterval: TIMEOUT_TIMER, repeats: false) {timer in
                    count = 0
                    timer.invalidate()
                    SVProgressHUD.dismiss()
                }
                
            }
            
        } else if count > 0 {
            
            count -= 1
            
            if count == 0 {
                timer?.invalidate()
                timeoutTimer?.invalidate()
                SVProgressHUD.dismiss()
            }
            
        }
        
        shared().dispatchSemaphone.signal()
        
    }
    
    deinit {
        timer?.invalidate()
        timeoutTimer?.invalidate()
        timer = nil
        timeoutTimer = nil
    }
    
}
