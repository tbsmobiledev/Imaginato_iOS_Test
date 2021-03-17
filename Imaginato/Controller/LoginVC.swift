import UIKit
import RxSwift

class LoginVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    
    //MARK:- VARS
    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupInitialUI()
        setupViewModelBinding();
        setupCallbacks()
    }
    
    //MARK:- Other Methods
    func setupInitialUI(){
        txtEmail.text = "test@imaginato.com"
        txtPassword.text = "Imaginato2020"
        btnLogin.layer.cornerRadius = 10.0
    }
    
    func setupViewModelBinding(){
        txtEmail.rx.text.orEmpty
            .bind(to: viewModel.emailIdViewModel.data)
            .disposed(by: disposeBag)
        
        txtPassword.rx.text.orEmpty
            .bind(to: viewModel.passwordViewModel.data)
            .disposed(by: disposeBag)
        
        btnLogin.rx.tap.do(onNext:  { [unowned self] in
            self.txtEmail.resignFirstResponder()
            self.txtPassword.resignFirstResponder()
        }).subscribe(onNext: { [unowned self] in
            if self.viewModel.validateCredentials() {
                self.viewModel.loginUser()
            }
        }).disposed(by: disposeBag)
    }
    
    func setupCallbacks (){
        // success
        viewModel.isSuccess.asObservable()
            .bind{ isSuccess in
                if isSuccess{
                    self.handleLoginResponse(self.viewModel.modelResponse!)
                }
            }.disposed(by: disposeBag)
                
        // errors
        viewModel.errorMsg.asObservable()
            .bind { errorMessage in
                if errorMessage != ""{
                    alertView(viewController: self, title: kAppName, message: errorMessage, buttons: [AlertButtonTitle.OK], alertViewStyle: .alert) { (index) in
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    func handleLoginResponse(_ model:LoginBaseModel){
        if model.result == 1{
            CoreDataManager.sharedIntance.createDataFor((model.data?.user!)!)
            let ctrl:UserVC = UIStoryboard(storyboard: .Main).instantiateViewController()
            ctrl.userId = "\(model.data?.user?.userId ?? 0)"
            self.navigationController?.pushViewController(ctrl, animated: true)
        }else{
            alertView(viewController: self, title: kAppName, message: model.error_message ?? "", buttons: [AlertButtonTitle.OK], alertViewStyle: .alert) { (index) in
            }
        }
    }
}

