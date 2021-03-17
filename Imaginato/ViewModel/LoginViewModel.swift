import Foundation
import RxRelay
import RxSwift

class LoginViewModel {
    
    let model : LoginDataModel = LoginDataModel()
    private let disposeBag = DisposeBag()

    // Initialise ViewModel's
    let emailIdViewModel = EmailIdViewModel()
    let passwordViewModel = PasswordViewModel()
    
    // Fields that bind to our view's
    var isSuccess : BehaviorRelay<Bool>     = BehaviorRelay(value: false)
    var isLoading : BehaviorRelay<Bool>     = BehaviorRelay(value: false)
    var errorMsg  : BehaviorRelay<String>   = BehaviorRelay(value: "")
    
    var modelResponse : LoginBaseModel?

    func validateCredentials() -> Bool{
        if !emailIdViewModel.validateCredentials(){
            self.errorMsg.accept(emailIdViewModel.errorMessage)
        }else if !passwordViewModel.validateCredentials(){
            self.errorMsg.accept(passwordViewModel.errorMessage)
        }else{
            return true
        }
        return false
    }
    
    func loginUser(){
        
        // Initialise model with filed values
        model.email = emailIdViewModel.data.value
        model.password = passwordViewModel.data.value
        
        self.isLoading.accept(true)
        
        let params = [Params.Login.email:model.email, Params.Login.password: model.password]
        
        APICall<LoginBaseModel>.callAPI(api: Params.Login.URL, params: params, methodType: .post, isJsonEncoding:true).subscribe { (responseModel) in
            self.modelResponse = responseModel
            self.isLoading.accept(false)
            self.isSuccess.accept(true)
        } onError: { (error) in
            self.isLoading.accept(false)
            self.errorMsg.accept(error.localizedDescription)
        }.disposed(by: disposeBag)
    }
}
