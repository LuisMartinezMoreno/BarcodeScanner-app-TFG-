//
//  MVVM_DefaultHandlers.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 12/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation

typealias LoadingIndicatorHandler = ((_ loading: Bool) -> ())
typealias ErrorHandler = ((_ error: Error) -> ())

class MVVM_DefaultHandlers {
    
    private(set) var defaultErrorHandler: ErrorHandler?
    private(set) var defaultLoadingHandler: LoadingIndicatorHandler?
    
    private static var sharedInstance: MVVM_DefaultHandlers = {
        let manager = MVVM_DefaultHandlers()
        return manager
    }()
    
    class func shared() -> MVVM_DefaultHandlers {return sharedInstance}
    
    private init() {}
    
    func setDefault(error handler: @escaping ErrorHandler) {
        self.defaultErrorHandler = handler
    }
    
    func setDefault(loading handler: @escaping LoadingIndicatorHandler) {
        self.defaultLoadingHandler = handler
    }
    
}
