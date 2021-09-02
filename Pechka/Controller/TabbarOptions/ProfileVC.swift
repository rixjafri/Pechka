//
//  ProfileVC.swift
//  Pechka
//
//  Created by Neha Saini on 07/05/21.
//

import UIKit
import SDWebImage
import FloatRatingView
import ObjectMapper
import Alamofire

class ProfileVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlets
    @IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet var btnViewAllDisabled: UIButton!
    @IBOutlet var btnViewAllPending: UIButton!
    @IBOutlet weak var widthConstStack: NSLayoutConstraint!
    @IBOutlet weak var topConstDisabledCollection: NSLayoutConstraint!
    @IBOutlet weak var topConstDisabledView: NSLayoutConstraint!
    @IBOutlet weak var topConstRejectedCollection: NSLayoutConstraint!
    @IBOutlet weak var topConstRejectedView: NSLayoutConstraint!
    @IBOutlet weak var topConstCollectionPending: NSLayoutConstraint!
    @IBOutlet weak var topConstBgPending: NSLayoutConstraint!
    @IBOutlet weak var topConstCollectionListing: NSLayoutConstraint!
    @IBOutlet weak var topListingViewBg: NSLayoutConstraint!
    @IBOutlet weak var topConstPaddAdCollection: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionDisabled: NSLayoutConstraint!
    @IBOutlet weak var heightViewDisabled: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionRejected: NSLayoutConstraint!
    @IBOutlet weak var heightViewRejected: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionAllListing: NSLayoutConstraint!
    @IBOutlet weak var heightViewAllisting: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionPaidAd: NSLayoutConstraint!
    @IBOutlet weak var heightViewBgPaid: NSLayoutConstraint!
    @IBOutlet weak var collectionViewDisabled: UICollectionView!
    @IBOutlet weak var viewBgDisabled: UIView!
    @IBOutlet weak var btnRejectedViewAll: UIButton!
    @IBOutlet weak var collectionViewRejected: UICollectionView!
    @IBOutlet weak var bgViewRejected: UIView!
    @IBOutlet weak var collectionViewPaidAd: UICollectionView!
    @IBOutlet weak var btnPaidAdViewAll: UIButton!
    @IBOutlet weak var viewBgPaidAd: UIView!
    @IBOutlet weak var topConstViewListing: NSLayoutConstraint!
    @IBOutlet weak var collectionviewHeightPending: NSLayoutConstraint!
    @IBOutlet weak var viewPendingHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewListing: UICollectionView!
    @IBOutlet weak var btnViewAllListing: UIButton!
    @IBOutlet weak var viewBgListing: UIView!
    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var btnGoogleVer: UIButton!
    @IBOutlet weak var btnCallVer: UIButton!
    @IBOutlet weak var btnGmailVer: UIButton!
    @IBOutlet weak var btnFacebookVer: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewBgPending: UIView!
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var lblJoinedDate: UILabel!
    @IBOutlet weak var lblTotalFollowing: UILabel!
    @IBOutlet weak var lblTotalFollowers: UILabel!
    @IBOutlet weak var imgProfil: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var viewBgEdit: UIView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var tbleSideMenu: UITableView!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var getAddUserModel:AddUserModel!
    var getAddUserRatingDetail:AddUserRatingDetail!
    var getAddItemUser:AddItemUser!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewListing.delegate = self
        collectionViewListing.dataSource = self
        collectionViewDisabled.delegate = self
        collectionViewDisabled.dataSource = self
        collectionViewPaidAd.delegate = self
        collectionViewPaidAd.dataSource = self
        collectionViewRejected.delegate = self
        collectionViewRejected.dataSource = self
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
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
        getPendingItemsListApi()
        getAddItemsListApi()
        UserFollowApi()
        getPaidAddItemsListApi()
        getRejectedItemsListApi()
        getDisabledItemsListApi()
        btnYes.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnYes.layer.cornerRadius = 15
        btnYes.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        btnNo.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        btnNo.layer.cornerRadius = 15
        btnNo.layer.borderWidth = 1
        btnNo.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        viewCustom.layer.cornerRadius = 10
       
        if let userName = defaultValues.value(forKey: "userName")
        {
            lblName.text = "\(userName)"
        }
        
//
//            if let imageName = defaultValues.value(forKey: "profile"){
//                let imgName = "\(imageName)"
//                var imageUrl = BaseViewController.IMG_URL
//                imageUrl.append(imgName)
//
//            imgProfil.sd_setShowActivityIndicatorView(true)
//                imgProfil.sd_setIndicatorStyle(.gray)
//                imgProfil!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:UIImage(named: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
//                if let EditType = defaultValues.value(forKey: "edit")
//                {
//                    let tyep = "\(EditType)"
//                    if tyep == "Edit"
//                    {
//                        let defaultImg = UIImage(named: "")
//                        let imageName = "\(defaultValues.value(forKey: "profile") ?? defaultImg as Any)"
//                            if imageName != ""
//                            {
//                                
//                                let img = imageName
//                                imgProfil.image = UIImage(named: "\(img)")
//                            }
//                    }
//                    
//                }
               
                
//            }
            
           if let joinedDate =  defaultValues.value(forKey: "addedDate")
           {
            lblJoinedDate.text = "\(joinedDate)"
           
           }
            
           if  let totalRating =  defaultValues.value(forKey: "ratingCount")
           {
            lblTotalRating.text = "(\(totalRating))"
            let totalRating = "\(totalRating)"
            viewRating.rating = Double(totalRating)!
           }
            
//            if let TotalFollowing =  defaultValues.value(forKey: "followingCount")
//            {
//                lblTotalFollowing.text = "\(TotalFollowing)"
//            }
//        
//            if let TotalFollowers =  defaultValues.value(forKey: "followerCount")
//            {
//                lblTotalFollowers.text = "\(TotalFollowers)"
//            }
            
            
            
        UserFollowApi()
       
        
    }
    //MARK:- Custom Method
    func setInitials()
    {
//       
//        viewBgEdit.layer.cornerRadius = 5
//        viewBgEdit.layer.borderColor = BaseViewController.appColor.cgColor
//        viewBgEdit.layer.borderWidth = 1
        btnEdit.clipsToBounds = true
        btnEdit.layer.cornerRadius = 5
        btnEdit.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnSetting.clipsToBounds = true
        btnSetting.layer.cornerRadius = 5
        btnSetting.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        btnEdit.tag = 101
        btnFav.tag = 102
        btnSetting.tag = 103
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
        btnEdit.backgroundColor = UIColor.white
        btnFav.backgroundColor = UIColor.white
        btnSetting.backgroundColor = UIColor.white
        btnFav.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        btnEdit.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        btnSetting.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
        btnEdit.setImage(UIImage(named: "edit"), for: .normal)
        btnFav.setImage(UIImage(named: "hearts"), for: .normal)
        btnSetting.setImage(UIImage(named: "setting"), for: .normal)
        btnViewAllPending.tag = 101
        btnViewAllListing.tag = 102
        btnViewAllDisabled.tag = 103
        btnRejectedViewAll.tag = 104
        btnPaidAdViewAll.tag = 105
        
        
    }
    //MARK:- IBActions
    @IBAction func action_followersBtnTapped(_ sender: UIButton)
    {
        let objRef:FollowersVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_followingBtnTapped(_ sender: UIButton)
    {
        let objRef:FollowingVC = self.storyboard?.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func Action_viewAllBtnTapped(_ sender: UIButton)
    {
     
        if sender.tag == 101
        {
            let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
            objRef.checkScreen = "Listing"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if sender.tag == 102
        {
            let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
            objRef.checkScreen = "All Listing"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if sender.tag == 103
        {
            let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
            objRef.checkScreen = "Disabled"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if sender.tag == 104
        {
            let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
            objRef.checkScreen = "Rejected"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if sender.tag == 105
        {
            let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
            objRef.checkScreen = "Paid Ad"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
       
    }
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
       constWidthSideMenu.constant = self.view.frame.width-100
        btnHideSideMenu.isUserInteractionEnabled = true
    }
    
    @IBAction func action_noBtnTapped(_ sender: UIButton)
    {
        viewAlpha.isHidden = true
    }
    @IBAction func action_deactivateAccountBtnTapped(_ sender: UIButton)
    {
        viewAlpha.isHidden = false
    }
    @IBAction func action_yesBtnTapped(_ sender: UIButton)
    {
        viewAlpha.isHidden = false
        deactivateApi()
    }
    @IBAction func action_belllBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_ProfileTypeBtnTapped(_ sender: UIButton)
    {
        if sender.tag == 101
        {
            btnEdit.backgroundColor = BaseViewController.appColor
            btnFav.backgroundColor = UIColor.white
            btnSetting.backgroundColor = UIColor.white
            btnEdit.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnFav.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnSetting.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnEdit.setImage(UIImage(named: "edits"), for: .normal)
            btnFav.setImage(UIImage(named: "hearts"), for: .normal)
            btnSetting.setImage(UIImage(named: "setting"), for: .normal)
            let objRef:EditProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            if self.getAddItemUser != nil
            {
                objRef.imgUrl = "\(self.getAddItemUser.userProfilePhoto ?? "")"
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if sender.tag == 102
        {
            btnEdit.backgroundColor = UIColor.white
            btnFav.backgroundColor = BaseViewController.appColor
            btnSetting.backgroundColor = UIColor.white
            btnFav.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnEdit.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnSetting.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnEdit.setImage(UIImage(named: "edit"), for: .normal)
            btnFav.setImage(UIImage(named: "heartWhite"), for: .normal)
            btnSetting.setImage(UIImage(named: "setting"), for: .normal)
            let objRef: FavouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as!  FavouritesVC
            objRef.checkScreen = "Proile"
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            btnEdit.backgroundColor = UIColor.white
            btnFav.backgroundColor = UIColor.white
            btnSetting.backgroundColor = BaseViewController.appColor
            btnSetting.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            btnEdit.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnFav.setTitleColor(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1), for: .normal)
            btnEdit.setImage(UIImage(named: "edit"), for: .normal)
            btnFav.setImage(UIImage(named: "hearts"), for: .normal)
            btnSetting.setImage(UIImage(named: "settings"), for: .normal)
            let objRef: SettingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as!  SettingsVC
            self.navigationController?.pushViewController(objRef, animated: true)
        }
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
    
    func deactivateApi()
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["user_id":userId ]
     
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/user_delete/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
            
        if self.getAddUserModel.status != "error"
        {
            
            self.navigationController?.popViewController(animated: true)
                defaultValues.set(nil, forKey: "UserID")
                defaultValues.set(nil, forKey: "userName")
                defaultValues.set(nil, forKey: "profile")
                defaultValues.set(nil, forKey: "addedDate")
                defaultValues.set(nil, forKey: "ratingCount")
                defaultValues.set(nil, forKey: "followingCount")
                defaultValues.set(nil, forKey: "followerCount")
                defaultValues.set(nil, forKey: "History")
                defaultValues.synchronize()
               
                
            APPDELEGATE.userTabbarCheck(value: 0)
           
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddUserModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    //MARK:- Collection View data source and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == collectionViewListing
       {
        return APPDELEGATE.getApproveList.count
       }
       else if collectionView == collectionViewRejected
       {
        return APPDELEGATE.getRejectedList.count
       }
       else if collectionView == collectionViewPaidAd
       {
        return APPDELEGATE.getPaidAdList.count
       }
       else if collectionView == collectionViewDisabled
       {
        return APPDELEGATE.getDisabledList.count
       }
       else
       {
        return APPDELEGATE.getPendingList.count
       }
        
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
    
       // cell.btnItemTap.addTarget(self, action: #selector(itemTapTapped(sender:)), for: .touchUpInside)
        if collectionView == collectionViewListing
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionViewListing.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
               cell.btnLike.tag = indexPath.row
               cell.btnItemTap.tag = indexPath.row
               cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
               cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary = APPDELEGATE.getApproveList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
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
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
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
            return cell
        }
        else if collectionView == collectionViewDisabled
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionViewDisabled.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
               cell.btnLike.tag = indexPath.row
               cell.btnItemTap.tag = indexPath.row
               cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
               cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary = APPDELEGATE.getDisabledList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
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
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
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
            return cell
        }
        else if collectionView == collectionViewRejected
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionViewRejected.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
               cell.btnLike.tag = indexPath.row
               cell.btnItemTap.tag = indexPath.row
               cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
               cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary =  APPDELEGATE.getRejectedList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
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
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
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
            return cell
        }
        else if collectionView == collectionViewPaidAd
        {
            let cell:RecentPopulerItemsPaidCollectionViewCell = collectionViewPaidAd.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsPaidCollectionViewCell", for: indexPath) as! RecentPopulerItemsPaidCollectionViewCell
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
                if let getCatName : String = tempDic1["amount"] as? String
                {
                    if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                     {
                        if let tempDicItemCurrency : Dictionary = tempDicItem["item_currency"] as? Dictionary<String,Any>
                         {
                            if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                            {
                                cell.lblAmountSpend.text = "\(getCatpriceCurrency) \(getCatName)"
                            }
                         }
                    }
                   
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
                                var totalPrice = Double()
                                totalPrice = Double(getCatprice) ?? 0.0
                                cell.lblPrice.text = "$ \(String(format: "%.2f", totalPrice)) (\(getConItem))"
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
        else 
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
               cell.btnLike.tag = indexPath.row
               cell.btnItemTap.tag = indexPath.row
               cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
               cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary = APPDELEGATE.getPendingList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date_str"] as? String
                {
                    cell.lblTime.text = getCatName
                }
                if let title:String = tempDic1["favourite_count"] as? String
                {
                    cell.btnLike.setTitle(title, for: .normal)
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
                            
                            cell.imgProduct.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
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
            return cell
        }
     
   
    }



     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
     {

     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let yourWidth = collectionView.frame.width/2
        // let yourHeight = yourWidth
     if collectionView == collectionViewPaidAd
     {
        return  CGSize(width: yourWidth, height:450)
     }
    else
     {
        return  CGSize(width: yourWidth, height:340)
     }
     
      
    
    }

     func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
     {
        if collectionView == collectionViewPaidAd
        {
            return 450
        }
        else
        {
            return 340
        }
      
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

//    @objc func itemTapTapped(sender:UIButton)
//    {
//        let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
//        if let tempDic1 : Dictionary = APPDELEGATE.getPendingList[sender.tag] as? Dictionary<String,Any>
//         {
//            if let getId : String = tempDic1["id"] as? String
//            {
//                objRef.catId = getId
//
//            }
//
//        }
//        self.navigationController?.pushViewController(objRef, animated: true)
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == collectionViewListing
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getApproveList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if collectionView == collectionViewRejected
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getRejectedList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if collectionView == collectionViewDisabled
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getDisabledList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
            
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if collectionView == collectionViewPaidAd
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getPaidAdList[indexPath.row] as? Dictionary<String,Any>
             {
                if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                 {
                    if let getId : String = tempDicItem["id"] as? String
                    {
                        objRef.catId = getId
                       
                    }
                    
                }
              
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getPendingList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
       
    }

    
    func getPendingItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let parametersList:[String : Any] = ["searchterm" : "",
                                           "cat_id" : "",
                                           "sub_cat_id" : "",
                                           "order_by" : "added_date",
                                           "order_type" : "desc",
                                           "item_type_id" : "",
                                           "item_price_type_id" : "",
                                           "item_currency_id" : "",
                                           "item_location_id" : "",
                                           "deal_option_id" : "",
                                           "condition_of_item_id" : "",
                                           "max_price" : "",
                                           "min_price" : "",
                                           "brand" : "",
                                           "lat" : "",
                                           "lng" : "",
                                           "miles" : "",
                                           "added_user_id" : userId,
                                           "is_paid" : "paid_item_first",
                                           "status" : "0"
]
        objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getPendingList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getPendingList.insert(resultsArray[i], at:  APPDELEGATE.getPendingList.count)
                       
                    }
                    self.viewBgPending.isHidden = false
                    self.viewPendingHeight.constant = 40
                    self.collectionviewHeightPending.constant = 340
                    self.topConstBgPending.constant = 20
                    self.topConstCollectionPending.constant = 5
                    //self.topConstViewListing.constant = 20
                   
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                //    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.viewBgPending.isHidden = true
                    self.viewPendingHeight.constant = 0
                    self.collectionviewHeightPending.constant = 0
                    self.topConstBgPending.constant = 0
                    self.topConstCollectionPending.constant = 0
                  //  self.topConstViewListing.constant = 10
                    
                }
                
              
               print("Recent Items:\(APPDELEGATE.getPendingList)")
                self.collectionView.reloadData()

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
    
    func getAddItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let parametersList:[String : Any] = ["searchterm" : "",
                                           "cat_id" : "",
                                           "sub_cat_id" : "",
                                           "order_by" : "added_date",
                                           "order_type" : "desc",
                                           "item_type_id" : "",
                                           "item_price_type_id" : "",
                                           "item_currency_id" : "",
                                           "item_location_id" : "",
                                           "deal_option_id" : "",
                                           "condition_of_item_id" : "",
                                           "max_price" : "",
                                           "min_price" : "",
                                           "brand" : "",
                                           "lat" : "",
                                           "lng" : "",
                                           "miles" : "",
                                           "added_user_id" : userId,
                                           "is_paid" : "paid_item_first",
                                           "status" : "1"
]
       // objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
      //  self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getApproveList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getApproveList.insert(resultsArray[i], at:  APPDELEGATE.getApproveList .count)
                       
                    }
                    self.viewBgListing.isHidden = false
                    self.heightViewAllisting.constant = 40
                    self.heightCollectionAllListing.constant = 340
                    self.topListingViewBg.constant = 20
                    self.topConstCollectionListing.constant = 5
                  
                    
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                 //   self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.viewBgListing.isHidden = true
                    self.heightViewAllisting.constant = 0
                    self.heightCollectionAllListing.constant = 0
                    self.topListingViewBg.constant = 0
                    self.topConstCollectionListing.constant = 0
                }
                
              
               print("Recent Items:\(APPDELEGATE.getApproveList)")
                self.collectionViewListing.reloadData()

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
    
    
    func UserFollowApi()
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["id":userId,"login_user_id":""]

        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/userfollows/search/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getAddItemUser = Mapper<AddItemUser>().map(JSONObject: response)

        if self.getAddItemUser.status != "error"
        {
            if let userName = self.getAddItemUser.userName
            {
                self.lblName.text = "\(userName)"
            }
            
            if let imageName = self.getAddItemUser.userProfilePhoto{
                    let imgName = "\(imageName)"
                    var imageUrl = BaseViewController.IMG_URL
                    imageUrl.append(imgName)
                defaultValues.setValue(self.getAddItemUser.userProfilePhoto ?? "", forKey: "profile")
                defaultValues.synchronize()
                self.imgProfil.sd_setShowActivityIndicatorView(true)
                self.imgProfil.sd_setIndicatorStyle(.gray)
                self.imgProfil!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:UIImage(named: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
                defaultValues.setValue(self.getAddItemUser.userName ?? "", forKey: "userName")
                defaultValues.setValue(self.getAddItemUser.addedDate ?? "", forKey: "addedDate")
                defaultValues.setValue(self.getAddItemUser.userEmail ?? "", forKey: "Email")
                defaultValues.setValue(self.getAddItemUser.city ?? "", forKey: "City")
                defaultValues.setValue(self.getAddItemUser.userAboutMe ?? "", forKey: "AboutMe")
                defaultValues.setValue(self.getAddItemUser.userAddress ?? "", forKey: "Address")
                defaultValues.setValue(self.getAddItemUser.userPhone ?? "", forKey: "Phone")
                defaultValues.synchronize()
                    
                }
           
            if let joinedDate =  self.getAddItemUser.addedDate
               {
                self.lblJoinedDate.text = "\(joinedDate)"
               
               }
                
            if  let totalRating =  self.getAddItemUser.ratingCount
               {
                self.lblTotalRating.text = "(\(totalRating))"
                let totalRating = "\(totalRating)"
                self.viewRating.rating = Double(totalRating)!
               }
                
            if let TotalFollowing =  self.getAddItemUser.followingCount
                {
                self.lblTotalFollowing.text = "\(TotalFollowing)"
                }
            
            if let TotalFollowers =  self.getAddItemUser.followerCount
                {
                    self.lblTotalFollowers.text = "\(TotalFollowers)"
                }
            if self.getAddItemUser.facebookVerify == "0" && self.getAddItemUser.emailVerify == "0" && self.getAddItemUser.googleVerify == "0" && self.getAddItemUser.phoneVerify == "0"
            {
                self.widthConstStack.constant = 120
            }
            else if (self.getAddItemUser.facebookVerify == "0" || self.getAddItemUser.emailVerify == "0") && (self.getAddItemUser.googleVerify == "0" || self.getAddItemUser.phoneVerify == "0")
            {
                self.widthConstStack.constant = 60
            }
            else if self.getAddItemUser.facebookVerify == "0" || self.getAddItemUser.emailVerify == "0" || self.getAddItemUser.googleVerify == "0" || self.getAddItemUser.phoneVerify == "0"
            {
                self.widthConstStack.constant = 30
            }
            else
            {
                self.widthConstStack.constant = 90
            }
            
            if self.getAddItemUser.facebookVerify ==  "0"
            {
                self.btnFacebookVer.isHidden = true
            }
            else
            {
                self.btnFacebookVer.isHidden = false
            }
            if self.getAddItemUser.emailVerify  ==  "0"
            {
                self.btnGmailVer.isHidden = true
            }
            else
            {
                self.btnGmailVer.isHidden = false
            }
            if self.getAddItemUser.googleVerify  ==  "0"
            {
                self.btnGoogleVer.isHidden = true
            }
            else
            {
                self.btnGoogleVer.isHidden = false
            }
            if self.getAddItemUser.phoneVerify  ==  "0"
            {
                self.btnCallVer.isHidden = true
            }
            else
            {
                self.btnCallVer.isHidden = false
            }
  
            print("touches")
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddItemUser.message ?? "", comment: ""), duration: 1.0, position: .center)
        }

       }
            self.objHudHide()
      }

    }
    
    
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
                    self.viewBgPaidAd.isHidden = false
                    self.heightViewBgPaid.constant = 40
                    self.heightCollectionPaidAd.constant = 450
                    self.topConstPaddAdCollection.constant = 5
                    
                  
                    
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                 //   self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.viewBgPaidAd.isHidden = true
                    self.heightViewBgPaid.constant = 0
                    self.heightCollectionPaidAd.constant = 0
                    self.topConstPaddAdCollection.constant = 0
                   
                    
                }
                
              
               print("Recent Items:\(APPDELEGATE.getPaidAdList)")
                self.collectionViewPaidAd.reloadData()

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
  
    func getRejectedItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let parametersList:[String : Any] = ["searchterm" : "",
                                           "cat_id" : "",
                                           "sub_cat_id" : "",
                                           "order_by" : "added_date",
                                           "order_type" : "desc",
                                           "item_type_id" : "",
                                           "item_price_type_id" : "",
                                           "item_currency_id" : "",
                                           "item_location_id" : "",
                                           "deal_option_id" : "",
                                           "condition_of_item_id" : "",
                                           "max_price" : "",
                                           "min_price" : "",
                                           "brand" : "",
                                           "lat" : "",
                                           "lng" : "",
                                           "miles" : "",
                                           "added_user_id" : userId,
                                           "is_paid" : "",
                                           "status" : "3"
]
       // objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
      //  self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getRejectedList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getRejectedList.insert(resultsArray[i], at:  APPDELEGATE.getRejectedList .count)
                       
                    }
                    self.bgViewRejected.isHidden = false
                    self.heightViewRejected.constant = 40
                    self.heightCollectionRejected.constant = 340
                    self.topConstRejectedView.constant = 20
                    self.topConstRejectedCollection.constant = 5
                  
                    
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                   // self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.bgViewRejected.isHidden = true
                    self.heightViewRejected.constant = 0
                    self.heightCollectionRejected.constant = 0
                    self.topConstRejectedView.constant = 0
                    self.topConstRejectedCollection.constant = 0
                   
                    
                }
                
              
               print("Recent Items:\(APPDELEGATE.getRejectedList)")
                self.collectionViewRejected.reloadData()

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
 
    func getDisabledItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let parametersList:[String : Any] = ["searchterm" : "",
                                           "cat_id" : "",
                                           "sub_cat_id" : "",
                                           "order_by" : "added_date",
                                           "order_type" : "desc",
                                           "item_type_id" : "",
                                           "item_price_type_id" : "",
                                           "item_currency_id" : "",
                                           "item_location_id" : "",
                                           "deal_option_id" : "",
                                           "condition_of_item_id" : "",
                                           "max_price" : "",
                                           "min_price" : "",
                                           "brand" : "",
                                           "lat" : "",
                                           "lng" : "",
                                           "miles" : "",
                                           "added_user_id" : userId,
                                           "is_paid" : "",
                                           "status" : "2"
]
       // objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
      //  self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getDisabledList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getDisabledList.insert(resultsArray[i], at:  APPDELEGATE.getDisabledList.count)
                       
                    }
                    self.viewBgDisabled.isHidden = false
                    self.heightViewDisabled.constant = 40
                    self.heightCollectionDisabled.constant = 340
                    self.topConstDisabledView.constant = 20
                    self.topConstDisabledCollection.constant = 5
                  
                    
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                 //   self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.viewBgDisabled.isHidden = true
                    self.heightViewDisabled.constant = 0
                    self.heightCollectionDisabled.constant = 0
                    self.topConstDisabledView.constant = 0
                    self.topConstDisabledCollection.constant = 0
                   
                    
                }
                
              
               print("Recent Items:\(APPDELEGATE.getDisabledList)")
                self.collectionViewDisabled.reloadData()

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
