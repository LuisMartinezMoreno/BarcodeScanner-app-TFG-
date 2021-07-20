//
//  MVVM_ViewModel.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 15/03/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation

private struct AssociatedPointer {
    static var onErrorActionPointer : UInt8 = 0
    static var onLoadingActionPointer : UInt8 = 0
}

protocol MVVM_ViewModel : AnyObject {
    func setError(_ err: Error)
    func showLoading()
    func hideLoading()
}

extension MVVM_ViewModel {
    
    var errorHandler : ErrorHandler? {
        
        get {
            objc_getAssociatedObject(
                self,
                &AssociatedPointer.onErrorActionPointer) as? ErrorHandler
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &AssociatedPointer.onErrorActionPointer,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    var loadingIndicatorHandler : LoadingIndicatorHandler? {

        get {
            objc_getAssociatedObject(
                self,
                &AssociatedPointer.onLoadingActionPointer) as? LoadingIndicatorHandler
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &AssociatedPointer.onLoadingActionPointer,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    func setError(_ err: Error) {
        
        guard let errorHandler = errorHandler else {
            return
        }
        
        DispatchQueue.main.async {
            errorHandler(err)
        }
    }
    
    func showLoading() {
        guard let loadingIndicatorHandler = loadingIndicatorHandler else {
            return
        }
        
        DispatchQueue.main.async {
            loadingIndicatorHandler(true)
        }
    }
    
    func hideLoading() {
        guard let loadingIndicatorHandler = loadingIndicatorHandler else {
            return
        }
        
        DispatchQueue.main.async {
            loadingIndicatorHandler(false)
        }
    }
    
    func handleResult<T>(_ result: Result<T, Error>, onSuccess: @escaping (T) -> ()) {
        switch result {
        case .success(let data):
            onSuccess(data)
        case .failure(let error):
            setError(error)
        }
    }
    
}
