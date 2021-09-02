//
//  PaidADTransactionVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import Alamofire

class PaidADTransactionVC:BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

//MARK:- IBoutlets
@IBOutlet weak var collectionView: UICollectionView!
@IBOutlet weak var btnHideSideMenu: UIButton!
@IBOutlet weak var viewBgSideMenu: UIView!
@IBOutlet weak var btnSideMenu: UIButton!
@IBOutlet weak var tbleView: UITableView!
@IBOutlet weak var constWidthViewBgSideMenu: NSLayoutConstraint!

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
    getPaidAddItemsListApi()
    tbleView.reloadData()
}

//MARK:- Custom Methods
func setInitials()
{
    collectionView.delegate = self
    collectionView.dataSource = self
    viewBgSideMenu.layer.shadowColor = UIColor.black.cgColor
    viewBgSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
    viewBgSideMenu.layer.shadowOpacity = 0.7
    viewBgSideMenu.layer.shadowRadius = 1.5
    tbleView.delegate = self
    tbleView.dataSource = self
    tbleView.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
    tbleView.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
    let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleView.frame.width, height: 80))
    customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    tbleView.tableFooterView = customView
    tbleView.tableFooterView?.isHidden = false
}

//MARK:- IBActions
@IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton)
{
    constWidthViewBgSideMenu.constant = 0
    btnHideSideMenu.isUserInteractionEnabled = false
}
    
@IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
{
    btnHideSideMenu.isUserInteractionEnabled = true
    constWidthViewBgSideMenu.constant = self.view.frame.width-100
}

//MARK:- Tableview Delegate and Data Source
func numberOfSections(in tableView: UITableView) -> Int
{
  if tableView == tbleView
  {
    return 4
  }
    else
  {
  return 0
  }
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if tableView == tbleView
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
        return 5
    }
    
}

func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
{
    if tableView == tbleView
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
if tableView == tbleView
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
if tableView == tbleView
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
    if tableView == tbleView
    {
        if indexPath.section == 0
        {
            let cell = tbleView.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
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
            let cell = tbleView.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
            cell.lbl.text = menuHomeNames[indexPath.row]
            cell.imgview.image = UIImage(named: homeIconscons[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = tbleView.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
            cell.lbl.text = menuUserInfoNames[indexPath.row]
            cell.imgview.image = UIImage(named: menuUserInfoIcons[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else
        {
            let cell = tbleView.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
            cell.lbl.text = menuAppNames[indexPath.row]
            cell.imgview.image = UIImage(named: menuAppIcons[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    else
    {
        let cell = tbleView.dequeueReusableCell(withIdentifier: "FavouritesTableViewCell") as! FavouritesTableViewCell
       
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
{
  if tableView == tbleView
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
func numberOfSections(in collectionView: UICollectionView) -> Int
{
    return 1
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
{
    return APPDELEGATE.getPaidAdList.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
{

   let cell:RecentPopulerItemsPaidCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsPaidCollectionViewCell", for: indexPath) as! RecentPopulerItemsPaidCollectionViewCell
           cell.btnLike.tag = indexPath.row
           cell.btnItemTap.tag = indexPath.row
           cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
           cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        if let tempDic1 : Dictionary =  APPDELEGATE.getPaidAdList[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date_str"] as? String
            {
                cell.lblTime.text = getCatName
            }
            if let getCatName : String = tempDic1["start_date"] as? String
            {
                cell.lblStartDate.text = getCatName
            }
            if let getCatName : String = tempDic1["end_date"] as? String
            {
                cell.lblEndDate.text = getCatName
            }
          
               
            if let tempDicLoc : Dictionary = tempDic1["item_location"] as? Dictionary<String,Any>
             {
                    if let getSliderNameLoc : String = tempDicLoc["name"] as? String
                    {
                        cell.lblAddress.text = getSliderNameLoc
                    }
            }
            if let getPaidStatus : String = tempDic1["paid_status"] as? String
            {
                cell.viewSold.isHidden = false
                if getPaidStatus == "Not yet start"
                {
                   
                    cell.viewSold.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.65)
                    cell.lblSold.text = "Ads is Not Yet Start"
                }
                else
                {
                    cell.viewSold.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5)
                    cell.lblSold.text = "Ads In Progress"
                }
            }
            if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
             {
                
                if let title:String = tempDicItem["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
                }
//                    if let soldOut:String = tempDicItem["is_sold_out"] as? String
//                    {
//                     if soldOut == "0"
//                     {
                    
//                        cell.viewSold.isHidden = true
//                        cell.lblSold.text = ""
//                     }
//                     else
//                     {
//                        cell.viewSold.isHidden = false
//                        cell.lblSold.text = "Sold"
//                     }
//                    }
                if let getCatprice : String = tempDicItem["price"] as? String
                {
                    if let tempDicItemCondition : Dictionary = tempDicItem["condition_of_item"] as? Dictionary<String,Any>
                    {
                        if let getConItem : String = tempDicItemCondition["name"] as? String
                        {
                            if let tempDicItemCurrency : Dictionary = tempDicItem["item_currency"] as? Dictionary<String,Any>
                             {
                                if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                                {
                                    var totalPrice = Double()
                                    totalPrice = Double(getCatprice) ?? 0.0
                                    cell.lblPrice.text = "\(getCatpriceCurrency) \(String(format: "%.2f", totalPrice)) (\(getConItem))"
                                    if let getCatName : String = tempDic1["amount"] as? String
                                    {
                                        cell.lblAmountSpend.text = "\(getCatpriceCurrency) \(getCatName)"
                                    }
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
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                            cell.imgProduct.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgProduct.image = UIImage(named: "userIcon")
                        }
                }
                
                if let tempDicUser : Dictionary = tempDicItem["user"] as? Dictionary<String,Any>
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
        return cell
   

}

func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
{

}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

     let yourWidth = collectionView.frame.width/2
    // let yourHeight = yourWidth

    return  CGSize(width: yourWidth, height:450)

}

func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
{
    return 450
}
    
func scrollCollectionView(indexpath:IndexPath,collectionView:UICollectionView)
{
// collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
 //collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .left)
// collectionView.scrollToItem(at: indexpath, at:.left, animated: true)

}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
{
    return UIEdgeInsets.zero
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
{
    return 0
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
{
    return 0
}


//MARK:-Webservices
func getPaidAddItemsListApi()
 {
        //self.objHudShow()
        //self.blurEffect.isHidden = false

     let headers1 = [
         "Accept": "application/json"
        
     ]

    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    let parametersList:[String : Any] = [:
]
   // objHudShow()
  
  Alamofire.request(BaseViewController.API_URL+"rest/paid_items/get/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
  //  self.objHudHide();
        switch response.result {

        case .success (let value):
           
            APPDELEGATE.getPaidAdList.removeAllObjects()
            if let array = response.result.value as? [Any] {
                print("Got an array with \(array.count) objects")
                let resultsArray = value as! [AnyObject]
               
                for i in 0..<resultsArray.count
                {
                    APPDELEGATE.getPaidAdList.insert(resultsArray[i], at:  APPDELEGATE.getPaidAdList.count)
                   
                }
               
                
              
                
            }
            else if let dictionary = response.result.value as? [AnyHashable: Any] {
                print("Got a dictionary: \(dictionary)")
                self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
               
               
                
            }
            
          
           print("Recent Items:\(APPDELEGATE.getPaidAdList)")
            self.collectionView.reloadData()

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
