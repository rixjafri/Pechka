//
//  HomeVC.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit
import ObjectMapper
import Alamofire
import SDWebImage

class HomeVC: BaseViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet var btnSelectRegion: UIButton!
    @IBOutlet weak var tbleViewProduct: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var constWidthSideMenuView: NSLayoutConstraint!
    @IBOutlet weak var tbleViewSideMenu: UITableView!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var btnAddListing: UIButton!
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var lnlNotiCount: UILabel!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    var pagecontrol = UIPageControl()
    var getCategory = NSMutableArray()
    var getCategoryDefaultIcon:CategoryDefaultIcon!
    var getCategoryDefaultPhoto:CategoryDefaultPhoto!
    var getForgotModel:ForgotModel!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
            NotificationRegisterApi()
        }
       
        lnlNotiCount.layer.cornerRadius = lnlNotiCount.frame.height/2
        lnlNotiCount.layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateCity), name: NSNotification.Name(rawValue: "UpdateCity"), object: nil)
        btnSelectRegion.layer.cornerRadius = btnSelectRegion.frame.height/2
        setInitials()
        searchBar.delegate = self
        searchBar.showsCancelButton = false
//        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
//            textfield.textColor = UIColor.black
//            textfield.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            textfield.placeholder = "Search keyboard: write buy or sell or the name the product"
//            textfield.borderStyle = .none
//            textfield.layer.cornerRadius = 20
//            textfield.clipsToBounds = true
//
//         }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        self.view.addGestureRecognizer(tap)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
            getFollowersItemsListApi()
        }
        else
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
            APPDELEGATE.getFollowersItems.removeAllObjects()
        }
        tbleViewSideMenu.reloadData()
        
        getCategoryListApi()
        getRecentUploadedItemsListApi()
        getPopularItemsListApi()
        getBannerListApi()
        getNotificationCountApi()
      
    }
    
    @objc func UpdateCity(_ notification: Notification)
    {
        if (notification.name.rawValue == "UpdateCity")
        {
            getRecentUploadedItemsListApi()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text != ""
        {
            
               let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
               objRef.screenCheck = searchBar.text!
               objRef.CatName = searchBar.text!
               objRef.titleName = searchBar.text!
               objRef.subCatId = ""
               self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            self.view.makeToast(NSLocalizedString("Please enter text", comment: ""), duration: 3.0, position: .center)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
      
    }
    //MARK:- Custom methods
    func setInitials()
    {
        btnAddListing.setImage(UIImage(named: "plus"), for: .normal)
        viewSideMenu.layer.shadowColor = UIColor.black.cgColor
        viewSideMenu.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewSideMenu.layer.shadowOpacity = 0.7
        viewSideMenu.layer.shadowRadius = 1.5
        tbleViewSideMenu.delegate = self
        tbleViewSideMenu.dataSource = self
        tbleViewSideMenu.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tbleViewSideMenu.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        self.tbleViewProduct.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderTableViewCell")
        self.tbleViewProduct.register(UINib(nibName: "UploadedTableViewCell", bundle: nil), forCellReuseIdentifier: "UploadedTableViewCell")
        self.tbleViewProduct.register(UINib(nibName: "CategoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tbleViewSideMenu.frame.width, height: 80))
        customView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbleViewSideMenu.tableFooterView = customView
        tbleViewSideMenu.tableFooterView?.isHidden = false
        tbleViewProduct.dataSource = self
        tbleViewProduct.delegate = self
        getCategoryListApi()
        getRecentUploadedItemsListApi()
        getPopularItemsListApi()
        getBannerListApi()
        if userId != ""
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]

            menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
            getFollowersItemsListApi()
        }
        else
        {
            menuUserInfoNames = [NSLocalizedString("Profile", comment: "")]
            menuUserInfoIcons = ["userTab"]
            APPDELEGATE.getFollowersItems.removeAllObjects()
        }
        tbleViewSideMenu.reloadData()

    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        constWidthSideMenuView.constant = 0
    }
    //MARK:- IBActions
    @IBAction func action_selectRegionBarTapped(_ sender: UIButton)
    {
        let objRef:SelectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityVC") as! SelectCityVC
        objRef.checkScreen = "Home"
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    @IBAction func action_serachBarTapped(_ sender: UIButton)
    {
        searchBar.text = ""
    }
    
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthSideMenuView.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_addListingBtnTapped(_ sender: UIButton)
    {
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
            let objRef:ListingEntryVC = self.storyboard?.instantiateViewController(withIdentifier: "ListingEntryVC") as! ListingEntryVC
            objRef.checkScreen = "Home"
            defaultValues.setValue("Home", forKey: "checkScreen")
            defaultValues.synchronize()
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            self.view.makeToast(NSLocalizedString("Plesae login first", comment: ""), duration: 3.0, position: .bottom)
        }
        
    }
    
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        constWidthSideMenuView.constant = self.view.frame.width-100
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
        if tableView == tbleViewProduct
        {
            return 5
        }
        else
        {
            return 4
        }
       
    }
    func  tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == tbleViewProduct
        {
            if section == 0
            {
              
                    let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                    let customlabel = UILabel(frame: CGRect(x: 10, y: 5, width: 220, height: 30))
                    customView.layer.masksToBounds = true
                    customlabel.font = UIFont(name: "Poppins-SemiBold",
                    size: 13.0)
                    customlabel.text = NSLocalizedString("Browse categories", comment: "")
                    customlabel.textColor = UIColor.black
                    customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    customView.addSubview(customlabel)
                    let rightButton = UIButton(frame: CGRect(x:tbleViewProduct.frame.width-60, y: 10, width: 60, height: 20))
                    rightButton.setTitle(NSLocalizedString("See all", comment: ""), for: .normal)
                    rightButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold",size: 13.0)
                    rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1), for: .normal)
                    rightButton.addTarget(self, action: #selector(BrowseCategoriesBtnTapped(sender:)), for: .touchUpInside)
                    customView.addSubview(rightButton)
                    return customView
             
             }
            
            else if section == 1
            {
                let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                customView.layer.masksToBounds = true
                customlabel.font = UIFont(name: "Poppins-SemiBold",
                 size: 13.0)
                customlabel.text = NSLocalizedString("Recent Uploaded Items", comment: "")
                customlabel.textColor = UIColor.black
                customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                customView.addSubview(customlabel)
                let rightButton = UIButton(frame: CGRect(x:tbleViewProduct.frame.width-60, y: 10, width: 60, height: 20))
                rightButton.setTitle(NSLocalizedString("See all", comment: ""), for: .normal)
                rightButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold",size: 13.0)
                rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1), for: .normal)
                rightButton.addTarget(self, action: #selector(RecentUploadedItemsBtnTapped(sender: )), for: .touchUpInside)
                customView.addSubview(rightButton)
                return customView
            }
            else if section == 2
             {
              
                let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                customView.layer.masksToBounds = true
                customlabel.font = UIFont(name: "Poppins-SemiBold",
                 size: 13.0)
                customlabel.text = NSLocalizedString("Popular Items", comment: "")
                customlabel.textColor = UIColor.black
                customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                customView.addSubview(customlabel)
                let rightButton = UIButton(frame: CGRect(x:tbleViewProduct.frame.width-60, y: 10, width: 60, height: 20))
                rightButton.setTitle(NSLocalizedString("See all", comment: ""), for: .normal)
                rightButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold",size: 13.0)
                rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1), for: .normal)
                rightButton.addTarget(self, action: #selector(PopularItemsBtnTapped(sender:)), for: .touchUpInside)
                customView.addSubview(rightButton)
                return customView
             
               
             }
            else if section == 3
            {
                let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                customView.layer.masksToBounds = true
                customlabel.font = UIFont(name: "Poppins-SemiBold",
                 size: 13.0)
                customlabel.text = NSLocalizedString("Your ad banner here", comment: "")
                customlabel.textColor = UIColor.black
                customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                let rightButton = UIButton(frame: CGRect(x:tbleViewProduct.frame.width-60, y: 10, width: 60, height: 20))
                rightButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold",size: 13.0)
                rightButton.setTitle(NSLocalizedString("See all", comment: ""), for: .normal)
                rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1), for: .normal)
                rightButton.addTarget(self, action: #selector(YourAdBannerHereBtnTapped(sender:)), for: .touchUpInside)
                customView.addSubview(rightButton)
                customView.addSubview(customlabel)
               
                return customView
            }
            else
            {
                let customView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.width, height: 40))
                let customlabel = UILabel(frame: CGRect(x: 10, y: 10, width: 220, height: 30))
                customView.layer.masksToBounds = true
                customlabel.font = UIFont(name: "Poppins-SemiBold",
                 size: 13.0)
                customlabel.text = NSLocalizedString("Items from your followers", comment: "")
                customlabel.textColor = UIColor.black
                customView.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                let rightButton = UIButton(frame: CGRect(x:tbleViewProduct.frame.width-60, y: 10, width: 60, height: 20))
                rightButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold",size: 13.0)
                rightButton.setTitle(NSLocalizedString("See all", comment: ""), for: .normal)
                rightButton.setTitleColor(#colorLiteral(red: 1, green: 0.4327273965, blue: 0.1708132327, alpha: 1), for: .normal)
                rightButton.addTarget(self, action: #selector(YourFollowersItemsBtnTapped(sender:)), for: .touchUpInside)
                customView.addSubview(rightButton)
                customView.addSubview(customlabel)
               
                return customView
            }
       
        }
        else
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
      
    }
    
    @objc func YourFollowersItemsBtnTapped(sender:UIButton)
    {
       let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
        objRef.checkScreen = "Items from your followers"
       self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @objc func RecentUploadedItemsBtnTapped(sender:UIButton)
    {
       let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
       objRef.screenCheck = "home"
       objRef.titleName = "Recent Uploaded Items"
       self.clearSearchData()
       self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @objc func BrowseCategoriesBtnTapped(sender:UIButton)
    {
        let objRef:BrowesCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowesCategoryVC") as! BrowesCategoryVC
        objRef.getCategory = getCategory
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @objc func PopularItemsBtnTapped(sender:UIButton)
    {
        let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
        objRef.screenCheck = "popular"
        objRef.titleName = "Popular Items"
        self.clearSearchData()
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @objc func YourAdBannerHereBtnTapped(sender:UIButton)
    {
        let objRef:BannerVC = self.storyboard?.instantiateViewController(withIdentifier: "BannerVC") as! BannerVC
        objRef.checkScreen = "Blog Detail"
        self.navigationController?.pushViewController(objRef, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == tbleViewProduct
        {
            return 40
        }
        else
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
    
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
      view.tintColor = .clear
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tbleViewProduct
        {
            return 1
        }
        else
        {
            if section == 0
            {
              return 1
            }
            else if section == 1
            {
              return homeIconscons.count
            }
            else if section == 2
            {
                return menuUserInfoIcons.count
            }
            else if section == 3
            {
                return menuAppNames.count
            }
            else
            {
                return 0
            }
        }
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == tbleViewProduct
        {
            if indexPath.section == 0
            {
              return 80
            }
            else if indexPath.section == 1
            {
                if APPDELEGATE.getRecentItemCategory.count == 0
                {
                    return 150
                }
                else
                {
                    return 340
                }
              
            }
            else if indexPath.section == 2
            {
                if APPDELEGATE.getRecentItemCategory.count == 0
                {
                    return 150
                }
                else
                {
                    return 340
                }
            }
            else if indexPath.section == 3
            {
              return 200
            }
            else if indexPath.section == 4
            {
                if APPDELEGATE.getFollowersItems.count == 0
                {
                    return 150
                }
                else
                {
                    return 340
                }
            }
            else
            {
                return 0
            }
            
        }
        else
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
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tbleViewProduct
        {
            if indexPath.section == 0
            {
                let cell : CategoriesTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
                 cell.collectionView.tag = 111
                 cell.selectionStyle = .none
                return cell
               
            }
            else if indexPath.section == 1
            {
                let cell : UploadedTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "UploadedTableViewCell", for: indexPath) as! UploadedTableViewCell
                if APPDELEGATE.getRecentItemCategory.count == 0
                {
                    cell.lblMessage.text = NSLocalizedString("In this part you will see the display of the last submitted articles.", comment: "")
                }
                else
                {
                    cell.lblMessage.text = ""
                }
                 cell.collectionView.tag = 112
                 cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 2
            {
                let cell : UploadedTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "UploadedTableViewCell", for: indexPath) as! UploadedTableViewCell
                if APPDELEGATE.getRecentItemCategory.count == 0
                {
                    cell.lblMessage.text = NSLocalizedString("In this part you will see the display of the most recently viewd and most popular articles.", comment: "")
                }
                else
                {
                    cell.lblMessage.text = ""
                }
                 cell.collectionView.tag = 113
                 cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 3
            {
                let cell : SliderTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.tag = 114
            
                cell.clipsToBounds = true
                cell.collectionView.reloadData()

             
                cell.selectionStyle = .none
             
                return cell
            }
            else if indexPath.section == 4
            {
                let cell : UploadedTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "UploadedTableViewCell", for: indexPath) as! UploadedTableViewCell
                if APPDELEGATE.getFollowersItems.count == 0
                {
                    cell.lblMessage.text = NSLocalizedString("In this part you will see the display of the most recently viewd and most popular articles.", comment: "")
                }
                else
                {
                    cell.lblMessage.text = ""
                }
                 cell.collectionView.tag = 115
                 cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell : UploadedTableViewCell = tbleViewProduct.dequeueReusableCell(withIdentifier: "UploadedTableViewCell", for: indexPath) as! UploadedTableViewCell
                if APPDELEGATE.getFollowersItems.count == 0
                {
                    cell.lblMessage.text = NSLocalizedString("In this part you will see the display of the most recently viewd and most popular articles.", comment: "")
                }
                else
                {
                    cell.lblMessage.text = ""
                }
                 cell.collectionView.tag = 115
                 cell.selectionStyle = .none
                return cell
            }
      
        }
        else
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
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnHideSideMenu.isUserInteractionEnabled = false
        constWidthSideMenuView.constant = 0
        if tableView == tbleViewProduct
        {
           
        }
        else
        {
           
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
       
     }
    
    
    

     

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
       
            if indexPath.section == 0
            {
                guard let tbleViewCell = cell as? CategoriesTableViewCell else { return }
                    tbleViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
            else if indexPath.section == 1
            {
                guard let tbleViewCell = cell as? UploadedTableViewCell else { return }
                    tbleViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
            else if indexPath.section == 2
            {
                guard let tbleViewCell = cell as? UploadedTableViewCell else { return }
                    tbleViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
            else if indexPath.section == 3
            {
                guard let tbleViewCell = cell as? SliderTableViewCell else { return }
                    tbleViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
            else if indexPath.section == 4
            {
                guard let tbleViewCell = cell as? UploadedTableViewCell else { return }
                    tbleViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
            }
 
   
    }
  
    
  
   
    //MARK:- Collection View data source and delegate methods
   func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
   }

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if collectionView.tag == 111
      {
        return getCategory.count
      }
     else if collectionView.tag == 112
      {
        return APPDELEGATE.getRecentItemCategory.count
      }
     else if collectionView.tag == 113
     {
        return APPDELEGATE.getPopularItemCategory.count
     }
    else if collectionView.tag == 114
     {
        return APPDELEGATE.getBannersItems.count
     }
    else if collectionView.tag == 115
    {
        return APPDELEGATE.getFollowersItems.count
    }
    else
    {
        return 0
    }


   }


   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
   {
    if collectionView.tag == 111
    {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if let tempDic1 : Dictionary = getCategory[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["cat_name"] as? String
            {
                cell.lblTitle.text = getCatName
            }
            
            if let getSliderName : Dictionary = tempDic1["default_icon"] as? Dictionary<String,Any>
            {
                if let getSliderNameImg : String = getSliderName["img_path"] as? String
                {
                    var imageUrl =  BaseViewController.IMG_URL
                        imageUrl.append(getSliderNameImg)
                    
                    cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "catgory"))
                    cell.imgView.layer.cornerRadius = 5
                    cell.imgView.layer.masksToBounds = true
                }
            }
            
        }
        return cell
    }
    else if collectionView.tag == 112
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadedCollectionViewCell", for: indexPath) as! UploadedCollectionViewCell
        cell.btnLike.tag = indexPath.row
        cell.btnItemTap.tag = indexPath.row
        cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
        cell.btnLike.addTarget(self, action: #selector(likeBtnTapped(sender:)), for: .touchUpInside)
        cell.btnItemTap.addTarget(self, action: #selector(itemTapTapped(sender:)), for: .touchUpInside)
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        if let tempDic1 : Dictionary = APPDELEGATE.getRecentItemCategory[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date_str"] as? String
            {
                cell.lblTime.text = getCatName
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
            if let title:String = tempDic1["favourite_count"] as? String
            {
                cell.btnLike.setTitle(title, for: .normal)
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
                        cell.imgProduct.image = #imageLiteral(resourceName: "itemDefault")
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
    else if collectionView.tag == 113
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadedCollectionViewCell", for: indexPath) as! UploadedCollectionViewCell
        cell.btnLike.tag = indexPath.row
        cell.btnItemTap.tag = indexPath.row
        cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
        cell.btnLike.addTarget(self, action: #selector(likeBtnTapped(sender:)), for: .touchUpInside)
        cell.btnItemTap.addTarget(self, action: #selector(itemTapTapped(sender:)), for: .touchUpInside)
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        if let tempDic1 : Dictionary = APPDELEGATE.getPopularItemCategory[indexPath.row] as? Dictionary<String,Any>
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
                        cell.imgProduct.image = #imageLiteral(resourceName: "itemDefault")
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
    else if collectionView.tag == 114
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidersCollectionViewCell", for: indexPath) as! SlidersCollectionViewCell
        if let tempDic1 : Dictionary = APPDELEGATE.getBannersItems[indexPath.row] as? Dictionary<String,Any>
         {
           
            
            if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
             {
                    if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                    {
                        var imageUrl =  BaseViewController.IMG_URL
                            imageUrl.append(getSliderNameImg1)
                        
                        cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                        cell.imgView.layer.masksToBounds = true
                       
                    }
                   else
                    {
                        cell.imgView.image = #imageLiteral(resourceName: "itemDefault")
                    }
            }
           
            }
        return cell
    }
    else if collectionView.tag == 115
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadedCollectionViewCell", for: indexPath) as! UploadedCollectionViewCell
        cell.btnLike.tag = indexPath.row
        cell.btnItemTap.tag = indexPath.row
        cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
        cell.btnLike.addTarget(self, action: #selector(likeBtnTapped(sender:)), for: .touchUpInside)
        cell.btnItemTap.addTarget(self, action: #selector(itemTapTapped(sender:)), for: .touchUpInside)
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        if let tempDic1 : Dictionary = APPDELEGATE.getFollowersItems[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date_str"] as? String
            {
                cell.lblTime.text = getCatName
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
            if let tempDicItemItemType : Dictionary = tempDic1["item_type"] as? Dictionary<String,Any>
             {
                if let getCatpriceCurrency : String = tempDicItemItemType["name"] as? String
                {
                    cell.lblSubCat.text = getCatpriceCurrency
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
            if let title:String = tempDic1["favourite_count"] as? String
            {
                cell.btnLike.setTitle(title, for: .normal)
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
                        cell.imgProduct.image = #imageLiteral(resourceName: "itemDefault")
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
    else
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        return cell
    }

   }

@objc func itemTapTapped(sender:UIButton)
{
    let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
    if let tempDic1 : Dictionary = APPDELEGATE.getRecentItemCategory[sender.tag] as? Dictionary<String,Any>
     {
        if let getId : String = tempDic1["id"] as? String
        {
            objRef.catId = getId
           
        }
        
    }
   
    self.navigationController?.pushViewController(objRef, animated: true)
}
@objc func likeBtnTapped(sender:UIButton)
{
//    if sender.currentImage == UIImage(named: "grayHeart")
//    {
//        sender.setImage(UIImage(named: "redHeart"), for: .normal)
//    }
//    else
//    {
//        sender.setImage(UIImage(named: "grayHeart"), for: .normal)
//    }
}
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {

    }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView.tag == 111
    {
   
     return  CGSize(width: 70, height:80)
     
    }
    else if collectionView.tag == 112
    {
        if APPDELEGATE.getRecentItemCategory.count == 0
        {
            return  CGSize(width: 180, height:150)
        }
        else
        {
            return  CGSize(width: 200, height:340)
        }
     
    }
    else if collectionView.tag == 113
    {
        if APPDELEGATE.getPopularItemCategory.count == 0
        {
            return  CGSize(width: 180, height:150)
        }
        else
        {
            return  CGSize(width: 200, height:340)
        }
     
    }
    else if collectionView.tag == 114
    {
      
     return  CGSize(width: collectionView.frame.width, height:200)

    }
    else
    {
        if APPDELEGATE.getFollowersItems.count == 0
        {
            return  CGSize(width: 180, height:150)
        }
        else
        {
            return  CGSize(width: 200, height:340)
        }
    }

   }

    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
    {
        if collectionView.tag == 111
        {
            return 80
        }
        else if collectionView.tag == 113
        {
            if APPDELEGATE.getPopularItemCategory.count == 0
            {
                return 150
            }
            else
            {
                
                return 340
            }
         
        }
        else  if collectionView.tag == 114
        {
            return 200
        }
        else if collectionView.tag == 112
        {
            if APPDELEGATE.getRecentItemCategory.count == 0
            {
                return 150
            }
            else
            {
                return 340
            }
         
        }
        else
        {
            if APPDELEGATE.getFollowersItems.count == 0
            {
                return 150
            }
            else
            {
                return 340
            }
         
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



   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
   {
    if collectionView.tag == 111
    {
        let objRef:BrowesCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowesCategoryVC") as! BrowesCategoryVC
        if let tempDic1 : Dictionary = getCategory[indexPath.row] as? Dictionary<String,Any>
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
    else if collectionView.tag == 112
    {
        let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        if let tempDic1 : Dictionary = APPDELEGATE.getRecentItemCategory[indexPath.row] as? Dictionary<String,Any>
         {
            if let getId : String = tempDic1["id"] as? String
            {
                objRef.catId = getId
               
            }
            
        }
       
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    else if collectionView.tag == 113
    {
        let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        if let tempDic1 : Dictionary = APPDELEGATE.getPopularItemCategory[indexPath.row] as? Dictionary<String,Any>
         {
            if let getId : String = tempDic1["id"] as? String
            {
                objRef.catId = getId
               
            }
            
        }
       
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    else if collectionView.tag == 114
    {
        let objRef:BannerVC = self.storyboard?.instantiateViewController(withIdentifier: "BannerVC") as! BannerVC
        objRef.checkScreen = "Blog Detail"
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    else if collectionView.tag == 115
    {
        let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        if let tempDic1 : Dictionary = APPDELEGATE.getFollowersItems[indexPath.row] as? Dictionary<String,Any>
         {
            if let getId : String = tempDic1["id"] as? String
            {
                objRef.catId = getId
               
            }
            if let getId : String = tempDic1["id"] as? String
            {
                objRef.itemId = getId
               
            }
        }
       
        self.navigationController?.pushViewController(objRef, animated: true)
    }
   }

    
    //MARK:- Web Services
    func getCategoryListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

      let parametersList:[String : Any] = [
        :
          ]
        objHudShow()
      Alamofire.request(BaseViewController.API_URL+"rest/categories/get/api_key/teampsisthebest/limit/30/offset/0", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
                self.getCategory.removeAllObjects()
                APPDELEGATE.getCategory.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        self.getCategory.insert(resultsArray[i], at: self.getCategory.count)
                        APPDELEGATE.getCategory.insert(resultsArray[i], at:  APPDELEGATE.getCategory.count)
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }

                
               
                print(self.getCategory)
                self.tbleViewProduct.reloadData()

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
    
    func getRecentUploadedItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

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
                                           "added_user_id" : "",
                                           "is_paid" : "paid_item_first",
                                           "status" : "1"
]
        objHudShow()
        let userId = defaultValues.value(forKey: "UserID") ?? ""
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/30/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getRecentItemCategory.removeAllObjects()
                APPDELEGATE.getAllRecentItems.removeAllObjects()
                APPDELEGATE.getPopularLatestList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getAllRecentItems.insert(resultsArray[i], at:  APPDELEGATE.getAllRecentItems.count)
                        APPDELEGATE.getPopularLatestList.insert(resultsArray[i], at:  APPDELEGATE.getPopularLatestList.count)
                        if let tempDic1 : Dictionary = resultsArray[i] as? Dictionary<String,Any>
                         {
                            if let getLocId : String = tempDic1["item_location_id"] as? String
                            {
                                let SelcetCityId = "\(defaultValues.value(forKey: "selectCity") ?? "")"
                                let SelcetCityIdName = "\(defaultValues.value(forKey: "selectCityName") ?? "")"
                                self.btnSelectRegion.setTitle(SelcetCityIdName, for: .normal)
                                if getLocId == SelcetCityId
                                {
                                    APPDELEGATE.getRecentItemCategory.insert(resultsArray[i], at:  APPDELEGATE.getRecentItemCategory.count)
                                }
                            }
                        }
                    
                       
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }
                
              
               print("Recent Items:\(APPDELEGATE.getRecentItemCategory)")
                self.tbleViewProduct.reloadData()

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
    
    func getPopularItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

        let parametersList:[String : Any] = ["searchterm" : "",
                                           "cat_id" : "",
                                           "sub_cat_id" : "",
                                           "order_by" : "touch_count",
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
                                           "added_user_id" : "",
                                           "is_paid" : "",
                                           "status" : "1"
]
        objHudShow()
        let userId = defaultValues.value(forKey: "UserID") ?? ""
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/30/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getPopularItemCategory.removeAllObjects()
                APPDELEGATE.getPopularLatestList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getAllPopularItems.insert(resultsArray[i], at:  APPDELEGATE.getAllPopularItems.count)
                        APPDELEGATE.getPopularLatestList.insert(resultsArray[i], at:   APPDELEGATE.getPopularLatestList.count)
                        
                        if let tempDic1 : Dictionary = resultsArray[i] as? Dictionary<String,Any>
                         {
                            if let getLocId : String = tempDic1["item_location_id"] as? String
                            {
                                let SelcetCityId = "\(defaultValues.value(forKey: "selectCity") ?? "")"
                                let SelcetCityIdName = "\(defaultValues.value(forKey: "selectCityName") ?? "")"
                                self.btnSelectRegion.setTitle(SelcetCityIdName, for: .normal)
                                if getLocId == SelcetCityId
                                {
                                    APPDELEGATE.getPopularItemCategory.insert(resultsArray[i], at:  APPDELEGATE.getPopularItemCategory.count)
                                    
                                }
                            }
                        }
                    
                       
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }
                
              
               print("Recent Items:\(APPDELEGATE.getPopularItemCategory)")
                self.tbleViewProduct.reloadData()

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
    
    func getFollowersItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

//        let parametersList:[String : Any] = ["searchterm" : "",
//                                           "cat_id" : "",
//                                           "sub_cat_id" : "",
//                                           "order_by" : "touch_count",
//                                           "order_type" : "desc",
//                                           "item_type_id" : "",
//                                           "item_price_type_id" : "",
//                                           "item_currency_id" : "",
//                                           "item_location_id" : "",
//                                           "deal_option_id" : "",
//                                           "condition_of_item_id" : "",
//                                           "max_price" : "",
//                                           "min_price" : "",
//                                           "brand" : "",
//                                           "lat" : "",
//                                           "lng" : "",
//                                           "miles" : "",
//                                           "added_user_id" : "",
//                                           "is_paid" : "",
//                                           "status" : "1"
//]
        objHudShow()
     //   print(parametersList)
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId == ""
        {
            APPDELEGATE.getFollowersItems.removeAllObjects()
        }
        Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/10/login_user_id/\(userId)", method: .post , parameters: [:],headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getFollowersItems.removeAllObjects()
             
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getFollowersItems.insert(resultsArray[i], at:  APPDELEGATE.getFollowersItems.count)
                       
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }
                
              
               print("Recent Items:\(APPDELEGATE.getFollowersItems)")
                self.tbleViewProduct.reloadData()

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
    
    func getBannerListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

        objHudShow()
     //   print(parametersList)
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        Alamofire.request(BaseViewController.API_URL+"rest/feeds/get/api_key/teampsisthebest/offset/0/limit/30", method: .get , parameters: [:],headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getBannersItems.removeAllObjects()
             
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getBannersItems.insert(resultsArray[i], at:  APPDELEGATE.getBannersItems.count)
                       
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }
                
              
               print("Recent Items:\(APPDELEGATE.getBannersItems)")
                self.tbleViewProduct.reloadData()

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
                        self.lnlNotiCount.isHidden = false
                        self.lnlNotiCount.text = notificationCount
                    }
                    else
                    {
                        self.lnlNotiCount.isHidden = true
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
}
