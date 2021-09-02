//
//  IntrestVC.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit
import Alamofire

class IntrestVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnHideSideMenu: UIButton!
    
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var tbleSideMenu: UITableView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var widthConstViewSideMenu: NSLayoutConstraint!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.view.addGestureRecognizer(tap)
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
        setInitials()
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
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
        }
        else
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
        }
        tbleSideMenu.reloadData()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        widthConstViewSideMenu.constant = 0
    }
   //MARK:- Custom Methods
   func setInitials()
   {
    
    viewSideMenu.layer.shadowColor = UIColor.black.cgColor
    viewSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
    viewSideMenu.layer.shadowOpacity = 0.7
    viewSideMenu.layer.shadowRadius = 1.5
    tbleSideMenu.delegate = self
    tbleSideMenu.dataSource = self
    tbleSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
    tbleSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleSideMenu.frame.width, height: 80))
    customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    tbleSideMenu.tableFooterView = customView
    tbleSideMenu.tableFooterView?.isHidden = false
    collectionView.delegate = self
    collectionView.dataSource = self
   }
    
   //MARK:- IBActions
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        widthConstViewSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        widthConstViewSideMenu.constant = self.view.frame.width-100
        btnHideSideMenu.isUserInteractionEnabled = true
    }
    
    @IBAction func action_bellBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
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
        btnHideSideMenu.isUserInteractionEnabled = false
        widthConstViewSideMenu.constant = 0
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
    
   //MARK:- Collection View data source and delegate methods
   func numberOfSections(in collectionView: UICollectionView) -> Int
   {
       return 1
   }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
   {
    return APPDELEGATE.getCategory.count
   }


   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
   {
   
    let cell:IntrestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntrestCollectionViewCell", for: indexPath) as! IntrestCollectionViewCell
    cell.viewBg.layer.cornerRadius = 5
    if let tempDic1 : Dictionary = APPDELEGATE.getCategory[indexPath.row] as? Dictionary<String,Any>
     {
        
            if let getCatName : String = tempDic1["cat_name"] as? String
            {
                cell.lblTitle.text = getCatName
            }
        
        
        if let getSliderName : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
        {
            if let getSliderNameImg : String = getSliderName["img_path"] as? String
            {
                var imageUrl =  BaseViewController.IMG_URL
                    imageUrl.append(getSliderNameImg)
                
                cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                cell.imgView.layer.cornerRadius = 5
                cell.imgView.layer.masksToBounds = true
            }
        }
        
        if let getSliderName : Dictionary = tempDic1["default_icon"] as? Dictionary<String,Any>
        {
            if let getSliderNameImg : String = getSliderName["img_path"] as? String
            {
                var imageUrl =  BaseViewController.IMG_URL
                    imageUrl.append(getSliderNameImg)
                
                cell.imgSub.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                cell.imgSub.layer.masksToBounds = true
            }
        }
    }
    return cell
  
   }



    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {

    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        let yourWidth = collectionView.frame.width/3
       // let yourHeight = yourWidth

     return  CGSize(width: yourWidth, height:yourWidth)
     
   
   }

    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    {
      return 100
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
    let objRef:BrowesCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowesCategoryVC") as! BrowesCategoryVC
    if let tempDic1 : Dictionary = APPDELEGATE.getCategory[indexPath.row] as? Dictionary<String,Any>
     {
        if let getId : String = tempDic1["cat_id"] as? String
        {
            objRef.catId = getId
            if let getCatName : String = tempDic1["cat_name"] as? String
            {
                objRef.catName = getCatName
            }
           
        }
    }
   
    self.navigationController?.pushViewController(objRef, animated: true)
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
