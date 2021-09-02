//
//  ContactsVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import ObjectMapper

class ContactsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var viewBgSideMenu: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lineEmail: UILabel!
    @IBOutlet weak var imgMobileNum: UIImageView!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var lineMobileNumber: UILabel!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var imgUserName: UIImageView!
    @IBOutlet weak var lineUserName: UILabel!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var constWidthViewSideMenu: NSLayoutConstraint!
    @IBOutlet weak var tbleViewSideMenu: UITableView!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var getForgotModel:ForgotModel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
        }
        else
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
        }
        tbleViewSideMenu.reloadData()
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
       
        viewBgSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewBgSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewBgSideMenu.layer.shadowOpacity = 0.7
        viewBgSideMenu.layer.shadowRadius = 1.5
     
        tbleViewSideMenu.delegate = self
        tbleViewSideMenu.dataSource = self
        tbleViewSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleViewSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleViewSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleViewSideMenu.tableFooterView = customView
        tbleViewSideMenu.tableFooterView?.isHidden = false
        btnSubmit.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnSubmit.layer.cornerRadius = 15
        btnSubmit.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        txtViewMessage.delegate = self
        tfUserName.delegate = self
        tfEmail.delegate = self
        tfMobileNumber.delegate = self
        txtViewMessage.layer.cornerRadius = 5
        txtViewMessage.layer.borderWidth = 1
        txtViewMessage.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewMessage.delegate = self
        txtViewMessage.text = NSLocalizedString("Add a message", comment: "")
        txtViewMessage.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtViewMessage
        {
            if (txtViewMessage.text ==  NSLocalizedString("Add a message", comment: ""))
            {
                txtViewMessage.text = ""
                txtViewMessage.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        
      
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtViewMessage
        {
            if (txtViewMessage.text == "")
            {
                txtViewMessage.text = NSLocalizedString("Add a message", comment: "")
                txtViewMessage.textColor = .lightGray
            }
           
        }
      
    }
    
    func emailValidation() {
        if Helper.shared.isFieldEmpty(field: tfEmail.text!) || Helper.shared.isValidEmail(candidate: tfEmail.text!)
        {
          lineEmail.backgroundColor = BaseViewController.appColor
           imgEmail.isHidden = true

        }
        else
        {
            lineEmail.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgEmail.isHidden = false
        }
    }
    
    func usernameValidation() {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
           lineUserName.backgroundColor = BaseViewController.appColor
           imgUserName.isHidden = true

        }
        else
        {
            lineUserName.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgUserName.isHidden = false
        }
    }
    
    func validateMobile() {
        if Helper.shared.isFieldEmpty(field: tfMobileNumber.text!)
         {
            lineMobileNumber.backgroundColor = BaseViewController.appColor
            imgMobileNum.isHidden = true
        }
        else
         {
            if tfMobileNumber.text!.count >= 9
            {
                lineMobileNumber.backgroundColor = BaseViewController.appColor
                imgMobileNum.isHidden = true
            }
            else
            {
                lineMobileNumber.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
                imgMobileNum.isHidden = false
            }
            
            
        }
        
    }
    
    //MARK:- UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfUserName && range.length == 1 && range.location == 0 {
            lineUserName.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgUserName.isHidden = true

        }
        else if textField == tfEmail && range.length == 1 && range.location == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

        }
        else if textField == tfMobileNumber && range.length == 1 && range.location == 0 {

            lineUserName.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgMobileNum.isHidden = true

        }
        else if textField == tfUserName {
            usernameValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }
        else if textField == tfEmail {
            emailValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }else if textField == tfMobileNumber{
            if tfMobileNumber.text != ""
            {
                validateMobile()
            }
            
           
        }
        return true
    }
    
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == tfUserName && tfUserName.text?.count == 0 {
        lineUserName.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
        imgUserName.isHidden = true

    }
    else if textField == tfEmail && tfEmail.text?.count == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

    }else if textField == tfMobileNumber && tfMobileNumber.text?.count == 0 && tfMobileNumber.text!.count < 10 {

           lineMobileNumber.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
           imgMobileNum.isHidden = true

        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
//        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfUserName
        {
            tfEmail.becomeFirstResponder()
        }
        else if textField == tfEmail
        {
            tfMobileNumber.becomeFirstResponder()
        }
        else if textField == tfMobileNumber
        {
            textField.resignFirstResponder()
        }
        
        
        return true
    }
   //MARK:- IBActions
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        btnHideSideMenu.isUserInteractionEnabled = true
        constWidthViewSideMenu.constant = self.view.frame.width-100
    }
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthViewSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_submitBtnTapped(_ sender: UIButton)
    {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
          usernameValidation()
        }
        if Helper.shared.isFieldEmpty(field: tfEmail.text!)
        {
          emailValidation()
        }
        else if  Helper.shared.isValidEmail(candidate: tfEmail.text!)
        {
          emailValidation()
        }
        else if Helper.shared.isFieldEmpty(field: tfMobileNumber.text!)
        {
           validateMobile()
        }
        else if tfMobileNumber.text!.count < 10
        {
            validateMobile()
        }
        else if txtViewMessage.text == "" || txtViewMessage.text == NSLocalizedString("Add a message", comment: "")
        {
            self.view.makeToast(NSLocalizedString("Please enter message", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
            contactsusApi(getUserName:tfUserName.text!,getMessage:txtViewMessage.text!,getUserEmail:tfEmail.text!,getPhone:tfMobileNumber.text!)
        }
    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
      if tableView == tbleViewSideMenu
      {
        return 4
      }
      else
      {
        return 1
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbleViewSideMenu
        {
            if section == 0
            {
              return 1
            }
            else if section == 1
            {
              return menuHomeNames.count
            }
            else if section == 2
            {
              return menuUserInfoNames.count
            }
            else if section == 3
            {
                return menuAppIcons.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
        
    }
    
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == tbleViewSideMenu
        {
            if section == 0
            {
              return nil
            }
            else if section == 1
              {
                  let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                  let customlabel = UILabel(frame: CGRect(x: 10, y: 5, width: 220, height: 30))
                  customView.layer.masksToBounds = true
                  customlabel.font = UIFont(name: "OpenSans-SemiBold",
                  size: 15.0)
                  customlabel.text = NSLocalizedString("Home", comment: "")
                  customlabel.textColor = BaseViewController.appColor
                  customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                  customView.addSubview(customlabel)
                  return customView
              }
              else if section == 2
              {
                  let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                  let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                  customView.layer.masksToBounds = true
                  customlabel.font = UIFont(name: "Poppins-SemiBold.ttf",
                   size: 15.0)
                  customlabel.text = NSLocalizedString("User Info", comment: "")
                  customlabel.textColor =  BaseViewController.appColor
                  customView.backgroundColor = UIColor.white
                  customView.addSubview(customlabel)
               
                  return customView
              }
              else if section == 3
               {
                
                  let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                  let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                  customView.layer.masksToBounds = true
                  customlabel.font = UIFont(name: "Poppins-SemiBold.ttf",
                   size: 15.0)
                  customlabel.text = NSLocalizedString("App", comment: "")
                  customlabel.textColor = BaseViewController.appColor
                  customView.backgroundColor =  UIColor.white
                  customView.addSubview(customlabel)
              
                  return customView
               
                 
               }
              else
              {
                  return nil
              }
        }
        else
        {
            return nil
        }
        
        }
      
    
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
{
   if tableView == tbleViewSideMenu
   {
    if section == 0
    {
        return 0
    }
    else
    {
       return 40
    }
   }
   else
   {
    return 0
   }
      
}

func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
{
  view.tintColor = .clear
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    if tableView == tbleViewSideMenu
    {
        if indexPath.section == 0
        {
            return 150
        }
        else
        {
            return 40
        }
    }
    else
    {
        return UITableView.automaticDimension
    }
 
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
            if indexPath.section == 0
            {
                let cell = tbleViewSideMenu.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
                if let userName = defaultValues.value(forKey: "userName")
                {
                    cell.lblName.text = "\(userName)"
                }
                if let imageName = defaultValues.value(forKey: "profile"){
                        let imgName = "\(imageName)"
                        var imageUrl = BaseViewController.IMG_URL
                        imageUrl.append(imgName)
                    
                    defaultValues.synchronize()
                    cell.imgView.sd_setShowActivityIndicatorView(true)
                    cell.imgView.sd_setIndicatorStyle(.gray)
                    cell.imgView!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:UIImage(named: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
       
                        
                    }
                if let userEmail = defaultValues.value(forKey: "addedDate")
                {
                    cell.lblDate.text = "\(userEmail)"
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else if indexPath.section == 1
            {
                let cell = tbleViewSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuHomeNames[indexPath.row]
                cell.imgview.image = UIImage(named: homeIconscons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else if indexPath.section == 2
            {
                let cell = tbleViewSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuUserInfoNames[indexPath.row]
                cell.imgview.image = UIImage(named: menuUserInfoIcons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else
            {
                let cell = tbleViewSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuAppNames[indexPath.row]
                cell.imgview.image = UIImage(named: menuAppIcons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        
        
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      if tableView == tbleViewSideMenu
      {
        btnHideSideMenu.isUserInteractionEnabled = false
        constWidthViewSideMenu.constant = 0
        if indexPath.section == 0
        {
            
        }
        else if indexPath.section == 1
        {
            if menuHomeNames[indexPath.row] == NSLocalizedString("Home", comment: "")
            {
                APPDELEGATE.userTabbarCheck(value: 0)
            }
            else if menuHomeNames[indexPath.row] == NSLocalizedString("Category", comment: "")
            {
                APPDELEGATE.userTabbarCheck(value: 1)
            }
            else if menuHomeNames[indexPath.row] == NSLocalizedString("Latest Items", comment: "")
            {
                let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
                    objRef.screenCheck = "Latest Items"
                objRef.titleName = "Latest Items"
                self.clearSearchData()
                if APPDELEGATE.getAllRecentItems.count != 0
                {
                    APPDELEGATE.getPopularLatestList.removeAllObjects()
                    for i in 0..<APPDELEGATE.getAllRecentItems.count
                    {
                        APPDELEGATE.getPopularLatestList.insert(APPDELEGATE.getAllRecentItems[i], at: APPDELEGATE.getPopularLatestList.count)
                    }
                    self.navigationController?.pushViewController(objRef, animated: true)
                }
               
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuHomeNames[indexPath.row] == NSLocalizedString("Popular Items", comment: "")
            {
                let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
                objRef.screenCheck = "Popular Items"
                objRef.titleName = "Popular Items"
                if APPDELEGATE.getAllPopularItems.count != 0
                {
                    APPDELEGATE.getPopularLatestList.removeAllObjects()
                    for i in 0..<APPDELEGATE.getAllPopularItems.count
                    {
                        APPDELEGATE.getPopularLatestList.insert(APPDELEGATE.getAllPopularItems[i], at: APPDELEGATE.getPopularLatestList.count)
                    }
                }
                self.clearSearchData()
                self.navigationController?.pushViewController(objRef, animated: true)
            }
        }
        else if indexPath.section == 2
        {
            if menuUserInfoNames[indexPath.row] == NSLocalizedString("Profile", comment: "")
            {
                let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
                if userId != ""
                {
                    APPDELEGATE.userTabbarCheck(value: 2)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil, userInfo: nil)
                }
                else
                {
                    APPDELEGATE.userTabbarCheck(value: 2)
                }
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Message", comment: "")
            {
                APPDELEGATE.userTabbarCheck(value: 3)
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Favourite", comment: "")
            {
                let objRef: FavouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as!  FavouritesVC
                self.navigationController?.pushViewController(objRef, animated: true)
                
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Paid Ad Transaction", comment: "")
            {
                let objRef: PaidADTransactionVC = self.storyboard?.instantiateViewController(withIdentifier: "PaidADTransactionVC") as!  PaidADTransactionVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("User History", comment: "")
            {
                let objRef: WishListVC = self.storyboard?.instantiateViewController(withIdentifier: "WishListVC") as!  WishListVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Offer", comment: "")
            {
                let objRef: OfferVC = self.storyboard?.instantiateViewController(withIdentifier: "OfferVC") as!  OfferVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Log out", comment: "")
            {
                let objRef:LogoutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
                objRef.modalPresentationStyle = .fullScreen
                self.present(objRef, animated: true, completion: nil)
            }
           
        }
        else
        {
            if menuAppNames[indexPath.row] == NSLocalizedString("Language", comment: "")
            {
                let objRef: LanguageVC = self.storyboard?.instantiateViewController(withIdentifier: "LanguageVC") as!  LanguageVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuAppNames[indexPath.row] == NSLocalizedString("Settings", comment: "")
            {
                let objRef: SettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as!  SettingsVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuAppNames[indexPath.row] == NSLocalizedString("Contact us", comment: "")
            {
               
            }
            else if menuAppNames[indexPath.row] == NSLocalizedString("Privacy Policy", comment: "")
            {
                let objRef: PrivacyPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as!  PrivacyPolicyVC
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else if menuAppNames[indexPath.row] == NSLocalizedString("Share App", comment: "")
            {
                let link = "Take a look at : Pachka - http://play.google.com/store/apps/details?id=com.pachka.uz"
                let textToShare = [link]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
                self.present(activityViewController, animated: true, completion: nil)
            }
            else if menuAppNames[indexPath.row] == NSLocalizedString("Rate this app", comment: "")
            {
                if let url = URL(string: "http://play.google.com/store/apps/details?id=com.pachka.uz") {
                    UIApplication.shared.open(url)
                }
            }
        
        }
      }
      else
      {
      
      }
     }
    
    
    //MARK:- WebServices
    func contactsusApi(getUserName:String,getMessage:String,getUserEmail:String,getPhone:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        
        let params: [String: Any] = ["contact_name":getUserName,"contact_email":getUserEmail,"contact_message":getMessage,"contact_phone":getPhone]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/contacts/add/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)
            
        if self.getForgotModel.status != "error"
        {
            self.tfUserName.text = ""
            self.tfMobileNumber.text = ""
            self.tfEmail.text = ""
            self.txtViewMessage.text = ""
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
}
