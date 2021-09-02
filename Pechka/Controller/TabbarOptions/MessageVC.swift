//
//  MessageVC.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit
import Alamofire
import ObjectMapper

class MessageVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlets
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var tbleViewChat: UITableView!
    @IBOutlet weak var lblSellingLine: UILabel!
    @IBOutlet weak var lblBuyingLine: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var btnSelling: UIButton!
    @IBOutlet weak var lblSelling: UILabel!
    @IBOutlet weak var btnBuying: UIButton!
    @IBOutlet weak var lblBuyning: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var lblAllLine: UILabel!
    @IBOutlet weak var lblCountAll: UILabel!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var tbleSideMenu: UITableView!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var getMessagesModel:MessageModel!
    var chatType = "seller"
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
        setInitials()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.view.addGestureRecognizer(tap)
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
            
            tabBarController?.selectedIndex = 3
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
            getMessagesApi(return_Type: chatType)
          
            lblCountAll.isHidden = true
        }
        else
        {
            APPDELEGATE.userTabbarCheck(value: 2)
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
        }
        tbleSideMenu.reloadData()
       
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        constWidthSideMenu.constant = 0
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
       
        tbleViewChat.delegate = self
        tbleViewChat.dataSource = self
        
        lblCountAll.layer.cornerRadius = lblCountAll.frame.height/2
        lblCountAll.clipsToBounds = true
        lblSellingLine.layer.cornerRadius = 5
        lblBuyingLine.layer.cornerRadius = 5
        lblAllLine.layer.cornerRadius = 5
        lblAllLine.clipsToBounds = true
        lblBuyingLine.clipsToBounds = true
        lblSellingLine.clipsToBounds = true
        btnAll.tag = 101
        btnBuying.tag = 102
        btnSelling.tag =  103
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
        lblAll.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
        btnAll.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62), for: .normal)
        lblCountAll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
        lblSelling.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
        lblBuyning.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lblAllLine.isHidden = true
        lblBuyingLine.isHidden = false
        lblSellingLine.isHidden = true
    }
    
    //MARK:- IBActions
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton)
    {
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
    
    @IBAction func action_messageTypeBtnTapped(_ sender: UIButton)
    {
        if sender.tag == 101
        {
            lblAll.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            btnAll.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            lblCountAll.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblSelling.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblBuyning.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblAllLine.isHidden = false
            lblBuyingLine.isHidden = true
            lblSellingLine.isHidden = true
            chatType = "buyer"
        }
        else if sender.tag == 102
        {
            lblAll.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            btnAll.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62), for: .normal)
            lblCountAll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblSelling.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblBuyning.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblAllLine.isHidden = true
            lblBuyingLine.isHidden = false
            lblSellingLine.isHidden = true
            chatType = "seller"
        }
        else if sender.tag == 103
        {
            lblAll.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            btnAll.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62), for: .normal)
            lblCountAll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblSelling.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblBuyning.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
            lblAllLine.isHidden = true
            lblBuyingLine.isHidden = true
            lblSellingLine.isHidden = false
            chatType = "buyer"
        }
        getMessagesApi(return_Type: chatType)
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
            return APPDELEGATE.MessageList.count
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
        if tableView == tbleSideMenu
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
        else
        {
            let cell = tbleViewChat.dequeueReusableCell(withIdentifier: "OffersTableViewCell") as! OffersTableViewCell
           
            if chatType == "seller"
            {
                if let tempDic1 : Dictionary = APPDELEGATE.MessageList[indexPath.row] as? Dictionary<String,Any>
                 {
                    if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                     {
                    if let getCatName : String = tempDic1["added_date_str"] as? String
                    {
                        cell.lblTime.text = getCatName
                    }
                    if let getCatName : String = tempDic1["buyer_unread_count"] as? String
                    {
                        if getCatName == "0"
                        {
                            cell.lblTotalCount.isHidden = true
                        }
                        else
                        {
                            cell.lblTotalCount.isHidden = false
                            cell.lblTotalCount.text = "1"
                        }
                        
                    }
                    else
                    {
                        cell.lblTotalCount.isHidden = true
                    }
                    if let getCatprice : String = tempDicItem["price"] as? String
                    {
                        if let tempDicConItem : Dictionary = tempDicItem["condition_of_item"] as? Dictionary<String,Any>
                         {
                            if let getCatName : String = tempDicConItem["name"] as? String
                            {
                                if let tempDicItemCurrency : Dictionary = tempDicItem["item_currency"] as? Dictionary<String,Any>
                                 {
                                    if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                                    {
                                        var totalPrice = Double()
                                        totalPrice = Double(getCatprice) ?? 0.0
                                        cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                                    }
                                }
                              
                            }
                        }
                       
                    }
                  
                    if let getCattitle: String = tempDicItem["title"] as? String
                    {
                        cell.lblItemName.text = getCattitle
                    }
                   
                    if let tempDicImg : Dictionary = tempDicItem["default_photo"] as? Dictionary<String,Any>
                     {
                            if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                            {
                                var imageUrl =  BaseViewController.IMG_URL
                                    imageUrl.append(getSliderNameImg1)
                                
                                cell.imgItem.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                                cell.imgItem.layer.masksToBounds = true
                               
                            }
                           else
                            {
                                cell.imgItem.image = #imageLiteral(resourceName: "itemDefault")
                            }
                    }
                    }
                    
                    if let tempDicUser : Dictionary = tempDic1["seller"] as? Dictionary<String,Any>
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
                            cell.lblUserName.text = getCatName
                        }
                    }
                    }
            }
            else
            {
                if let tempDic1 : Dictionary = APPDELEGATE.MessageList[indexPath.row] as? Dictionary<String,Any>
                 {
                    if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                     {
                    if let getCatName : String = tempDic1["added_date_str"] as? String
                    {
                        cell.lblTime.text = getCatName
                    }
                        if let getCatName : String = tempDic1["seller_unread_count"] as? String
                        {
                            if getCatName == "0"
                            {
                                cell.lblTotalCount.isHidden = true
                            }
                            else
                            {
                                cell.lblTotalCount.isHidden = false
                                cell.lblTotalCount.text = "1"
                            }
                            
                        }
                        else
                        {
                            cell.lblTotalCount.isHidden = true
                        }
                    if let getCatprice : String = tempDicItem["price"] as? String
                    {
                        if let tempDicConItem : Dictionary = tempDicItem["condition_of_item"] as? Dictionary<String,Any>
                         {
                            if let getCatName : String = tempDicConItem["name"] as? String
                            {
                                if let tempDicItemCurrency : Dictionary = tempDicItem["item_currency"] as? Dictionary<String,Any>
                                 {
                                    if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                                    {
                                        var totalPrice = Double()
                                        totalPrice = Double(getCatprice) ?? 0.0
                                        cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                                    }
                                }
                               
                            }
                        }
                       
                    }
                  
                    if let getCattitle: String = tempDicItem["title"] as? String
                    {
                        cell.lblItemName.text = getCattitle
                    }
                   
                    if let tempDicImg : Dictionary = tempDicItem["default_photo"] as? Dictionary<String,Any>
                     {
                            if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                            {
                                var imageUrl =  BaseViewController.IMG_URL
                                    imageUrl.append(getSliderNameImg1)
                                
                                cell.imgItem.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                                cell.imgItem.layer.masksToBounds = true
                               
                            }
                           else
                            {
                                cell.imgItem.image = #imageLiteral(resourceName: "itemDefault")
                            }
                    }
                    }
                    
                    if let tempDicUser : Dictionary = tempDic1["buyer"] as? Dictionary<String,Any>
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
                            cell.lblUserName.text = getCatName
                        }
                    }
                    }
            }
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
            else if menuUserInfoNames[indexPath.row] == NSLocalizedString("Log out", comment: "")
            {
                let objRef:LogoutVC = self.storyboard?.instantiateViewController(withIdentifier: "LogoutVC") as! LogoutVC
                objRef.modalPresentationStyle = .fullScreen
                self.present(objRef, animated: true, completion: nil)
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
      else
      {
        let objRef:MakeOfferChatVC =  self.storyboard?.instantiateViewController(withIdentifier: "MakeOfferChatVC") as! MakeOfferChatVC
        objRef.typeSellerBuyer = chatType
        objRef.screenType = "Message"
        objRef.indexTag = indexPath.row
        if chatType == "seller"
        {
            if let tempDic1 : Dictionary = APPDELEGATE.MessageList[indexPath.row] as? Dictionary<String,Any>
             {
                if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                 {
                    if let getCatId : String = tempDicItem["id"] as? String
                    {
                        objRef.itemId = getCatId
                    }
                    if let tempDicUser : Dictionary = tempDicItem["user"] as? Dictionary<String,Any>
                     {
                        if let getImgUrl : String = tempDicUser["user_profile_photo"] as? String
                        {
                            objRef.imgUrl = getImgUrl
                        }
                     }
                 }
             
                    if let getUserId : String = tempDic1["seller_user_id"] as? String
                    {
                        objRef.sellerUserId = getUserId
                    }
                if let tempDicBuyer : Dictionary = tempDic1["seller"] as? Dictionary<String,Any>
                 {
                    if let getImgUrl : String = tempDicBuyer["user_profile_photo"] as? String
                    {
                        objRef.imgUrl = getImgUrl
                    }
                    if let getImgUrl : String = tempDicBuyer["user_name"] as? String
                    {
                        objRef.userName = getImgUrl
                    }
                 }
               
             }
           
            
        }
        else
        {
            if let tempDic1 : Dictionary = APPDELEGATE.MessageList[indexPath.row] as? Dictionary<String,Any>
             {
                if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                 {
                    if let getCatId : String = tempDicItem["id"] as? String
                    {
                        objRef.itemId = getCatId
                    
                    }
                     
                 }
                
                if let tempDicBuyer : Dictionary = tempDic1["buyer"] as? Dictionary<String,Any>
                 {
                    if let getImgUrl : String = tempDicBuyer["user_profile_photo"] as? String
                    {
                        objRef.imgUrl = getImgUrl
                    }
                    if let getImgUrl : String = tempDicBuyer["user_name"] as? String
                    {
                        objRef.userName = getImgUrl
                    }
                 }
                
                if let getUserId : String = tempDic1["buyer_user_id"] as? String
                {
                    objRef.sellerUserId = getUserId
                }
             }
        }
        self.navigationController?.pushViewController(objRef, animated: true)
      }
     }
    
    //MARK:- Web Services
//    func getMessagesApi(return_Type:String)
//    {
//        objHudShow()
//        var deviceID = ""
//        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//          print(uuid)
//            deviceID = uuid
//        }
//        var userIdStr = defaultValues.value(forKey: "UserID") as? String ?? ""
//        let params: [String: Any] = ["user_id":userIdStr,"return_type":return_Type]
//
//        print(params);
//
//        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chat_items/get_buyer_seller_list/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
//        if error == nil{
//            self.objHudHide()
//   self.getMessagesModel = Mapper<MessageModel>().map(JSONObject: response)
//
//   if self.getMessagesModel.status != "error"
//   {
////       if let data = self.getMessagesModel.ratingDetails
////       {
////
////       }
//
//   }else{
//    self.view.makeToast(NSLocalizedString(self.getMessagesModel.message ?? "", comment: ""), duration: 1.0, position: .center)
//   }
//
//    }
//            self.objHudHide()
//}
//
//}
    func getMessagesApi(return_Type:String)
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let parametersList:[String : Any] = [
                                           "user_id" : userId,
            "return_type":return_Type
                                           
]
        objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/chat_items/get_buyer_seller_list/api_key/teampsisthebest/limit/30/offset/0", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.MessageList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.MessageList.insert(resultsArray[i], at:  APPDELEGATE.MessageList.count)
                       
                    }
                   
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                   
                   
                }
                
              
               print("Recent Items:\(APPDELEGATE.MessageList)")
                self.tbleViewChat.reloadData()

            break

            case .failure:
            self.objHudHide();
            // self.refreshControl.endRefreshing()

           // self.blurEffect.isHidden = true

            //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

            break
            }
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
