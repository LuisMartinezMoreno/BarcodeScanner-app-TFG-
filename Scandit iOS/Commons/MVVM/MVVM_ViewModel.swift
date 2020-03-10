
import Foundation

typealias ErrorHandler = ((_ errorDescription: String) -> ())

private struct AssociatedErrorPointer {
    static var onErrorActionPointer : UInt8 = 0
}

protocol MVVM_ViewModel : class {
    func setError(_ err: Error)
}

extension MVVM_ViewModel {
    
    var errorHandler : ErrorHandler? {
        
        get {
            guard let action = objc_getAssociatedObject(
                self,
                &AssociatedErrorPointer.onErrorActionPointer) as? ErrorHandler else {
                    return nil
            }
            return action
        }
        
        set(newValue) {
            objc_setAssociatedObject(
                self,
                &AssociatedErrorPointer.onErrorActionPointer,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    func setError(_ err: Error) {
        guard let action = errorHandler else {return}
        
        action(err.localizedDescription)
    }
    
}
