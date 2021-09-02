//
//  RecentProductsItemsVC.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit
import ObjectMapper
import Alamofire

class RecentProductsItemsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlets
    @IBOutlet weak var btnTitle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var tbleViewSideMenu: UITableView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnMapFilter: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var screenCheck = ""
    var searchDict : [String: Any] = [:]
    var getForgotModel:ForgotModel!
    var titleName = ""
    var CatId = ""
    var CatName = ""
    var subCatId = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
        
        if screenCheck == titleName
        {
            btnBack.setImage(UIImage(named: "menu"), for: .normal)
        }
        else
        {
            btnBack.setImage(UIImage(named: "back"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
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
        if SEARCH_CATEGORY.count>0  {
            
            btnCategory.setTitle(SEARCH_CATEGORY, for: .normal)

        }
        else if titleName == CatName
        {
            btnCategory.setTitle(CatName, for: .normal)

        }
        else
        {
            btnCategory.setTitle(NSLocalizedString("Category", comment: ""), for: .normal)
        }
        
        if screenCheck == titleName
        {
            btnBack.setImage(UIImage(named: "menu"), for: .normal)
        }
        else
        {
            btnBack.setImage(UIImage(named: "back"), for: .normal)
        }
       
        collectionView.delegate = self
        collectionView.dataSource = self
        setInitials()
        if screenCheck == "search"
        {
            btnCategory.setTitle(SEARCH_CATEGORY, for: .normal)
            searchAPi()
            clearSearchData()
        }
        else if screenCheck == CatName
        {
            searchDict = ["searchterm":titleName ,"cat_id":"","sub_cat_id":"","order_type":"","order_by":"","item_type_id":"","item_price_type_id":"","condition_of_item_id":"","deal_option_id":"","max_price": "" ,"min_price": "","login_user_id":defaultValues.value(forKey: "UserID") as? String ?? ""]
            searchAPi()
        }
        else if CatName == titleName
        {
            let subCat = "\(defaultValues.value(forKey: "subCategory") ?? "")"
            if subCat == "subCategory"
            {
                setDropDownData()
                defaultValues.setValue(nil, forKey: "subCategory")
                defaultValues.synchronize()
            }
            else
            {
                searchDict = ["searchterm":"" ,"cat_id":CatId,"sub_cat_id":subCatId,"order_type":"","order_by":"","item_type_id":"","item_price_type_id":"","condition_of_item_id":"","deal_option_id":"","max_price": "" ,"min_price": "","login_user_id":defaultValues.value(forKey: "UserID") as? String ?? ""]
                searchAPi()
            }
         
        }
        else
        {
            setDropDownData()
        }
        
        let titleScreen =  "\(defaultValues.value(forKey: "TypeOfScreen") ?? "")"
        if titleScreen != ""
        {
            titleName = titleScreen
            btnTitle.setTitle(NSLocalizedString(titleScreen, comment: ""), for: .normal)
        }
        else
        {
            btnTitle.setTitle(NSLocalizedString(titleName, comment: ""), for: .normal)
        }
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
        let titleScreen =  "\(defaultValues.value(forKey: "TypeOfScreen") ?? "")"
        if titleScreen != ""
        {
            btnTitle.setTitle(titleScreen, for: .normal)
        }
        else
        {
            btnTitle.setTitle(titleName, for: .normal)
        }
      
        viewCategory.layer.cornerRadius = 5
        viewCategory.layer.borderWidth = 1
        viewCategory.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewSideMenu.layer.shadowOpacity = 0.7
        viewSideMenu.layer.shadowRadius = 1.5
        tbleViewSideMenu.delegate = self
        tbleViewSideMenu.dataSource = self
        tbleViewSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleViewSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleViewSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleViewSideMenu.tableFooterView = customView
        tbleViewSideMenu.tableFooterView?.isHidden = false
       
    }
    
     func setDropDownData()
     {
         if OPTION_TYPE == 1 && SEARCH_CATEGORY.count>0 || OPTION_TYPE == 2 && SEARCH_SUB_CATEGORY.count>0
         {
             btnCategory.setTitle(SEARCH_CATEGORY, for: .normal)
             searchDict = ["searchterm":"" ,"cat_id":SEARCH_CATEGORY_ID,"sub_cat_id":SEARCH_SUB_CATEGORY_ID,"order_type":"","order_by":"","item_type_id":"","item_price_type_id":"","condition_of_item_id":SEARCH_ITEM_CONDITION_ID,"deal_option_id":SEARCH_ITEM_DEAL_ID,"max_price": "" ,"min_price": "","login_user_id":defaultValues.value(forKey: "UserID") as? String ?? ""]
             searchAPi()
         }
     }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        defaultValues.set(nil, forKey: "TypeOfScreen")
        defaultValues.synchronize()
        if sender.currentImage == UIImage(named: "back")
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            btnHideSideMenu.isUserInteractionEnabled = true
            constWidthSideMenu.constant = self.view.frame.width-100
        }
       
    }
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton)
    {
        constWidthSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        btnHideSideMenu.isUserInteractionEnabled = true
        constWidthSideMenu.constant = self.view.frame.width-100
    }
    
    @IBAction func action_bellBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_mapFilterBtnTapped(_ sender: UIButton)
    {
        let objRef:MapFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "MapFilterVC") as! MapFilterVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_filterBtnTapped(_ sender: UIButton)
    {
        let objRef:FilterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_categoryBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 1
        objRef.checkScreen = "Recent"
        objRef.titleName = titleName
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_itemBtnTapped(_ sender: UIButton)
    {
        if screenCheck == "popular" || screenCheck == "Popular"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getAllPopularItems[sender.tag] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if screenCheck == "home" || screenCheck == "Latest"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getAllRecentItems[sender.tag] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
      
    }
    
    @IBAction func action_likeHeartBtnTapped(_ sender: UIButton)
    {
//        if sender.currentImage == UIImage(named: "grayHeart")
//        {
//            sender.setImage(UIImage(named: "redHeart"), for: .normal)
//        }
//        else
//        {
//            sender.setImage(UIImage(named: "grayHeart"), for: .normal)
//        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
    
    //MARK:- Collection View data source and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let titleScreen =  "\(defaultValues.value(forKey: "TypeOfScreen") ?? "")"
        if titleScreen != ""
        {
            return APPDELEGATE.getPopularLatestList.count
        }
        else
        {
            if screenCheck == "popular"
            {
             return APPDELEGATE.getAllPopularItems.count
            }
            else if screenCheck == "home"
            {
             return APPDELEGATE.getAllRecentItems.count
            }
            else if screenCheck == "Latest Items" || screenCheck == "Popular Items"
            {
                return APPDELEGATE.getPopularLatestList.count
            }
            else if screenCheck == titleName
            {
                return APPDELEGATE.getPopularLatestList.count
            }
            else
            {
                return APPDELEGATE.getPopularLatestList.count
            }
        }
      
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
     let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
        cell.btnLike.tag = indexPath.row
        cell.btnItemTap.tag = indexPath.row
        cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
        let titleScreen =  "\(defaultValues.value(forKey: "TypeOfScreen") ?? "")"
        if titleScreen != ""
        {
       
        if let tempDic1 : Dictionary =  APPDELEGATE.getPopularLatestList[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date_str"] as? String
            {
                cell.lblTime.text = getCatName
            }
            if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
             {
                if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                {
                    cell.lblSubCat.text = getCatpriceCurrency
                }
            }
            if let getCatprice : String = tempDic1["price"] as? String
            {
                if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                 {
                    if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                    {
                        if let tempDicItemPriceType : Dictionary = tempDic1["item_price_type"] as? Dictionary<String,Any>
                         {
                            if let getCatpriceItemPriceType : String = tempDicItemPriceType["name"] as? String
                            {
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatpriceItemPriceType))"
                            }
                        }
                        else
                        {
                            var totalPrice = Double()
                            totalPrice = Double(getCatprice) ?? 0.0
                            cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice))"
                        }
                        
                    }
                 }
             
            }
            if let getCattitle: String = tempDic1["title"] as? String
            {
                cell.lblItemName.text = getCattitle
            }
            if let soldOut:String = tempDic1["is_sold_out"] as? String
            {
             if soldOut == "0"
             {
                cell.viewSold.isHidden = true
                cell.lblSold.text = ""
             }
             else
             {
                cell.viewSold.isHidden = false
                cell.lblSold.text = "Sold"
             }
            }
            if let title:String = tempDic1["favourite_count"] as? String
            {
                cell.btnLike.setTitle(title, for: .normal)
            }
            if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
             {
                    if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                    {
                        cell.lblAddress.text = getSliderNameLoc
                    }
            }
            if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
             {
                    if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                    {
                        var imageUrl =  BaseViewController.IMG_URL
                            imageUrl.append(getSliderNameImg1)
                        
                        cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                        cell.imgProduct.layer.masksToBounds = true
                       
                    }
                   else
                    {
                        cell.imgProduct.image = UIImage(named: "userIcon")
                    }
            }
            if let tempDicUser : Dictionary = tempDic1["user"] as? Dictionary<String,Any>
            {
               if let getSliderNameImage : String = tempDicUser["user_profile_photo"] as? String
               {
                   var imageUrls =  BaseViewController.IMG_URL
                       imageUrls.append(getSliderNameImage)
                   
                   cell.imgUser.sd_setImage(with: URL(string: imageUrls), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                   cell.imgUser.layer.masksToBounds = true

               }
              else
               {
                   cell.imgUser.image = #imageLiteral(resourceName: "userIcon")
               }
           
               
               if let getCatName : String = tempDicUser["user_name"] as? String
               {
                   cell.lblName.text = getCatName
               }
           }
            }
        }
        else
        {
            if screenCheck == "popular"
            {
            if let tempDic1 : Dictionary = APPDELEGATE.getAllPopularItems[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
                 {
                    if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                    {
                        cell.lblSubCat.text = getCatpriceCurrency
                    }
                }
                if let getCatprice : String = tempDic1["price"] as? String
                {
                    if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                     {
                        if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                        {
                            if let tempDicItemPriceType : Dictionary = tempDic1["item_price_type"] as? Dictionary<String,Any>
                             {
                                if let getCatpriceItemPriceType : String = tempDicItemPriceType["name"] as? String
                                {
                                    var totalPrice = Double()
                                    totalPrice = Double(getCatprice) ?? 0.0
                                    cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatpriceItemPriceType))"
                                }
                            }
                            else
                            {
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice))"
                            }
                            
                        }
                     }
                 
                }
                if let soldOut:String = tempDic1["is_sold_out"] as? String
                {
                 if soldOut == "0"
                 {
                    cell.viewSold.isHidden = true
                    cell.lblSold.text = ""
                 }
                 else
                 {
                    cell.viewSold.isHidden = false
                    cell.lblSold.text = "Sold"
                 }
                }
                if let getCattitle: String = tempDic1["title"] as? String
                {
                    cell.lblItemName.text = getCattitle
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
                }
                if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                        {
                            cell.lblAddress.text = getSliderNameLoc
                        }
                }
                if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                            cell.imgProduct.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgProduct.image = UIImage(named: "userIcon")
                        }
                }
                if let tempDicUser : Dictionary = tempDic1["user"] as? Dictionary<String,Any>
                {
                   if let getSliderNameImage : String = tempDicUser["user_profile_photo"] as? String
                   {
                       var imageUrls =  BaseViewController.IMG_URL
                           imageUrls.append(getSliderNameImage)
                       
                       cell.imgUser.sd_setImage(with: URL(string: imageUrls), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                       cell.imgUser.layer.masksToBounds = true

                   }
                  else
                   {
                       cell.imgUser.image = #imageLiteral(resourceName: "userIcon")
                   }
               
                   
                   if let getCatName : String = tempDicUser["user_name"] as? String
                   {
                       cell.lblName.text = getCatName
                   }
               }
                }
            }
            else if  screenCheck == "home"
            {
                
            if let tempDic1 : Dictionary = APPDELEGATE.getAllRecentItems[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
                 {
                    if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                    {
                        cell.lblSubCat.text = getCatpriceCurrency
                    }
                }
                if let getCatprice : String = tempDic1["price"] as? String
                {
                    if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                     {
                        if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                        {
                            if let tempDicItemPriceType : Dictionary = tempDic1["item_price_type"] as? Dictionary<String,Any>
                             {
                                if let getCatpriceItemPriceType : String = tempDicItemPriceType["name"] as? String
                                {
                                    var totalPrice = Double()
                                    totalPrice = Double(getCatprice) ?? 0.0
                                    cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatpriceItemPriceType))"
                                }
                            }
                            else
                            {
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice))"
                            }
                            
                        }
                     }
                 
                }
                if let soldOut:String = tempDic1["is_sold_out"] as? String
                {
                 if soldOut == "0"
                 {
                    cell.viewSold.isHidden = true
                    cell.lblSold.text = ""
                 }
                 else
                 {
                    cell.viewSold.isHidden = false
                    cell.lblSold.text = "Sold"
                 }
                }
                if let getCattitle: String = tempDic1["title"] as? String
                {
                    cell.lblItemName.text = getCattitle
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
                }
                if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                        {
                            cell.lblAddress.text = getSliderNameLoc
                        }
                }
                if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                            cell.imgProduct.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgProduct.image = UIImage(named: "userIcon")
                        }
                }
                if let tempDicUser : Dictionary = tempDic1["user"] as? Dictionary<String,Any>
                {
                   if let getSliderNameImage : String = tempDicUser["user_profile_photo"] as? String
                   {
                       var imageUrls =  BaseViewController.IMG_URL
                           imageUrls.append(getSliderNameImage)
                       
                       cell.imgUser.sd_setImage(with: URL(string: imageUrls), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                       cell.imgUser.layer.masksToBounds = true

                   }
                  else
                   {
                       cell.imgUser.image = #imageLiteral(resourceName: "userIcon")
                   }
               
                   
                   if let getCatName : String = tempDicUser["user_name"] as? String
                   {
                       cell.lblName.text = getCatName
                   }
               }
                }
            }
            else if screenCheck == "Latest Items" || screenCheck == "Popular Items"
            {
                
            if let tempDic1 : Dictionary = APPDELEGATE.getPopularLatestList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
                 {
                    if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                    {
                        cell.lblSubCat.text = getCatpriceCurrency
                    }
                }
                if let getCatprice : String = tempDic1["price"] as? String
                {
                    if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                     {
                        if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                        {
                            if let tempDicItemPriceType : Dictionary = tempDic1["item_price_type"] as? Dictionary<String,Any>
                             {
                                if let getCatpriceItemPriceType : String = tempDicItemPriceType["name"] as? String
                                {
                                    var totalPrice = Double()
                                    totalPrice = Double(getCatprice) ?? 0.0
                                    cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatpriceItemPriceType))"
                                }
                            }
                            else
                            {
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice))"
                            }
                            
                        }
                     }
                 
                }
                if let soldOut:String = tempDic1["is_sold_out"] as? String
                {
                 if soldOut == "0"
                 {
                    cell.viewSold.isHidden = true
                    cell.lblSold.text = ""
                 }
                 else
                 {
                    cell.viewSold.isHidden = false
                    cell.lblSold.text = "Sold"
                 }
                }
                if let getCattitle: String = tempDic1["title"] as? String
                {
                    cell.lblItemName.text = getCattitle
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
                }
                if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                        {
                            cell.lblAddress.text = getSliderNameLoc
                        }
                }
                if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                            cell.imgProduct.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgProduct.image = UIImage(named: "userIcon")
                        }
                }
                if let tempDicUser : Dictionary = tempDic1["user"] as? Dictionary<String,Any>
                {
                   if let getSliderNameImage : String = tempDicUser["user_profile_photo"] as? String
                   {
                       var imageUrls =  BaseViewController.IMG_URL
                           imageUrls.append(getSliderNameImage)
                       
                       cell.imgUser.sd_setImage(with: URL(string: imageUrls), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                       cell.imgUser.layer.masksToBounds = true

                   }
                  else
                   {
                       cell.imgUser.image = #imageLiteral(resourceName: "userIcon")
                   }
               
                   
                   if let getCatName : String = tempDicUser["user_name"] as? String
                   {
                       cell.lblName.text = getCatName
                   }
               }
                }
            }
            else
            {
                
            if let tempDic1 : Dictionary = APPDELEGATE.getPopularLatestList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
                 {
                    if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                    {
                        cell.lblSubCat.text = getCatpriceCurrency
                    }
                }
                if let getCatprice : String = tempDic1["price"] as? String
                {
                    if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                     {
                        if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                        {
                            if let tempDicItemPriceType : Dictionary = tempDic1["item_price_type"] as? Dictionary<String,Any>
                             {
                                if let getCatpriceItemPriceType : String = tempDicItemPriceType["name"] as? String
                                {
                                    var totalPrice = Double()
                                    totalPrice = Double(getCatprice) ?? 0.0
                                    cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatpriceItemPriceType))"
                                }
                            }
                            else
                            {
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice))"
                            }
                            
                        }
                     }
                 
                }
                if let soldOut:String = tempDic1["is_sold_out"] as? String
                {
                 if soldOut == "0"
                 {
                    cell.viewSold.isHidden = true
                    cell.lblSold.text = ""
                 }
                 else
                 {
                    cell.viewSold.isHidden = false
                    cell.lblSold.text = "Sold"
                 }
                }
                if let getCattitle: String = tempDic1["title"] as? String
                {
                    cell.lblItemName.text = getCattitle
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
                }
                if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                        {
                            cell.lblAddress.text = getSliderNameLoc
                        }
                }
                if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                            cell.imgProduct.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgProduct.image = UIImage(named: "userIcon")
                        }
                }
                if let tempDicUser : Dictionary = tempDic1["user"] as? Dictionary<String,Any>
                {
                   if let getSliderNameImage : String = tempDicUser["user_profile_photo"] as? String
                   {
                       var imageUrls =  BaseViewController.IMG_URL
                           imageUrls.append(getSliderNameImage)
                       
                       cell.imgUser.sd_setImage(with: URL(string: imageUrls), placeholderImage: #imageLiteral(resourceName: "userIcon"))
                       cell.imgUser.layer.masksToBounds = true

                   }
                  else
                   {
                       cell.imgUser.image = #imageLiteral(resourceName: "userIcon")
                   }
               
                   
                   if let getCatName : String = tempDicUser["user_name"] as? String
                   {
                       cell.lblName.text = getCatName
                   }
               }
                }
            }
        }

         return cell
   
    }


     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
     {

     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let yourWidth = collectionView.frame.width/2
        // let yourHeight = yourWidth

      return  CGSize(width: yourWidth, height:370)
      
    
    }

     func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
     {
       return 370
     }
     func scrollCollectionView(indexpath:IndexPath,collectionView:UICollectionView)
       {
        // collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
         //collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .left)
        // collectionView.scrollToItem(at: indexpath, at:.left, animated: true)

     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if screenCheck == "popular"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getAllPopularItems[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if screenCheck == "Latest Items" || screenCheck == "Popular Items"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getPopularLatestList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if screenCheck == "home"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getAllRecentItems[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getPopularLatestList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
      
    }

//    func searchAPi()
//           {
//
//               WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/limit/30/offset/0", parameters: searchDict) { (response, error) in
//                   if error == nil{
//
//              self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)
//
//              if self.getForgotModel.status != "error"
//              {
//           //       if let data = self.getMessagesModel.ratingDetails
//           //       {
//           //
//           //       }
//
//              }else{
//                self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
//              }
//
//               }
//
//           }
//    }
    
    func searchAPi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

        
        objHudShow()
      print(searchDict)
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/limit/30/offset/0", method: .post , parameters: searchDict,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
                print(response)
                APPDELEGATE.getPopularLatestList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                let resultsArray = value as! [AnyObject]
               
                for i in 0..<resultsArray.count
                {
                 APPDELEGATE.getPopularLatestList.insert(resultsArray[i], at:  APPDELEGATE.getPopularLatestList.count)
                }
                    self.lblMessage.text = ""
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.lblMessage.text = "No data found"
                }

                self.collectionView.reloadData()
               print("Recent Items:\(APPDELEGATE.getPopularLatestList)")
               

            break

            case .failure:
            self.objHudHide();
            // self.refreshControl.endRefreshing()

           // self.blurEffect.isHidden = true

            self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)

            break
            }
          }
 }
}
