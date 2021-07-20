//
//  MVVM_View.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 15/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import UIKit
import Combine

private struct AssociatedPointer {
    static var viewModelPointer : UInt8 = 0
    static var cancellableBagPointer : UInt8 = 0
}

/*
 * Cancellable bag: Contains all references to publishers binded in this view
 */
final class CancellableBag {
    fileprivate var bag = Set<AnyCancellable>()
}

protocol MVVM_View: AnyObject {
    
    //ASSOCIATED View model TYPE MUST CONFOMS TO MVVM_ViewModel protocol
    associatedtype ViewModel : MVVM_ViewModel
    
    func setViewModel(_ viewModel: ViewModel)
    func bindViewModel()
    func observeForErrors(handler: ErrorHandler?)
    func observeLoadings(handler: LoadingIndicatorHandler?)
    
}

extension MVVM_View {
    
    //MARK: - VIEW MODEL
    
    /*
     * View model associated object
     */
    private (set) var viewModel: ViewModel! {
        get {
            objc_getAssociatedObject(
                self, &AssociatedPointer.viewModelPointer) as? ViewModel
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &AssociatedPointer.viewModelPointer,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /*
     * CancellableBag for store listeners
     */
    var cancellableBag : CancellableBag! {
        
         get {
            guard let cancellableBag = objc_getAssociatedObject(
                self,
                &AssociatedPointer.cancellableBagPointer) as? CancellableBag else {
                    
                    let newBag = CancellableBag()
                    self.cancellableBag = newBag
                    return newBag

            }
            
            return cancellableBag
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &AssociatedPointer.cancellableBagPointer,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    /*
     * Associates publishers with actions over ui elements
     * making transparent cancellablebag and scheduler queues
     * in order to avoiding boilerplate code
     */
    func bindUIAction<T: Publisher>(_ publisher: T?, sinkAction: @escaping ((T.Output) -> Void)) where T.Failure == Never {
        publisher?.receive(on: DispatchQueue.main).sink(receiveValue: sinkAction).store(in: &self.cancellableBag.bag)
    }
    
    /*
     * Associates publishers to make changes over ui elements associated keys
     * making transparent cancellablebag and scheduler queues
     * in order to avoiding boilerplate code
     */
    func assignUI<Root, T: Publisher>(_ publisher: T?, to keyPath: ReferenceWritableKeyPath<Root, T.Output>, on object: Root) where T.Failure == Never {
        publisher?.receive(on: DispatchQueue.main).assign(to: keyPath, on: object).store(in: &self.cancellableBag.bag)
    }
    
    /*
     * View Model setter
     */
    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - ERROR HANDLER
    
    /*
     *Starts observing viewmodel for error and manages presentation
     *Presents a default alert view if not handler provided by the implementation class
     */
    func observeForErrors(handler: ErrorHandler? = nil) {
        if let handler = handler {
            viewModel?.errorHandler = handler
        } else {
            assert(MVVM_DefaultHandlers.shared().defaultErrorHandler != nil, "Default error handler not setted")
            viewModel?.errorHandler = MVVM_DefaultHandlers.shared().defaultErrorHandler
        }
    }
    
    //MARK: - LOADING INDICATOR
    
    /*
     * Stars observing viewmodel for loadings and manages presentation
     */
    func observeLoadings(handler: LoadingIndicatorHandler? = nil) {
        if let handler = handler {
            viewModel?.loadingIndicatorHandler = handler
        } else {
            assert(MVVM_DefaultHandlers.shared().defaultLoadingHandler != nil, "Default loadings handler not setted")
            viewModel?.loadingIndicatorHandler = MVVM_DefaultHandlers.shared().defaultLoadingHandler
        }
    }
    
}
