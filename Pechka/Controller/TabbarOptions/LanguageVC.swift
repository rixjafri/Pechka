//
//  LanguageVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit

class LanguageVC: BaseViewController,UITableViewDelegate,UITableViewDataSource{

    //MARK:- IBOutlets
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var constWidthViewBgSideMenu: NSLayoutConstraint!
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var viewBgSideMenu: UIView!
    @IBOutlet weak var tbleViewSideMenu: UITableView!
    @IBOutlet weak var heightConstTbleview: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var arrLanguageSelection = NSMutableArray()
    var arrLang = ["English","Russian","Uzbek"]
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
        btnContinue.isHidden = true
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
        arrLanguageSelection.removeAllObjects()
        for i in 0..<arrLang.count
        {
          self.arrLanguageSelection.insert("0", at: i)
        }
        for i in 0..<self.arrLang.count
         {
            let lang = "\(defaultValues.value(forKey: "language") ?? "")"
             if lang == "en"
             {
                if self.arrLang[i] == "English"
                {
                    self.arrLanguageSelection[i] = "1"
                }
               
             }
             else if lang == "ru"
             {
                if self.arrLang[i] == "Russian"
                {
                    self.arrLanguageSelection[i] = "1"
                }
             }
             else if lang == "uz"
             {
                if self.arrLang[i] == "Uzbek"
                {
                    self.arrLanguageSelection[i] = "1"
                }
             }
            else
            {
               self.arrLanguageSelection[i] = "0"
            }
         }
         
         tbleView.reloadData()
        tbleViewSideMenu.reloadData()
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
       
        viewBgSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewBgSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewBgSideMenu.layer.shadowOpacity = 0.7
        viewBgSideMenu.layer.shadowRadius = 1.5
        tbleView.delegate = self
        tbleView.dataSource = self
        tbleViewSideMenu.delegate = self
        tbleViewSideMenu.dataSource = self
        tbleViewSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleViewSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleViewSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleViewSideMenu.tableFooterView = customView
        tbleViewSideMenu.tableFooterView?.isHidden = false
        btnContinue.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnContinue.layer.cornerRadius = 15
        btnContinue.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        heightConstTbleview.constant = CGFloat(arrLang.count * 40 + 10)
      
    }
    @objc func languageWillChange(notification:NSNotification)
    {
        let targetLang = notification.object as! String
        UserDefaults.standard.set(targetLang, forKey: "selectedLanguage")
        Bundle.setLanguage(targetLang)
        NotificationCenter.default.post(name: Notification.Name("LANGUAGE_DID_CHANGE"), object: targetLang)
    }

    //MARK:- IBActions
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        btnHideSideMenu.isUserInteractionEnabled = true
        constWidthViewBgSideMenu.constant = self.view.frame.width-100
    }
    
    @IBAction func action_continueBtnTapped(_ sender: UIButton)
    {
        
    }
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthViewBgSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
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
            return arrLang.count
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
        if tableView == tbleViewSideMenu
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
        else
        {
            let cell = tbleView.dequeueReusableCell(withIdentifier: "LanguageTbleViewCell") as! LanguageTbleViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.lblTitle.text = arrLang[indexPath.row]
            cell.btnSelectUnSelect.tag = indexPath.row
            if self.arrLanguageSelection[indexPath.row] as! String == "0"
              {
                cell.lblTitle.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                cell.imgCheck.isHidden = true
              }
              else
              {
                cell.lblTitle.textColor = #colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1)
                cell.imgCheck.isHidden = false
              }
            return cell
        }
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      if tableView == tbleViewSideMenu
      {
        btnHideSideMenu.isUserInteractionEnabled = false
        constWidthViewBgSideMenu.constant = 0
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
    
    //MARK:- Cell Method
    @IBAction func action_languageBtnTapped(_ sender: UIButton)
    {
        for i in 0..<self.arrLanguageSelection.count
         {
             if i == sender.tag
               {
                   self.arrLanguageSelection[sender.tag] = "1"
                if arrLang[sender.tag] == "English"
                {
                    
                     UserDefaults.standard.set("en", forKey: "language")
                               UserDefaults.standard.synchronize()
                }
                else if arrLang[sender.tag] == "Russian"
                {
                    
                     UserDefaults.standard.set("ru", forKey: "language")
                               UserDefaults.standard.synchronize()
                }
                else
                {
                    
                     UserDefaults.standard.set("uz", forKey: "language")
                               UserDefaults.standard.synchronize()
                }
                
                
                setScreenViewAccToLanguage()
               }
               else
               {
                   self.arrLanguageSelection[i] = "0"
               }
         }
         
         tbleView.reloadData()
    }
    
    func setScreenViewAccToLanguage()
    {
        let targetLang = UserDefaults.standard.object(forKey: "language") as? String
        
        if targetLang != nil
        {
            Bundle.setLanguage(targetLang)
        }
        else
        {
            Bundle.setLanguage("en")
        }
     
    
        let delegate = UIApplication.shared.delegate as? AppDelegate

        delegate?.userTabbar()
     
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshScreen"), object: nil)
     
    }
     
}
