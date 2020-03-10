
import Foundation
import UIKit

protocol MVVM_View : UIViewController {
    
    //ASSOCIATED View model TYPE MUST CONFOMS TO MVVM_ViewModel protocol
    associatedtype ViewModel : MVVM_ViewModel
    
    var viewModel : ViewModel! {get set}
    
    func setViewModel(_ viewModel: ViewModel)
    func bindViewModel()
    func observeForErrors(handler: ErrorHandler?)
    
}

extension MVVM_View {
    
    //Starts observing viewmodel for error and manages presentation
    //Presents a default alert view if not handler provided by the implementation class
    func observeForErrors(handler: ErrorHandler?) {
        viewModel?.errorHandler = handler
    }
    
    func observeForErrors() {
        viewModel?.errorHandler = {[weak self] description in
            self?.defaultErrorHandler(description)
        }
    }
    
    private func defaultErrorHandler(_ errorDescription: String) {
        
        let alertManager = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                             message: errorDescription,
                                             preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Aceptar", comment: ""),
                                     style: .default, handler: nil)
        
        alertManager.addAction(okAction)
        
        self.present(alertManager, animated: true, completion: nil)
        
    }
    
    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
}
