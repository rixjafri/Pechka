//
//  PromoteVC.swift
//  Pechka
//
//  Created by Neha Saini on 01/06/21.
//

import UIKit
import Alamofire
import ObjectMapper

class PromoteVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    //MARK:- Outlets
    @IBOutlet weak var btnPayWithPaypal: UIButton!
    @IBOutlet weak var btnPayWithStripe: UIButton!
    @IBOutlet weak var btnPayWithOffline: UIButton!
    @IBOutlet weak var btnPayWithRazor: UIButton!
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfStartDate: UITextField!
    
    //MARK:- Variable Declaration
    var datePicker = UIDatePicker()
    var arrDayType = [NSLocalizedString("Promote For 7 Days", comment: ""),NSLocalizedString("Promote For 14 Days", comment: ""),NSLocalizedString("Promote For 30 Days", comment: ""),NSLocalizedString("Promote For 60 Days", comment: ""),NSLocalizedString("Custom" , comment: "")]
    var daySelected = ""
    var getPromoteModel:PromoteModel!
    var getItemId = ""
    var selectedDate = ""
    var selectedDateEnd = Date()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        showDatePicker()
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdatePrice), name: NSNotification.Name(rawValue: "UpdatePrice"), object: nil)
        tfStartDate.delegate = self
        getPromoteApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Date Pickers
    func showDatePicker()   {
        //Formate Date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
              }
        datePicker.datePickerMode = .dateAndTime
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.calendar = calendar

        datePicker.minimumDate = currentDate
      
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(PromoteVC.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: UIBarButtonItem.Style.plain, target: self, action: #selector(PromoteVC
            .cancelDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        tfStartDate.inputAccessoryView = toolbar
        tfStartDate.inputView = datePicker
    }
    
   
        @objc func donedatePicker(){
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
            tfStartDate.text = formatter.string(from: datePicker.date)
            let formatters = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_CA") as Locale
            formatters.dateFormat = "yyyy-MM-dd HH:mm:ss"
            selectedDate = formatters.string(from: datePicker.date)
            selectedDateEnd = datePicker.date
            self.view.endEditing(true)
        }
        
        @objc func cancelDatePicker(){
            self.view.endEditing(true)
        }
    
    @objc func UpdatePrice(_ notification: Notification)
    {
        if (notification.name.rawValue == "UpdatePrice")
        {
            tbleView.reloadData()
        }
    }
    //MARK:- Custom Methods
    func setInitials()
    {
        tbleView.delegate = self
        tbleView.dataSource = self
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_selectUnSelectBtnTapped(_ sender: UIButton)
    {
       
    }
    
    @IBAction func action_paypalBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_stripeBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_razorBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_payWithOffline(_ sender: UIButton)
    {
        if tfStartDate.text == ""
        {
            self.view.makeToast(NSLocalizedString("Please select start date", comment: ""), duration: 1.0, position: .center)
        }
        else if daySelected == ""
        {
            self.view.makeToast(NSLocalizedString("Please select type of days", comment: ""), duration: 1.0, position: .center)
        }
        else if daySelected == NSLocalizedString("Custom", comment: "")
        {
            let priceTf = "\(defaultValues.value(forKey: "PromotePrice") ?? "")"
            if priceTf == ""
            {
                self.view.makeToast(NSLocalizedString("Please enter price", comment: ""), duration: 1.0, position: .center)
            }
            else
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
              
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                let priceTf = "\(defaultValues.value(forKey: "PromotePrice") ?? "")"
                let finalPrice = Int(priceTf) ?? 0
                objRef.selectedType = priceTf
                objRef.selectedPrice = "\(price*finalPrice)"
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
        }
        else
        {
            if daySelected == NSLocalizedString("Promote For 7 Days", comment: "")
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
                objRef.selectedType = "7"
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                objRef.selectedPrice = "\(price*7)"
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if daySelected == NSLocalizedString("Promote For 14 Days", comment: "")
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
                objRef.selectedType = "14"
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                objRef.selectedPrice = "\(price*14)"
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if daySelected == NSLocalizedString("Promote For 30 Days", comment: "")
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
                objRef.selectedType = "30"
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                objRef.selectedPrice = "\(price*30)"
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if daySelected == NSLocalizedString("Promote For 60 Days", comment: "")
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
                objRef.selectedType = "60"
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                objRef.selectedPrice = "\(price*60)"
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if daySelected == NSLocalizedString("Custom", comment: "")
            {
                let objRef:PayWithOfflineVC = self.storyboard?.instantiateViewController(withIdentifier: "PayWithOfflineVC") as! PayWithOfflineVC
                objRef.selectedDate = selectedDate
              
                let price = Int(self.getPromoteModel.oneday ?? "") ?? 0
                let priceTf = "\(defaultValues.value(forKey: "PromotePrice") ?? "")"
                let finalPrice = Int(priceTf) ?? 0
                objRef.selectedPrice = "\(price*finalPrice)"
                objRef.selectedType = priceTf
                objRef.getItemId = getItemId
                objRef.getPaymentMethod = "offline"
                objRef.selectedDateEnd = selectedDateEnd
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            
        }
    }
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrDayType.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
      let cell = tbleView.dequeueReusableCell(withIdentifier: "promoteTbleViewCell") as! promoteTbleViewCell
        cell.lblName.text = arrDayType[indexPath.row]
        cell.btnSelectUnSelect.tag = indexPath.row
     
        cell.btnSelectUnSelect.setImage(UIImage(named: "radioUnSelect"), for: .normal)
        if self.getPromoteModel != nil
        {
            let price = self.getPromoteModel.oneday
            let priceInt = Int(price ?? "")
            if arrDayType[indexPath.row] == NSLocalizedString("Promote For 7 Days", comment: "")
            {
                cell.lblDays.text = "7 days"
                cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*7))"
                cell.tfPrice.isHidden = true
            }
            else if arrDayType[indexPath.row] == NSLocalizedString("Promote For 14 Days", comment: "")
            {
                cell.lblDays.text = "14 days"
                cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*14))"
                cell.tfPrice.isHidden = true
            }
            else if arrDayType[indexPath.row] == NSLocalizedString("Promote For 30 Days", comment: "")
            {
                cell.lblDays.text = "30 days"
                cell.tfPrice.isHidden = true
                cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*30))"
            }
            else if arrDayType[indexPath.row] == NSLocalizedString("Promote For 60 Days", comment: "")
            {
                cell.lblDays.text = "60 days"
                cell.tfPrice.isHidden = true
                cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*60))"
            }
            else if arrDayType[indexPath.row] == NSLocalizedString("Custom", comment: "")
            {
                cell.lblDays.text = "days"
                let priceTf = "\(defaultValues.value(forKey: "PromotePrice") ?? "")"
                let IntTf = Int(priceTf) ?? 0
                if priceTf != ""
                {
                    cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*IntTf))"
                }
                else
                {
                    cell.lblPrice.text = "\(self.getPromoteModel.currencySymbol ?? "") \((priceInt!*IntTf))"
                }
                cell.tfPrice.isHidden = false
            }
          
            if daySelected == arrDayType[indexPath.row]
            {
                cell.btnSelectUnSelect.setImage(UIImage(named: "radio"), for: .normal)
            }
            else
            {
                cell.btnSelectUnSelect.setImage(UIImage(named: "radioUnSelect"), for: .normal)
            }
        }
        
       cell.selectionStyle = UITableViewCell.SelectionStyle.none
       return cell
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        daySelected = arrDayType[indexPath.row]
        tbleView.reloadData()
    }
    
    
    //MARK:- Web Services
//    func getPromoteApi()
//     {
//            //self.objHudShow()
//            //self.blurEffect.isHidden = false
//
//         let headers1 = [
//             "Accept": "application/json"
//
//         ]
//
//        let dateCheck = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateCurrent = formatter.string(from: dateCheck)
//
//        let userId = defaultValues.value(forKey: "UserID") ?? ""
//        let parametersList:[String : Any] = [
//          "user_id":userId,
//          "start_date":dateCurrent,
//          "end_date":dateCurrent
//            ]
//      print(parametersList)
//      Alamofire.request(BaseViewController.API_URL+"rest/appinfo/get_delete_history/api_key/teampsisthebest", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
//
//            switch response.result {
//
//            case .success (let value):
//                APPDELEGATE.getFavtems.removeAllObjects()
//                if let array = response.result.value as? [Any] {
//                    print("Got an array with \(array.count) objects")
//                    let resultsArray = value as! [AnyObject]
//
//                    for i in 0..<resultsArray.count
//                    {
//
//                        APPDELEGATE.getFavtems.insert(resultsArray[i], at:  APPDELEGATE.getFavtems.count)
//                    }
//                }
//                else if let dictionary = response.result.value as? [AnyHashable: Any] {
//                    print("Got a dictionary: \(dictionary)")
//                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
//                }
//
//
//
//
//                self.tbleView.reloadData()
//
//            break
//
//            case .failure:
//
//            // self.refreshControl.endRefreshing()
//
//           // self.blurEffect.isHidden = true
//
//            //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)
//
//            break
//            }
//          }
// }
    func getPromoteApi()
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
            "user_id":userId,
            "start_date":dateCurrent,
            "end_date":dateCurrent
              ]
        
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/appinfo/get_delete_history/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            
            self.getPromoteModel = Mapper<PromoteModel>().map(JSONObject: response)
       
   if self.getPromoteModel.status != "error"
   {
    if self.getPromoteModel.razorEnabled == "1"
    {
        self.btnPayWithRazor.isHidden = false
    }
    else
    {
        self.btnPayWithRazor.isHidden = true
    }
    if self.getPromoteModel.paypalEnabled == "1"
    {
        self.btnPayWithPaypal.isHidden = false
    }
    else
    {
        self.btnPayWithPaypal.isHidden = true
    }
    if self.getPromoteModel.stripeEnabled == "1"
    {
        self.btnPayWithStripe.isHidden = false
    }
    else
    {
        self.btnPayWithStripe.isHidden = true
    }
    self.tbleView.reloadData()
    
   }else{
    self.view.makeToast(NSLocalizedString(self.getPromoteModel.message ?? "", comment: ""), duration: 1.0, position: .center)
   }

    }
    
}
  
}
}
