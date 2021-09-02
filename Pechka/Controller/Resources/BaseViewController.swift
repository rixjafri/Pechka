import UIKit
import SystemConfiguration
import NVActivityIndicatorView
import Toast_Swift
import StoreKit


class BaseViewController : UIViewController {
    
    
//MARK:- web live url
//    static let API_URL = "http://localhost:3000/admin/user"
    

//MARK:- web development
  static let API_URL = "http://pachka.uz/psbuysell/index.php/"
 static let IMG_URL = "http://pachka.uz/psbuysell/uploads/"
  static let appColor = UIColor.init(red: 254/255, green: 87/255, blue: 34/225, alpha: 1)
   
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func convertToDictionary(text: String) -> Any? {
          

           do {
                  let data  = try JSONSerialization.jsonObject(with: text.data(using: .utf8)!, options: .allowFragments) as? Array<Dictionary<String, Any>>

                  return data
            }
            catch{
                   print ("Handle error")
            }

           return nil
           
       }


    func rateApp() {

        if #available(iOS 10.3, *) {

            SKStoreReviewController.requestReview()
        
        } else {

            let appID = "Your App ID on App Store"
//            let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
//            let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page
            let urlStr = "https://itunes.apple.com"
            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
            }
        }
    }

    func clearSearchData()  {
            SEARCH_CATEGORY = ""
            SEARCH_CATEGORY_ID = ""
            SEARCH_SUB_CATEGORY_ID = ""
            SEARCH_ITEM_TYPE_ID = ""
            SEARCH_ITEM_CONDITION_ID = ""
            SEARCH_ITEM_PRICE_ID = ""
            SEARCH_ITEM_DEAL_ID = ""
            SEARCH_SUB_CATEGORY = ""
            SEARCH_ITEM_TYPE = ""
            SEARCH_ITEM_CONDITION = ""
            SEARCH_ITEM_PRICE_TYPE = ""
            SEARCH_ITEM_DEAL_OPTION = ""
            SEARCH_SELECTED_ITEM = ""
            OPTION_TYPE = 0
            SEARCH_MIN_RANGE = ""
            SEARCH_MAX_RANGE = ""
            SEARCH_TITLE = ""
        }
        
    //MARK:- Alert
    func alertView (_ title: String = NSLocalizedString("Alert", comment: "") , message: String , controller: UIViewController){
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel, handler: nil))
        controller.present(alert, animated: true)
        

        
    }
    
    
    //MARK:- Acticity Indicator
    var objNVHud = ActivityData(size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE, message: nil, messageFont: nil, type: NVActivityIndicatorType.ballRotateChase, color:appColor, padding: nil, displayTimeThreshold: NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD, minimumDisplayTime: NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME);
    
    func objHudShow(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(objNVHud,nil)
    }
    func objHudHide(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    //MARK:- Validations
    
//    func isValidEmail(testStr:String) -> Bool{
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: testStr)
//    }
    
    
    //MARK:- Internet reachability Method
    func checkInternetConnection() -> Bool
    {
        if !self.connectedToNetwork() {
            
            let alertViewController = UIAlertController(title: NSLocalizedString("Alert!", comment: ""), message: NSLocalizedString("Check internet connection and try again", comment: "") , preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (action) -> Void in
            }
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
            return false
        }
        else{
            return true
        }
    }
    
    func connectedToNetwork() -> Bool{
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags){
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
