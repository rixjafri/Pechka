//
//  PayWithOfflineVC.swift
//  Pechka
//
//  Created by Neha Saini on 03/06/21.
//

import UIKit
import ObjectMapper

class PayWithOfflineVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnPayWithOffline: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAccountNum: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblAccountName: UILabel!
    
    //MARK:- Variable Declaration
    var getPromoteDetailModel:PromoteDetailModel!
    var getPromoteDetailOfflinePayment:[PromoteDetailOfflinePayment]!
    var selectedPrice = ""
    var selectedType = ""
    var selectedDate = ""
    var getItemId = ""
    var getPaymentMethod = ""
    var selectedDateEnd = Date()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getPromoteDetailApi()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_payWithOfflineBtnTapped(_ sender: UIButton)
    {
        addPaidAdApi()
    }
    
    //MARK:- Web Services
    func getPromoteDetailApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let dateCheck = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateCurrent = formatter.string(from: dateCheck)
        
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = [
            :
              ]
        
        print(params);
        
        WebService.shared.apiGet(url: BaseViewController.API_URL+"rest/offline_payments/get_offline_payment/api_key/teampsisthebest/limit/6/offset/0", parameters: [:]) { (response, error) in
            if error == nil{
            
            self.getPromoteDetailModel = Mapper<PromoteDetailModel>().map(JSONObject: response)
                self.lblTitle.text = self.getPromoteDetailModel.message ?? ""
                if let data = self.getPromoteDetailModel.offlinePayment
                {
                    self.getPromoteDetailOfflinePayment = data
                    if self.getPromoteDetailOfflinePayment.count != 0
                    {
                        if let imgUrl = self.getPromoteDetailOfflinePayment?[0].defaultIcon?.imgPath
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(imgUrl)
                            
                            self.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "bank"))
                          
                        
                        }
                        
                        if let title = self.getPromoteDetailOfflinePayment?[0].title
                        {
                            self.lblAccountNum.text = title
                        }
                        
                        if let titleDes = self.getPromoteDetailOfflinePayment?[0].descriptionField
                        {
                            self.lblAccountName.text = titleDes
                        }
                       
                    }
                   
                }
               
            }
           else
            {
             self.view.makeToast(NSLocalizedString(self.getPromoteDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
            }

    }
    

  
}
    func addPaidAdApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
       
        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .minute, value: +30, to: selectedDateEnd)

        print(now) // 2016-12-19 21:52:04 +0000
        print(String(describing: oneHourAgo))
        let nowDouble = oneHourAgo!.millisecondsSince1970
        
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        
        let params: [String: Any] = [
            "item_id":getItemId,
            "start_date":selectedDate,
            "how_many_day":selectedType,
            "payment_method":"offline",
            "payment_method_nonce":"",
            "start_timestamp":"\(nowDouble)",
            "razor_id":"",
            "amount":selectedPrice
              ]
        
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/paid_items/add/api_key/teampsisthebest", parameters: params) { (response, error) in
            if error == nil{
            
            self.getPromoteDetailModel = Mapper<PromoteDetailModel>().map(JSONObject: response)
                self.navigationController?.popToRootViewController(animated: true)
            }
           else
            {
             self.view.makeToast(NSLocalizedString(self.getPromoteDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
            }

    }
    

  
}
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
