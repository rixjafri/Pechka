//
//  UserVC.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import ObjectMapper
import Alamofire

class UserVC: BaseViewController, GIDSignInDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnSignUP: UIButton!
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var linePassword: UILabel!
    @IBOutlet weak var lineEmail: UILabel!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnSelectUnSelectPolicy: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var imgPasswrd: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var tbleViewSideMenu: UITableView!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var email = ""
    var googleId = ""
    var googleFullname = ""
    var googleGivenName = ""
    var googleFamilyName = ""
    var googleEmail = ""
    var policy = false
    
    var getAddUserModel:AddUserModel!
    var getAddUserRatingDetail:AddUserRatingDetail!
    var getForgotModel:ForgotModel!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        constWidthSideMenu.constant = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        let notificationCount = "\(defaultValues.value(forKey: "PushNotiCount") ?? "")"
        if notificationCount != "0" && notificationCount != ""
        {
            self.lblNotificationCount.isHidden = false
            self.lblNotificationCount.text = notificationCount
        }
        else
        {
            self.lblNotificationCount.isHidden = true
        }
        getNotificationCountApi()
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
//            let objRef:ProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
//            self.navigationController?.pushViewController(objRef, animated: true)
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
        }
        else
        {
           // self.navigationController?.popViewController(animated: true)
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
        }
        tbleViewSideMenu.reloadData()
    }
    //MARK:- Custom Methods
    func setInitials()
    {
       
        tfEmail.delegate = self
        tfPassword.delegate = self
        btnSelectUnSelectPolicy.setImage(UIImage(named: "unSelected"), for: .normal)
        btnLogin.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnLogin.layer.cornerRadius = 15
        btnLogin.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        viewSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewSideMenu.layer.shadowOpacity = 0.7
        viewSideMenu.layer.shadowRadius = 1.5
        tbleViewSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleViewSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        tbleViewSideMenu.delegate = self
        tbleViewSideMenu.dataSource = self
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleViewSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleViewSideMenu.tableFooterView = customView
        tbleViewSideMenu.tableFooterView?.isHidden = false
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        let attImg = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrImg = NSAttributedString(string: NSLocalizedString("NEW HERE?", comment: ""), attributes: attImg)
        let attImg1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrImg1 = NSAttributedString(string: NSLocalizedString(" SIGN UP", comment: ""), attributes: attImg1)
        let combination = NSMutableAttributedString()
        combination.append(attrStrImg)
        combination.append(attrStrImg1)
        btnSignUP.setAttributedTitle(combination, for: .normal)
        
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
    
    func validatePasword() {
         if Helper.shared.isFieldEmpty(field: tfPassword.text!)
         {
            linePassword.backgroundColor = BaseViewController.appColor
            imgPasswrd.isHidden = true
        }
        else
         {
          
            linePassword.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgPasswrd.isHidden = false
            
        }
        
    }
    
    //MARK:- UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfEmail && range.length == 1 && range.location == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

        }
        else if textField == tfPassword && range.length == 1 && range.location == 0 {

            linePassword.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgPasswrd.isHidden = true

        }
        else if textField == tfEmail {
            emailValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }else if textField == tfPassword {
            validatePasword()
           
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfEmail && tfEmail.text?.count == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

        }else if textField == tfPassword && tfPassword.text?.count == 0 {

            linePassword.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
           imgPasswrd.isHidden = true

        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
//        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfEmail
        {
            tfPassword.becomeFirstResponder()
        }
        else if textField == tfPassword
        {
            tfPassword.resignFirstResponder()
        }
        
        return true
    }
    //MARK:- IBActions
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        constWidthSideMenu.constant = self.view.frame.width-100
        btnHideSideMenu.isUserInteractionEnabled = true
    }
    
    @IBAction func action_bellBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_forgotBtnTapped(_ sender: UIButton)
    {
        let objRef:ForgotPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_selectUnSelectPolicyBtnTapped(_ sender: UIButton)
    {
        if sender.currentImage == UIImage(named: "unSelected")
           {
              policy = true
              sender.setImage(UIImage(named: "selected"), for: .normal)
              
           }
          else
           {
              policy = false
              sender.setImage(UIImage(named: "unSelected"), for: .normal)
           }
    }
    @IBAction func action_privacyPolicyBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_loginBtnTapped(_ sender: UIButton)
    {
        if Helper.shared.isFieldEmpty(field: tfEmail.text!)
        {
            emailValidation()
            validatePasword()
        }
        else if  Helper.shared.isValidEmail(candidate: tfEmail.text!){
            
            emailValidation()
            validatePasword()
        }
        else if Helper.shared.isFieldEmpty(field: tfPassword.text!)  {
            
            emailValidation()
            validatePasword()

        }
//        else if policy == false
//        {
//            self.view.makeToast(NSLocalizedString("Please select privacy policy.", comment: ""), duration: 3.0, position: .center)
//        }
        else
        {
            SignInApi(getEmail:tfEmail.text!,getPassword:tfPassword.text!)
            
        }
    }
    
    @IBAction func action_phoneBtnTapped(_ sender: UIButton)
    {
        let objRef:SignUpWithPhoneVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpWithPhoneVC") as! SignUpWithPhoneVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_facebookBtnTapped(_ sender: UIButton)
    {
        loginWithFacebook()
    }
    
    @IBAction func action_googleBtnTapped(_ sender: UIButton)
    {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }

    @IBAction func action_signUpBtnTapped(_ sender: UIButton)
    {
        let objRef:SignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
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
      
    
func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
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

func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
{
  view.tintColor = .clear
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
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
        btnHideSideMenu.isUserInteractionEnabled = false
        constWidthSideMenu.constant = 0
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
                APPDELEGATE.getPopularLatestList.removeAllObjects()
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
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Log out", comment: "")
            {
                let objRef:LogoutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
                objRef.modalPresentationStyle = .fullScreen
                self.present(objRef, animated: true, completion: nil)
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
                let objRef: ContactsVC = self.storyboard?.instantiateViewController(withIdentifier: "ContactsVC") as!  ContactsVC
                self.navigationController?.pushViewController(objRef, animated: true)
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
    
    //MARK: - GIDSignIn Delegate
       func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
       {
           if (error == nil)
           {
               // Perform any operations on signed in user here.
               let userId = user.userID                  // For client-side use only!
               googleId = userId!
               print("Userid: \(String(describing: userId!))")
               
               let fullName = user.profile.name ?? ""
               googleFullname = fullName
         
               print("fullname:\(String(describing: fullName))")
               let givenName = user.profile.givenName ?? ""
               googleGivenName = givenName
               print("givenName: \(String(describing: givenName))")
               let familyName = user.profile.familyName ?? ""
               googleFamilyName = familyName
               print("familyName: \(String(describing: familyName))")
               let email1 = user.profile.email ?? ""
               googleEmail = email1
               print("email:\(String(describing: email1))")
            let GoogleParam: NSMutableDictionary = NSMutableDictionary.init()
            GoogleParam.setValue("", forKey: "profile_photo_url")
            GoogleParam.setValue(googleFullname, forKey: "user_name")
            GoogleParam.setValue(googleEmail, forKey: "user_email")
         
            GoogleParam.setValue(googleId, forKey: "google_id")
          
            
            var deviceID = ""
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
              print(uuid)
                deviceID = uuid
            }
       
            GoogleParam.setValue(deviceID, forKey: "device_token")
            SignUpWithGoogleApi(GoogleParam)
           } else {
               print("ERROR ::\(error.localizedDescription)")
            self.view.makeToast(NSLocalizedString(error.localizedDescription , comment: ""), duration: 1.0, position: .center)
           }
       }
       
       // Finished disconnecting |user| from the app successfully if |error| is |nil|.
       public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
       {
           
       }
    
    //MARK:- Facebook
    func loginWithFacebook()
    {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile,.email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, _):
                
                let graphReq : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "picture.width(512).height(512), name, email, first_name, last_name"])
                graphReq.start(completionHandler: { (connection, userInfo, error) in
                    
                    if(userInfo != nil)
                    {
                        
                        print(userInfo)
                        //save user id and make entry in database
                        
                        let result = userInfo as! NSDictionary
                        let profile = result["picture"] as! NSDictionary
                        let Profiledata = profile["data"] as! NSDictionary
                        let profileImg = Profiledata["url"] as! String
                        let FacebookParam: NSMutableDictionary = NSMutableDictionary.init()
                        FacebookParam.setValue(profileImg, forKey: "profile_img_id")
                        
                        let username = "\(result.object(forKey: "first_name") ?? "")" + " " + "\(result.object(forKey: "last_name") ?? "")"
                        
                        FacebookParam.setValue(username , forKey: "user_name")
                     
                        FacebookParam.setValue(result.object(forKey: "id"), forKey: "facebook_id")
                        FacebookParam.setValue(result.object(forKey: "email"), forKey: "user_email")
                        
                        var deviceID = ""
                        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                          print(uuid)
                            deviceID = uuid
                        }
                   
                        FacebookParam.setValue(deviceID, forKey: "device_token")
                        loginManager.logOut()
                        
                        self.SignUpWithFacebookApi(FacebookParam)
                        loginManager.logOut()
                        
                    
                        
                    }
                    else
                    {
                        
                    }
                })
            }
        }
    }
   
    
    //MARK:- WebServices
    func SignUpWithGoogleApi(_ paramDict: NSMutableDictionary)
    {
        objHudShow()
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/google_register/api_key/teampsisthebest", parameters: paramDict as! [String : Any]) { (response, error) in
        if error == nil{
                 
        self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
        self.objHudHide()
        if self.getAddUserModel.status != "error"
        {
            if let data = self.getAddUserModel.ratingDetails
            {
                self.getAddUserRatingDetail = data
                defaultValues.setValue(self.getAddUserModel.userId, forKey: "UserID")
                
                APPDELEGATE.getAddUserModel = self.getAddUserModel
                APPDELEGATE.getAddUserRatingDetail = self.getAddUserRatingDetail
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userName ?? "", forKey: "userName")
              
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userProfilePhoto ?? "", forKey: "profile")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.addedDate ?? "", forKey: "addedDate")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.ratingCount ?? "", forKey: "ratingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followingCount ?? "", forKey: "followingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followerCount ?? "", forKey: "followerCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userEmail ?? "", forKey: "Email")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.city ?? "", forKey: "City")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAboutMe ?? "", forKey: "AboutMe")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAddress ?? "", forKey: "Address")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userPhone ?? "", forKey: "Phone")
                defaultValues.synchronize()
                self.NotificationRegisterApi()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil, userInfo: nil)
            }
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddUserModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    
    func SignUpWithFacebookApi(_ paramDict: NSMutableDictionary)
    {
    objHudShow()
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/facebook_register/api_key/teampsisthebest", parameters: paramDict as! [String : Any]) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
            
        if self.getAddUserModel.status != "error"
        {
            if let data = self.getAddUserModel.ratingDetails
            {
                self.getAddUserRatingDetail = data
                APPDELEGATE.getAddUserModel = self.getAddUserModel
                APPDELEGATE.getAddUserRatingDetail = self.getAddUserRatingDetail
                defaultValues.setValue(self.getAddUserModel.userId, forKey: "UserID")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userName ?? "", forKey: "userName")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userProfilePhoto ?? "", forKey: "profile")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.addedDate ?? "", forKey: "addedDate")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.ratingCount ?? "", forKey: "ratingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followingCount ?? "", forKey: "followingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followerCount ?? "", forKey: "followerCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userEmail ?? "", forKey: "Email")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.city ?? "", forKey: "City")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAboutMe ?? "", forKey: "AboutMe")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAddress ?? "", forKey: "Address")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userPhone ?? "", forKey: "Phone")
                defaultValues.synchronize()
                self.NotificationRegisterApi()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil, userInfo: nil)
            }
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddUserModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    
    func SignInApi(getEmail:String,getPassword:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        
        let params: [String: Any] = ["user_email":getEmail,"user_password":getPassword,"device_token":"nodevicetoken"]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/login/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
            
        if self.getAddUserModel.status != "error"
        {
            if let data = self.getAddUserModel.ratingDetails
            {
                self.getAddUserRatingDetail = data
                APPDELEGATE.getAddUserModel = self.getAddUserModel
                APPDELEGATE.getAddUserRatingDetail = self.getAddUserRatingDetail
                defaultValues.setValue(self.tfPassword.text ?? "", forKey: "Password")
                defaultValues.setValue(self.getAddUserModel.userId, forKey: "UserID")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userName ?? "", forKey: "userName")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userProfilePhoto ?? "", forKey: "profile")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.addedDate ?? "", forKey: "addedDate")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.ratingCount ?? "", forKey: "ratingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followingCount ?? "", forKey: "followingCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.followerCount ?? "", forKey: "followerCount")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userEmail ?? "", forKey: "Email")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.city ?? "", forKey: "City")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAboutMe ?? "", forKey: "AboutMe")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userAddress ?? "", forKey: "Address")
                defaultValues.setValue(APPDELEGATE.getAddUserModel.userPhone ?? "", forKey: "Phone")
                defaultValues.synchronize()
                self.NotificationRegisterApi()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil, userInfo: nil)
            }
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddUserModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    
    func NotificationRegisterApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let deviceToken = defaultValues.value(forKey: "DeviceID") ?? ""
        let params: [String: Any] = ["device_token":deviceToken,"user_id":userId,"platform_name":"ios"]
        objHudHide()
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/notis/register/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

        if self.getForgotModel.status == "success"
        {
            defaultValues.setValue("Push", forKey: "PushNoti")
            defaultValues.synchronize()
            //self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }

       }
            self.objHudHide()
      }

    }
    
    func getNotificationCountApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let deviceToken = defaultValues.value(forKey: "DeviceID") ?? ""
        let parametersList:[String : Any] = ["user_id":userId,
                                             "device_token":deviceToken
        
          ]
     //   objHudShow()
      Alamofire.request(BaseViewController.API_URL+"rest/users/unread_count/api_key/teampsisthebest", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
       // self.objHudHide();
        print("Got an array with \(response) objects")
            switch response.result {
          
            case .success (let value):
                
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                if let jsonDict : NSDictionary = response.result.value as? NSDictionary
                   {
                     let notificationCount =  "\(jsonDict["blog_noti_unread_count"] ?? "")"
                     let buyerCount =  Int("\(jsonDict["buyer_unread_count"] ?? "")") ?? 0
                     let sellerCount =  Int("\(jsonDict["seller_unread_count"] ?? "")") ?? 0
                     let totalCount = buyerCount + sellerCount
                    if notificationCount != "0" && notificationCount != ""
                    {
                        self.lblNotificationCount.isHidden = false
                        self.lblNotificationCount.text = notificationCount
                    }
                    else
                    {
                        self.lblNotificationCount.isHidden = true
                    }
                 
                    defaultValues.setValue(notificationCount, forKey: "PushNotiCount")
                    defaultValues.synchronize()
                    if let tabItems = self.tabBarController?.tabBar.items {
                           // In this case we want to modify the badge number of the third tab:
                           
                           let tabItem = tabItems[3]
                           
                           if totalCount != 0
                           {
                               tabItem.badgeValue = "\(totalCount)"
                           }
                    else
                    {
                      tabItem.badgeValue = nil
                    }
                           
          
                }
                   }
                }

                
               
             

            break

            case .failure:
         //   self.objHudHide();
            // self.refreshControl.endRefreshing()

           // self.blurEffect.isHidden = true

            //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

            break
            }
          }
 }
}
