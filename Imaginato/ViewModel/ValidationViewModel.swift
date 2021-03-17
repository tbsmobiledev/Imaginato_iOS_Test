import Foundation
import RxRelay

protocol ValidationViewModel {
     
    var errorMessage: String { get }
    
    // Observables
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get set }
    
    // Validation
    func validateCredentials() -> Bool
}
