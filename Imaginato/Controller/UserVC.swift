import Foundation
import UIKit

class UserVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var lblUserId: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserCreated: UILabel!

    //MARK:- VARS
    var userId = ""
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupInitialUI()
    }
    
    //MARK:- Other Methods
    func setupInitialUI(){
        guard let user = coredata_manager.retrieveDataFor(self.userId) else {
            return
        }
        
        self.lblUserId.text = "Id: " + "\(user.userId ?? 0)"
        self.lblUserName.text = "Name: " + (user.userName ?? "")
        self.lblUserCreated.text = "Created Date: " + (getStringFromData(user.date!) ?? "")
    }
}
