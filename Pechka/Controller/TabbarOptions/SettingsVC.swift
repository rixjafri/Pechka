//
//  SettingsVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import ObjectMapper

class SettingsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlets
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var tbleSideMenu: UITableView!
    @IBOutlet weak var viewBgSideMenu: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var btnAppInfo: UIButton!
    @IBOutlet weak var lblCacheValue: UILabel!
    @IBOutlet weak var btnClearNow: UIButton!
    @IBOutlet weak var btnCustomCamera: UIButton!
    @IBOutlet weak var btnDefaultCamera: UIButton!
    @IBOutlet weak var btnNotificationOnOff: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var getForgotModel:ForgotModel!
    var fileSize:Int = 0;
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewAlpha.addGestureRecognizer(tap)
        self.lblCacheValue.text = "0 MB"
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
         
        }){(finished) -> Void in
            
            DispatchQueue.global().async {
                self.fileSize  = self.fileSizeOfCache()
                                 // Get data asynchronous
                DispatchQueue.main.async {
                                         // Modify the main thread UI
                                         self.lblCacheValue.text = String(self.fileSize)+" MB"
                }
            }
        }
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
        btnSideMenu.setImage(UIImage(named: "back"), for: .normal)
        tbleSideMenu.reloadData()
    }
   
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(false)
         UIView.animate(withDuration: 0.3, animations: {() -> Void in
          
         }){(finished) -> Void in
             
             DispatchQueue.global().async {
                 self.fileSize  = self.fileSizeOfCache()
                                  // Get data asynchronous
                 DispatchQueue.main.async {
                                          // Modify the main thread UI
                                          self.lblCacheValue.text = String(self.fileSize)+" MB"
                 }
             }
         }
  
       

         
     }
    func clearCaches(){
           do {
               try deleteLibraryFolderContents(folder: "Caches")
               //print("clear done")
           } catch {
               //print("clear Caches Error")
           }
       }
    private func deleteLibraryFolderContents(folder: String) throws {
            let manager = FileManager.default
            let library = manager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask)[0]
            let dir = library.appendingPathComponent(folder)
            let contents = try manager.contentsOfDirectory(atPath: dir.path)
            for content in contents {
                             //If it is a snapshot, continue
                if(content == "Snapshots"){continue;}
                do {
                    try manager.removeItem(at: dir.appendingPathComponent(content))
                    //print("remove cache success:"+content)
                    self.lblCacheValue.text = "0 MB"
                } catch where ((error as NSError).userInfo[NSUnderlyingErrorKey] as? NSError)?.code == Int(EPERM) {
                    //print("remove cache error:"+content)
                    // "EPERM: operation is not permitted". We ignore this.
                    #if DEBUG
                        //print("Couldn't delete some library contents.")
                    #endif
                }
            }
        }

    func fileSizeOfCache()-> Int {
           
                    // Remove the cache folder directory cache files are in this directory
           let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
                    // Cache directory path
           //print(cachePath)
           
                    // Remove all file arrays under the folder
           let fileArr = FileManager.default.subpaths(atPath: cachePath!)
           
                    // Quickly enumerate all file names Calculate file size
           var size = 0
           for file in fileArr! {
               
                            // splicing the file name into the path
               let path = cachePath?.appending("/\(file)")
                            // remove the file attribute
               let floder = try! FileManager.default.attributesOfItem(atPath: path!)
                            // Use the tuple to remove the file size attribute
               for (abc, bcd) in floder {
                                    // accumulate file size
                   if abc == FileAttributeKey.size {
                       size += (bcd as AnyObject).integerValue
                   }
               }
           }
           
           let mm = size / 1024 / 1024
           
           return mm
       }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        viewAlpha.isHidden = true
    }
    
   
    //MARK:- Custom Methods
    func setInitials()
    {
       
        viewBgSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewBgSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewBgSideMenu.layer.shadowOpacity = 0.7
        viewBgSideMenu.layer.shadowRadius = 1.5
     
        tbleSideMenu.delegate = self
        tbleSideMenu.dataSource = self
        tbleSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleSideMenu.tableFooterView = customView
        tbleSideMenu.tableFooterView?.isHidden = false
        btnSubmit.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnSubmit.layer.cornerRadius = 15
        btnSubmit.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        let PushNoti = "\(defaultValues.value(forKey: "PushNoti") ?? "")"
        if PushNoti != ""
        {
            btnNotificationOnOff.setImage(UIImage(named: "On"), for: .normal)
        }
        else
        {
            btnNotificationOnOff.setImage(UIImage(named: "Off"), for: .normal)
        }
       
        btnDefaultCamera.tag = 101
        btnCustomCamera.tag = 102
        btnYes.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnYes.layer.cornerRadius = 15
        btnYes.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        btnNo.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        btnNo.layer.cornerRadius = 15
        btnNo.layer.borderWidth = 1
        btnNo.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        btnNo.tag = 111
        btnYes.tag = 112
        viewCustom.layer.cornerRadius = 10
        
    }
   //MARK:- IBActions
    @IBAction func action_sidemenuBtnTapped(_ sender: UIButton)
    {
        if sender.currentImage == UIImage(named: "back")
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
            btnHideSideMenu.isUserInteractionEnabled = true
            constWidthSideMenu.constant = self.view.frame.width-100
        }
    }
    
    @IBAction func action_caneraTypeBtnTapped(_ sender: UIButton)
    {
        if sender.tag == 101
        {
            btnDefaultCamera.setImage(UIImage(named: "radio"), for: .normal)
            btnDefaultCamera.setTitleColor(BaseViewController.appColor, for: .normal)
            btnCustomCamera.setImage(UIImage(named: "radioUnSelect"), for: .normal)
            btnCustomCamera.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        }
        else
        {
            btnCustomCamera.setImage(UIImage(named: "radio"), for: .normal)
            btnCustomCamera.setTitleColor(BaseViewController.appColor, for: .normal)
            btnDefaultCamera.setImage(UIImage(named: "radioUnSelect"), for: .normal)
            btnDefaultCamera.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func action_submitBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_appInfoBtnTapped(_ sender: UIButton)
    {
        let objRef:AppInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoVC") as! AppInfoVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    @IBAction func action_yesNoBtnTapped(_ sender: UIButton)
    {
        if sender.tag == 112
        {
            clearCaches()
        }
        self.viewAlpha.isHidden = true
    }
    
    @IBAction func action_notificationOnOffBtnTapped(_ sender: UIButton)
    {
        if sender.currentImage == UIImage(named: "On")
        {
            btnNotificationOnOff.setImage(UIImage(named: "Off"), for: .normal)
            NotificationUnRegisterApi()
        }
        else
        {
            btnNotificationOnOff.setImage(UIImage(named: "On"), for: .normal)
            NotificationRegisterApi()
           
            
        }
    }
    
    @IBAction func action_clearCacheBtnTapped(_ sender: UIButton)
    {
        self.viewAlpha.isHidden = false
    }
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    
    @IBAction func action_logoutBtnTapped(_ sender: UIButton)
    {
        let objRef:LogoutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
        objRef.modalPresentationStyle = .fullScreen
        self.present(objRef, animated: true, completion: nil)
    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
      if tableView == tbleSideMenu
      {
        return 4
      }
      else
      {
        return 1
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbleSideMenu
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
        if tableView == tbleSideMenu
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
   if tableView == tbleSideMenu
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
    if tableView == tbleSideMenu
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
                let cell = tbleSideMenu.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
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
                let cell = tbleSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuHomeNames[indexPath.row]
                cell.imgview.image = UIImage(named: homeIconscons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else if indexPath.section == 2
            {
                let cell = tbleSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuUserInfoNames[indexPath.row]
                cell.imgview.image = UIImage(named: menuUserInfoIcons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
            else
            {
                let cell = tbleSideMenu.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
                cell.lbl.text = menuAppNames[indexPath.row]
                cell.imgview.image = UIImage(named: menuAppIcons[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        
        
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      if tableView == tbleSideMenu
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
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Favourite", comment: "")
            {
                let objRef: FavouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as!  FavouritesVC
                self.navigationController?.pushViewController(objRef, animated: true)
                
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Message", comment: "")
            {
                APPDELEGATE.userTabbarCheck(value: 3)
            }
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Log out", comment: "")
            {
                let objRef:LogoutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
                objRef.modalPresentationStyle = .fullScreen
                self.present(objRef, animated: true, completion: nil)
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
      else
      {
      
      }
     }
    
    //MARK:- WebServices
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
    
    func NotificationUnRegisterApi()
    {
        var deviceID = ""
        objHudHide()
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let deviceToken = defaultValues.value(forKey: "DeviceID") ?? ""
        let params: [String: Any] = ["device_token":deviceToken,"user_id":userId,"platform_name":"ios"]

        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/notis/unregister/api_key/teampsisthebest", parameters: params) { (response, error) in

        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

        if self.getForgotModel.status == "success"
        {
           // self.navigationController?.popViewController(animated: true)
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
