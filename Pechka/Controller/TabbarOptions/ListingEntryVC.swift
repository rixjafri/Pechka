//
//  ListingEntryVC.swift
//  Pechka
//
//  Created by Neha Saini on 11/05/21.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import GooglePlacePicker
import ObjectMapper
import Alamofire


class ListingEntryVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate & UINavigationControllerDelegate,CLLocationManagerDelegate,MKMapViewDelegate{

    //MARK:- IBOutlets
    @IBOutlet weak var lblNotificationCount: UILabel!
    @IBOutlet weak var btnTitleListingEntry: UIButton!
    @IBOutlet weak var lblDealOption: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPriceType: UILabel!
    @IBOutlet weak var lblItemCondition: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblListingTitle: UILabel!
    @IBOutlet weak var lblAddImages: UILabel!
    @IBOutlet weak var tfAdrees: UITextField!
    @IBOutlet weak var viewBgAddress: UIView!
    @IBOutlet weak var viewBgDealOption: UIView!
    @IBOutlet weak var tfLong: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var btnHideSideMenu: UIButton!
    @IBOutlet weak var constWidthSideMenu: NSLayoutConstraint!
    @IBOutlet weak var tbleSideMenu: UITableView!
    @IBOutlet weak var viewSideMenu: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewBgLong: UIView!
    @IBOutlet weak var viewBgLat: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewMapView: UIView!
    @IBOutlet weak var btnCurrentLoc: UIButton!
    @IBOutlet weak var viewCurrentLocation: UIView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var txtViewMeetUp: UITextView!
    @IBOutlet weak var viewMeetUp: UIView!
    @IBOutlet weak var btnMeetUp: UIButton!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var txtViewHightlightInfo: UITextView!
    @IBOutlet weak var viewHighligghtInfo: UIView!
    @IBOutlet weak var btnShopSetting: UIButton!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnPriceType: UIButton!
    @IBOutlet weak var viewPriceType: UIView!
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var viewBrand: UIView!
    @IBOutlet weak var btnItemCondition: UIButton!
    @IBOutlet weak var viewItemCondition: UIView!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var viewType: UIView!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var viewSubCategory: UIView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var txtViewListingTitle: UITextView!
    @IBOutlet weak var viewBgListingTitle: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    
    //MARK:- Variable Declaration
    let menuHomeNames = [NSLocalizedString("Home", comment: ""),NSLocalizedString("Category", comment: ""),NSLocalizedString("Latest Items", comment: ""),NSLocalizedString("Popular Items", comment: "")]
    var menuUserInfoNames = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("Offer", comment: ""),NSLocalizedString("Message", comment: ""),NSLocalizedString("Favourite", comment: ""),NSLocalizedString("Paid Ad Transaction", comment: ""),NSLocalizedString("User History", comment: ""),NSLocalizedString("Log out", comment: "")]
    let menuAppNames = [NSLocalizedString("Language", comment: ""),NSLocalizedString("Contact us", comment: ""),NSLocalizedString("Settings", comment: ""),NSLocalizedString("Privacy Policy", comment: ""),NSLocalizedString("Share App", comment: ""),NSLocalizedString("Rate this app", comment: "")]
    let homeIconscons = ["homeTab","categoryTab","latestItem","populerItem"]
    var menuUserInfoIcons = ["userTab","offerTab","chatTab","favTab","paidTab","historyTab","logoutTab"]
    let menuAppIcons = ["languageTab","contactTab","settingsTab","privacyTab","shareTab","rateTab"]
    
    
    var getIndex = 0

    var arrImages = [UIImage]()
    var checklatitude = 0.0
    var checklongitude = 0.0
    let loc = CLLocationManager()
    var selectedImg = UIImage()
    var SelcetCityIdName = ""
    var SelcetCityId = ""
    var shop = "0"
    var getAddItemModel:AddItemModel!
    var itemId = ""
    var getProductItemDetailModel:ProductItemDetailModel!
    var getAddItemDefaultPhoto: AddItemDefaultPhoto!
    var getAddItemCategory: AddItemCategory!
    var getAddItemConditionOfItem: AddItemConditionOfItem!
    var getAddItemDealOption:AddItemDealOption!
    var getAddItemItemCurrency:AddItemItemCurrency!
    var getAddItemItemLocation:AddItemItemLocation!
    var getAddItemItemPriceType:AddItemItemPriceType!
    var getAddItemItemType:AddItemItemType!
    var getAddItemSubCategory:AddItemSubCategory!
    var getAddItemUser:AddItemUser!
    var getAddUserRatingDetail:AddUserRatingDetail!
    var checkScreen = ""
    var ItemId = ""
    var imgArr = NSMutableArray()
    var imgExtensionType = NSMutableArray()
    var imgNameArr = NSMutableArray()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        clearSearchData()
        setInitials()
        btnShopSetting.setImage(UIImage(named: "unSelected"), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateLatLong), name: NSNotification.Name(rawValue: "UpdateLatLong"), object: nil)
        txtViewDescription.delegate = self
        txtViewMeetUp.delegate = self
        txtViewListingTitle.delegate = self
        txtViewHightlightInfo.delegate = self
        txtViewDescription.layer.cornerRadius = 5
        txtViewDescription.layer.borderWidth = 1
        txtViewDescription.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewDescription.delegate = self
        txtViewDescription.text = NSLocalizedString("Description", comment: "")
        txtViewDescription.textColor = .lightGray
        
        txtViewMeetUp.layer.cornerRadius = 5
        txtViewMeetUp.layer.borderWidth = 1
        txtViewMeetUp.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewMeetUp.delegate = self
        txtViewMeetUp.text = NSLocalizedString("Remarks", comment: "")
        txtViewMeetUp.textColor = .lightGray
        
        txtViewListingTitle.layer.cornerRadius = 5
        txtViewListingTitle.layer.borderWidth = 1
        txtViewListingTitle.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewListingTitle.delegate = self
        txtViewListingTitle.text = NSLocalizedString("Listing Title", comment: "")
        txtViewListingTitle.textColor = .lightGray
        
        txtViewHightlightInfo.layer.cornerRadius = 5
        txtViewHightlightInfo.layer.borderWidth = 1
        txtViewHightlightInfo.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewHightlightInfo.delegate = self
        txtViewHightlightInfo.text =  NSLocalizedString("Highlight Information", comment: "")
        txtViewHightlightInfo.textColor = .lightGray
        btnTitleListingEntry.setTitle(NSLocalizedString("Listing Entry", comment: ""), for: .normal)
        let attImg = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrImg = NSAttributedString(string: NSLocalizedString("Add Images", comment: ""), attributes: attImg)
        let attImg1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrImg1 = NSAttributedString(string: " *", attributes: attImg1)
        let combination = NSMutableAttributedString()
        combination.append(attrStrImg)
        combination.append(attrStrImg1)
        lblAddImages.attributedText = combination

        let attListing = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrListing = NSAttributedString(string: NSLocalizedString("Listing Title", comment: ""), attributes: attListing)
        let attListing1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrListing1 = NSAttributedString(string: " *", attributes: attListing1)
        let combinationListing = NSMutableAttributedString()
        combinationListing.append(attrStrListing)
        combinationListing.append(attrStrListing1)
        lblListingTitle.attributedText = combinationListing
        
        let attCat = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrCat = NSAttributedString(string: NSLocalizedString("Category", comment: ""), attributes: attCat)
        let attCat1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrCat1 = NSAttributedString(string: " *", attributes: attCat1)
        let combinationCat = NSMutableAttributedString()
        combinationCat.append(attrStrCat)
        combinationCat.append(attrStrCat1)
        lblCategory.attributedText = combinationCat
        
        let attSubCat = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrSubCat = NSAttributedString(string: NSLocalizedString("Sub Category", comment: ""), attributes: attSubCat)
        let attSubCat1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrSubCat1 = NSAttributedString(string: " *", attributes: attSubCat1)
        let combinationSubCat = NSMutableAttributedString()
        combinationSubCat.append(attrStrSubCat)
        combinationSubCat.append(attrStrSubCat1)
        lblSubCategory.attributedText = combinationSubCat
        
        
        let attType = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrType = NSAttributedString(string: NSLocalizedString("Type", comment: ""), attributes: attType)
        let attType1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrType1 = NSAttributedString(string: " *", attributes: attType1)
        let combinationType = NSMutableAttributedString()
        combinationType.append(attrStrType)
        combinationType.append(attrStrType1)
        lblType.attributedText = combinationType
        
        let attItamCon = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrItamCon = NSAttributedString(string: NSLocalizedString("Item Condition", comment: ""), attributes: attItamCon)
        let attItamCon1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrItamCon1 = NSAttributedString(string: " *", attributes: attItamCon1)
        let combinationItamCon = NSMutableAttributedString()
        combinationItamCon.append(attrStrItamCon)
        combinationItamCon.append(attrStrItamCon1)
        lblItemCondition.attributedText = combinationItamCon
       
        let attPrice = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrPrice = NSAttributedString(string: NSLocalizedString("Price", comment: ""), attributes: attPrice)
        let attItamPrice1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrPrice1 = NSAttributedString(string: " *", attributes: attItamPrice1)
        let combinationPrice = NSMutableAttributedString()
        combinationPrice.append(attrStrPrice)
        combinationPrice.append(attrStrPrice1)
        lblPrice.attributedText = combinationPrice

        let attDescription = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrDescription = NSAttributedString(string: NSLocalizedString("Description", comment: ""), attributes: attDescription)
        let attDescription1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrDescription1 = NSAttributedString(string: " *", attributes: attDescription1)
        let combinationDescription = NSMutableAttributedString()
        combinationDescription.append(attrStrDescription)
        combinationDescription.append(attrStrDescription1)
        lblDescription.attributedText = combinationDescription

        let attDeal = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrStrDeal = NSAttributedString(string: NSLocalizedString("Deal Option", comment: ""), attributes: attDeal)
        let attDeal1 = [NSAttributedString.Key.foregroundColor: BaseViewController.appColor.cgColor]
        let attrStrDeal1 = NSAttributedString(string: " *", attributes: attDeal1)
        let combinationDeal = NSMutableAttributedString()
        combinationDeal.append(attrStrDeal)
        combinationDeal.append(attrStrDeal1)
        lblDealOption.attributedText = combinationDeal
        btnCategory.setTitle(NSLocalizedString(CHOOSE_CATEGORY, comment: ""), for: .normal)
        btnSubCategory.setTitle(NSLocalizedString(CHOOSE_SUB_CATEGORY, comment: ""), for: .normal)
        btnType.setTitle(NSLocalizedString(CHOOSE_ITEM_TYPE, comment: ""), for: .normal)
        btnItemCondition.setTitle(NSLocalizedString(CHOOSE_ITEM_CONDITION, comment: ""), for: .normal)
        btnPriceType.setTitle(NSLocalizedString(CHOOSE_ITEM_PRICE_TYPE, comment: ""), for: .normal)
        btnMeetUp.setTitle(NSLocalizedString(CHOOSE_ITEM_DEAL_OPTION, comment: ""), for: .normal)
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
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
        tbleSideMenu.reloadData()
        let valueCheckScreen = "\(defaultValues.value(forKey: "checkScreen") ?? "")"
        if valueCheckScreen   == "Home"
        {
            SelcetCityIdName = "\(defaultValues.value(forKey: "selectCityName") ?? "")"
            SelcetCityId = "\(defaultValues.value(forKey: "selectCity") ?? "")"
            self.btnLocation.setTitle(SelcetCityIdName, for: .normal)
          
        }
        else
        {
            SelcetCityIdName = "\(defaultValues.value(forKey: "selectCityNameListing") ?? "")"
            SelcetCityId = "\(defaultValues.value(forKey: "selectCityListing") ?? "")"
            self.btnLocation.setTitle(SelcetCityIdName, for: .normal)
        }
        if checkScreen == "Edit"
        {
            if getProductItemDetailModel != nil
            {
                txtViewDescription.delegate = self
                txtViewMeetUp.delegate = self
                txtViewListingTitle.delegate = self
                txtViewHightlightInfo.delegate = self
                itemId = getProductItemDetailModel.id ?? ""
                self.txtViewListingTitle.text = getProductItemDetailModel.title
                self.btnCategory.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnCategory.setTitle(getProductItemDetailModel.category?.catName, for: .normal)
                SEARCH_CATEGORY_ID = getProductItemDetailModel.category?.catId ?? ""
                self.btnSubCategory.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnSubCategory.setTitle(getProductItemDetailModel.subCategory?.name, for: .normal)
                SEARCH_SUB_CATEGORY_ID = getProductItemDetailModel.subCategory?.id ?? ""
                self.btnType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnType.setTitle(getProductItemDetailModel.itemType?.name, for: .normal)
                SEARCH_ITEM_TYPE_ID = getProductItemDetailModel.itemType?.id ?? ""
                self.btnItemCondition.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnItemCondition.setTitle(getProductItemDetailModel.conditionOfItem?.name, for: .normal)
                SEARCH_ITEM_CONDITION_ID = getProductItemDetailModel.conditionOfItem?.id ?? ""
                self.tfBrand.text = getProductItemDetailModel.brand
                self.btnPriceType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnPriceType.setTitle(getProductItemDetailModel.itemPriceType?.name, for: .normal)
                SEARCH_ITEM_PRICE_ID = getProductItemDetailModel.itemPriceType?.id ?? ""
                self.btnPrice.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnPrice.setTitle(getProductItemDetailModel.itemCurrency?.currencySymbol, for: .normal)
                SEARCH_CURRENCY_ID = getProductItemDetailModel.itemCurrency?.id ?? ""
                self.tfPrice.text = getProductItemDetailModel.price
                self.shop = getProductItemDetailModel.businessMode ?? ""
                if self.shop == "0"
                {
                    btnShopSetting.setImage(UIImage(named: "unSelected"), for: .normal)
                }
                else
                {
                    btnShopSetting.setImage(UIImage(named: "selected"), for: .normal)
                }
                txtViewHightlightInfo.text = getProductItemDetailModel.highlightInfo
                txtViewDescription.text = getProductItemDetailModel.descriptionField
                txtViewMeetUp.text = getProductItemDetailModel.dealOptionRemark
                self.btnMeetUp.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                self.btnMeetUp.setTitle(getProductItemDetailModel.dealOption?.name, for: .normal)
                SEARCH_ITEM_DEAL_ID = getProductItemDetailModel.dealOption?.id ?? ""
                self.btnLocation.setTitle(getProductItemDetailModel.itemLocation?.name, for: .normal)
               
                tfLat.text = getProductItemDetailModel.lat
                tfLong.text = getProductItemDetailModel.lng
                tfAdrees.text = getProductItemDetailModel.address
                var doubleLat = 0.0
                var doubleLng = 0.0
                if let userLatitude = getProductItemDetailModel.lat {
                     
                    doubleLat = Double(userLatitude )!
                    tfLat.text = "\(doubleLat)"
                }
                
                if let userLongitude = getProductItemDetailModel.lng {
                    doubleLng = Double(userLongitude )!
                    tfLong.text = "\(doubleLng)"
                }
               
                
                checklatitude = doubleLat
                checklongitude = doubleLng
                mapView.delegate = self
                mapView.isScrollEnabled = false
                mapView.isZoomEnabled = false
             
                centerMapOnLocation()
                loc.delegate = self
                loc.desiredAccuracy = kCLLocationAccuracyBest
                loc.requestAlwaysAuthorization()
                       
                       if CLLocationManager.locationServicesEnabled() {
                           //locationManager.startUpdatingHeading()
                        loc.startUpdatingLocation()
                       }
            
                if APPDELEGATE.getImages.count != 0
                {
                    for i in 0..<APPDELEGATE.getImages.count
                    {
                        if let tempDic1 : Dictionary = APPDELEGATE.getImages[i] as? Dictionary<String,Any>
                         {
                            if let getSliderNameImg : String = tempDic1["img_path"] as? String
                            {
                                self.imgArr.insert(getSliderNameImg, at: self.imgArr.count)
                                
                                
                            }
                        }
                    }
                    self.imgArr.insert(UIImage(named: "addImg")!, at: self.imgArr.count)
                }
            }
           
        }
        else if checkScreen == "Home"
        {

            let userLatitude = "\(UserDefaults.standard.value(forKey: "USER_LATITUDE") ?? "")"
            if userLatitude == ""
            {
                if CLLocationManager.locationServicesEnabled() {
                       switch CLLocationManager.authorizationStatus() {
                       case .notDetermined, .restricted, .denied:
                        let alert = UIAlertController(title: "Pachka", message: NSLocalizedString("To re-enable, please go to Settings and turn on Location Service for this app.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)")
                                })
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                       case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                          // locationManager.startUpdatingLocation()
                       }
                   } else {

                    APPDELEGATE.determineMyCurrentLocation()
                   }
            }
              
           
           
            
            var doubleLat = 0.0
            var doubleLng = 0.0
            if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
                 
                doubleLat = Double(userLatitude as! String)!
                checklatitude = doubleLat
                tfLat.text = "\(round(doubleLat * 100000000) / 100000000.0)"
            }
            
            if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
                doubleLng = Double(userLongitude as! String)!
                checklongitude = doubleLng
                tfLong.text = "\(round(doubleLng * 100000000) / 100000000.0)"
            }
            if let userAddress = UserDefaults.standard.value(forKey: "ADDRESS")
            {
             //   tfAdrees.text = "\(userAddress)"
            }
           
           
            mapView.delegate = self
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
         
            centerMapOnLocation()
            loc.delegate = self
            loc.desiredAccuracy = kCLLocationAccuracyBest
            loc.requestAlwaysAuthorization()
                   
                   if CLLocationManager.locationServicesEnabled() {
                       //locationManager.startUpdatingHeading()
                    loc.startUpdatingLocation()
                   }
           
            collectionView.reloadData()
        }
        setDropDownData()
       
       
    }
    
    @objc func UpdateLatLong(_ notification: Notification)
    {
        if (notification.name.rawValue == "UpdateLatLong")
        {
            var doubleLat = 0.0
            var doubleLng = 0.0
            if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
                 
                doubleLat = Double(userLatitude as! String)!
                checklatitude = doubleLat
                tfLat.text = "\(round(doubleLat * 100000000) / 100000000.0)"
            }
            
            if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
                doubleLng = Double(userLongitude as! String)!
                tfLong.text = "\(round(doubleLng * 100000000) / 100000000.0)"
                checklongitude = doubleLng
            }
            if let userAddress = UserDefaults.standard.value(forKey: "ADDRESS")
            {
              //  tfAdrees.text = "\(userAddress)"
            }
           
          
            
            mapView.delegate = self
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
         
            centerMapOnLocation()
            loc.delegate = self
            loc.desiredAccuracy = kCLLocationAccuracyBest
            loc.requestAlwaysAuthorization()
                   
                   if CLLocationManager.locationServicesEnabled() {
                       //locationManager.startUpdatingHeading()
                    loc.startUpdatingLocation()
                   }
        
        }
    }
   
    func setDropDownData(){
        
        if OPTION_TYPE == 1 && SEARCH_CATEGORY.count>0  {
            self.btnCategory.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            btnCategory.setTitle(SEARCH_CATEGORY, for: .normal)

        }
        else  if OPTION_TYPE == 2 && SEARCH_SUB_CATEGORY.count>0 {
            
            self.btnSubCategory.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            btnSubCategory.setTitle(SEARCH_SUB_CATEGORY, for: .normal)
            
        }
        else  if OPTION_TYPE == 3  && SEARCH_ITEM_TYPE.count>0 {
            
            self.btnType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)

             btnType.setTitle(SEARCH_ITEM_TYPE, for: .normal)
        }
        else  if OPTION_TYPE == 4   && SEARCH_ITEM_CONDITION.count>0 {
            
            self.btnItemCondition.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)

             btnItemCondition.setTitle(SEARCH_ITEM_CONDITION, for: .normal)
        }
        else  if OPTION_TYPE == 5   && SEARCH_ITEM_PRICE_TYPE.count>0 {
            
            self.btnPriceType.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)

             btnPriceType.setTitle(SEARCH_ITEM_PRICE_TYPE, for: .normal)
        }
        else  if OPTION_TYPE == 6   && SEARCH_ITEM_DEAL_OPTION.count>0 {
            
            self.btnMeetUp.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
             btnMeetUp.setTitle(SEARCH_ITEM_DEAL_OPTION, for: .normal)
        }
        else  if OPTION_TYPE == 7   && SEARCH_CURRENCY.count>0 {
            
            self.btnPrice.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)

             //btnMeetUp.setTitle(SEARCH_ITEM_DEAL_OPTION, for: .normal)
             btnPrice.setTitle(SEARCH_CURRENCY, for: .normal)
        }

        
    }
    
    
    func centerMapOnLocation(){

        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
        }
        
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
        }

           let centerRegionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: checklatitude, longitude: checklongitude)

           let spanRegion:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
           let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: centerRegionCoordinate, span: spanRegion)
       
           mapView.setRegion(mapRegion, animated: true)
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(checklatitude, checklongitude);
//           myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var doubleLat = 0.0
        var doubleLng = 0.0
//        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
//
//            doubleLat = Double(userLatitude as! String)!
//        }
//        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
//            doubleLng = Double(userLongitude as! String)!
//        }
        
           let center = CLLocationCoordinate2D(latitude: checklatitude, longitude: checklongitude)
           let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
           
           mapView.setRegion(region, animated: true)
           
           // Drop a pin at user's Current Location
           let myAnnotation: MKPointAnnotation = MKPointAnnotation()
           myAnnotation.coordinate = CLLocationCoordinate2DMake(checklatitude, checklongitude);
//           myAnnotation.title = "Current location"
           mapView.addAnnotation(myAnnotation)
       }
       
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
       {
           print("Error \(error)")
       }
    
    //MARK:- Upload Image
    func showActionSheet(){
            
            let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("UPLOAD IMAGE", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            actionSheetController.view.tintColor = UIColor.black
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
//            let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
//            { action -> Void in
//                self.camera()
//            }
//            actionSheetController.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
            { action -> Void in
                self.gallery()
            }
            actionSheetController.addAction(deleteActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
        func camera()
        {
            let myPickerControllerCamera = UIImagePickerController()
            myPickerControllerCamera.delegate = self
            myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
            myPickerControllerCamera.allowsEditing = true
            self.present(myPickerControllerCamera, animated: true, completion: nil)
        }
        
        func gallery()
        {
            let myPickerControllerGallery = UIImagePickerController()
            myPickerControllerGallery.delegate = self
            myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPickerControllerGallery.allowsEditing = true
            self.present(myPickerControllerGallery, animated: true, completion: nil)
        }
        
        //MARK:- UIImagePickerController delegate Methods
        @objc func imagePickerController(_ picker: UIImagePickerController,
                                         didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            guard let selectedImage = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
               
            }
            
          
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5)
//            {
                self.selectedImg = self.cropToBounds(image: selectedImage, width: 800.0, height: 800.0)
               
                self.arrImages.insert(self.cropToBounds(image: selectedImage, width: 800.0, height: 800.0), at: self.arrImages.count)
                
                self.imgArr.insert(self.cropToBounds(image: selectedImage, width: 800.0, height: 800.0), at: self.imgArr.count)
                guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
         
                self.imgNameArr.insert(fileUrl.lastPathComponent, at: self.imgNameArr.count)
                self.imgExtensionType.insert(fileUrl.pathExtension, at: self.imgExtensionType.count)
                
                    for i in 0..<self.arrImages.count
                    {
                        if self.arrImages[i] == UIImage(named: "addImg")
                      {
                            self.arrImages.remove(at: i)
                      }
                        
                    }
        
            if self.imgArr .contains(UIImage(named: "addImg")!) {
                self.imgArr.remove(UIImage(named: "addImg") as Any)
            }
                self.arrImages.insert(UIImage(named: "addImg")!, at: self.arrImages.count)
                self.imgArr.insert(UIImage(named: "addImg")!, at: self.imgArr.count)

//            }
            collectionView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
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
        btnSubmit.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnSubmit.layer.cornerRadius = 15
        btnSubmit.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
       
        tfPrice.delegate = self
        tfBrand.delegate = self
      
       
        txtViewHightlightInfo.layer.cornerRadius = 5
        txtViewHightlightInfo.layer.borderWidth = 1
        txtViewHightlightInfo.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewListingTitle.layer.cornerRadius = 5
        txtViewListingTitle.layer.borderWidth = 1
        txtViewListingTitle.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewHightlightInfo.layer.cornerRadius = 5
        txtViewHightlightInfo.layer.borderWidth = 1
        txtViewHightlightInfo.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewListingTitle.layer.cornerRadius = 5
        txtViewListingTitle.layer.borderWidth = 1
        txtViewListingTitle.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewDescription.layer.cornerRadius = 5
        txtViewDescription.layer.borderWidth = 1
        txtViewDescription.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewMeetUp.layer.cornerRadius = 5
        txtViewMeetUp.layer.borderWidth = 1
        txtViewMeetUp.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        viewCategory.layer.cornerRadius = 5
        viewCategory.layer.borderWidth = 1
        viewCategory.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewSubCategory.layer.cornerRadius = 5
        viewSubCategory.layer.borderWidth = 1
        viewSubCategory.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewType.layer.cornerRadius = 5
        viewType.layer.borderWidth = 1
        viewType.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewItemCondition.layer.cornerRadius = 5
        viewItemCondition.layer.borderWidth = 1
        viewItemCondition.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBrand.layer.cornerRadius = 5
        viewBrand.layer.borderWidth = 1
        viewBrand.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewPriceType.layer.cornerRadius = 5
        viewPriceType.layer.borderWidth = 1
        viewPriceType.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewPrice.layer.cornerRadius = 5
        viewPrice.layer.borderWidth = 1
        viewPrice.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewMeetUp.layer.cornerRadius = 5
        viewMeetUp.layer.borderWidth = 1
        viewMeetUp.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewLocation.layer.cornerRadius = 5
        viewLocation.layer.borderWidth = 1
        viewLocation.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewCurrentLocation.layer.cornerRadius = 5
        viewCurrentLocation.layer.borderWidth = 1
        viewCurrentLocation.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgLat.layer.cornerRadius = 5
        viewBgLat.layer.borderWidth = 1
        viewBgLat.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgLong.layer.cornerRadius = 5
        viewBgLong.layer.borderWidth = 1
        viewBgLong.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
//        btnMeetUp.layer.cornerRadius = 5
//        btnMeetUp.layer.borderWidth = 1
//        btnMeetUp.layer.borderColor = #colorLiteral(red: 1, green: 0.26634866, blue: 0, alpha: 1)
        btnPrice.layer.cornerRadius = 5
        btnPrice.layer.borderWidth = 1
        btnPrice.layer.borderColor = #colorLiteral(red: 1, green: 0.26634866, blue: 0, alpha: 1)
        viewBgDealOption.layer.cornerRadius = 5
        viewBgDealOption.layer.borderWidth = 1
        viewBgDealOption.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgAddress.layer.cornerRadius = 5
        viewBgAddress.layer.borderWidth = 1
        viewBgAddress.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtViewListingTitle
        {
            if (txtViewListingTitle.text ==  NSLocalizedString("Listing Title", comment: ""))
            {
                txtViewListingTitle.text = ""
                txtViewListingTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        else if textView == txtViewHightlightInfo
        {
            if (txtViewHightlightInfo.text ==  NSLocalizedString("Highlight Information", comment: ""))
            {
                txtViewHightlightInfo.text = ""
                txtViewHightlightInfo.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        else if textView == txtViewMeetUp
        {
            if (txtViewMeetUp.text ==  NSLocalizedString("Remarks", comment: ""))
            {
                txtViewMeetUp.text = ""
                txtViewMeetUp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        else if textView == txtViewDescription
        {
            if (txtViewDescription.text ==  NSLocalizedString("Description", comment: ""))
            {
                txtViewDescription.text = ""
                txtViewDescription.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        
      
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtViewDescription
        {
            if (txtViewDescription.text == "")
            {
                txtViewDescription.text = NSLocalizedString("Description", comment: "")
                txtViewDescription.textColor = .lightGray
            }
           
        }
        else if textView == txtViewMeetUp
        {
            if (txtViewMeetUp.text == "")
            {
                txtViewMeetUp.text = NSLocalizedString("Remarks", comment: "")
                txtViewMeetUp.textColor = .lightGray
            }
        }
        else if textView == txtViewListingTitle
        {
            if (txtViewListingTitle.text == "")
            {
                txtViewListingTitle.text = NSLocalizedString("Listing Title", comment: "")
                txtViewListingTitle.textColor = .lightGray
            }
        }
        else if textView == txtViewHightlightInfo
        {
            if (txtViewHightlightInfo.text == "")
            {
                txtViewHightlightInfo.text = NSLocalizedString("Highlight Information", comment: "")
                txtViewHightlightInfo.textColor = .lightGray
            }
        }
      
    }
    
    //MARK:- IBActions
    @IBAction func action_mapSelectLocBtnTapped(_ sender: UIButton)
    {
        var vc : UIViewController = UIViewController()
        let currentVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AutoCompleteVC.self)) as! AutoCompleteVC
        vc = currentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_hideSideMenuBtnTapped(_ sender: UIButton) {
        constWidthSideMenu.constant = 0
        btnHideSideMenu.isUserInteractionEnabled = false
    }
    @IBAction func action_currentLocBtnTapped(_ sender: UIButton)
    {
        let userLatitude = "\(UserDefaults.standard.value(forKey: "USER_LATITUDE") ?? "")"
        if userLatitude == ""
        {
            if CLLocationManager.locationServicesEnabled() {
                   switch CLLocationManager.authorizationStatus() {
                   case .notDetermined, .restricted, .denied:
                    let alert = UIAlertController(title: "Pachka", message: NSLocalizedString("To re-enable, please go to Settings and turn on Location Service for this app.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                   case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                      // locationManager.startUpdatingLocation()
                   }
               } else {

                APPDELEGATE.determineMyCurrentLocation()
               }
        }
          
       
    }
    
    @IBAction func action_locationBtnTapped(_ sender: UIButton)
    {
        let objRef:SelectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectCityVC") as! SelectCityVC
        objRef.checkScreen = "Listing"
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_meetUpBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 6
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_shopSettingBtnTapped(_ sender: UIButton)
    {
        if sender.currentImage == UIImage(named: "unSelected")
        {
            sender.setImage(UIImage(named: "selected"), for: .normal)
            shop = "1"
        }
        else
        {
            sender.setImage(UIImage(named: "unSelected"), for: .normal)
            shop = "0"
        }
    }
    
    @IBAction func action_priceBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 7
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_priceTypeBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 5
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_itemConditionBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
         OPTION_TYPE = 4
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_categoryBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 1
        
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_subCategoryBtnTapped(_ sender: UIButton)
    {
        if SEARCH_CATEGORY == "" {
            self.view.makeToast(NSLocalizedString("Please select category first", comment: ""), duration: 3.0, position: .bottom)
        }
        else{
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 2
        objRef.catId = SEARCH_CATEGORY_ID
        self.navigationController?.pushViewController(objRef, animated: true)
        }
    }
    
    @IBAction func action_typeBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 3
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_bellBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_sideMenuBtnTapped(_ sender: UIButton)
    {
        btnHideSideMenu.isUserInteractionEnabled = true
        constWidthSideMenu.constant = self.view.frame.width-100
    }
    
    @IBAction func action_submitBtnTapped(_ sender: UIButton)
    {
        for i in 0..<self.arrImages.count
        {
            if self.arrImages[i] == UIImage(named: "addImg")
          {
                self.arrImages.remove(at: i)
          }
        }
        
        if arrImages.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select atleast one image", comment: ""), duration: 3.0, position: .center)
        }
       else if txtViewListingTitle.text == "" || txtViewListingTitle.text == NSLocalizedString("Listing Title", comment: "")
        {
            self.view.makeToast(NSLocalizedString("Please add listing title", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_CATEGORY_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select category", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_SUB_CATEGORY_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select sub category", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_ITEM_TYPE_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select item type", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_ITEM_CONDITION_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select item condition", comment: ""), duration: 3.0, position: .center)
        }
//        else if tfBrand.text == ""
//        {
//            self.view.makeToast(NSLocalizedString("Please enter brand", comment: ""), duration: 3.0, position: .center)
//        }
        else if SEARCH_ITEM_PRICE_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please enter price", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_CURRENCY_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please select currency", comment: ""), duration: 3.0, position: .center)
        }
        else if tfPrice.text == ""
        {
            self.view.makeToast(NSLocalizedString("Please enter price", comment: ""), duration: 3.0, position: .center)
        }
//        else if txtViewHightlightInfo.text == "" || txtViewHightlightInfo.text ==  "Highlight Information"
//        {
//            self.view.makeToast(NSLocalizedString("Please enter highlight information", comment: ""), duration: 3.0, position: .center)
//        }
        else if txtViewDescription.text == "" || txtViewDescription.text ==  NSLocalizedString("Description", comment: "")
        {
            self.view.makeToast(NSLocalizedString("Please enter description", comment: ""), duration: 3.0, position: .center)
        }
        else if SEARCH_ITEM_DEAL_ID.count == 0
        {
            self.view.makeToast(NSLocalizedString("Please enter deal option", comment: ""), duration: 3.0, position: .center)
        }
//        else if txtViewMeetUp.text == "" || txtViewMeetUp.text ==  "Remarks"
//        {
//            self.view.makeToast(NSLocalizedString("Please enter remarks", comment: ""), duration: 3.0, position: .center)
//        }
        else if SelcetCityIdName == ""
        {
            self.view.makeToast(NSLocalizedString("Please select location city", comment: ""), duration: 3.0, position: .center)
        }
        else if tfLat.text == ""
        {
            self.view.makeToast(NSLocalizedString("Please select location", comment: ""), duration: 3.0, position: .center)
        }
        else if tfLong.text == ""
        {
            self.view.makeToast(NSLocalizedString("Please select location", comment: ""), duration: 3.0, position: .center)
        }
        else if tfAdrees.text == ""
        {
            self.view.makeToast(NSLocalizedString("Please enter address", comment: ""), duration: 3.0, position: .center)
        }
        else
        {
            
            let UserId = "\(defaultValues.value(forKey: "UserID") ?? "")"
            if UserId != ""
            {
                if checkScreen == "Edit"
                {
                    AddListingApi(getCatId:SEARCH_CATEGORY_ID,getSubCat:SEARCH_SUB_CATEGORY_ID,getItemTypeId:SEARCH_ITEM_TYPE_ID,getPriceTypeId:SEARCH_ITEM_PRICE_ID,getConditionItemId:SEARCH_ITEM_CONDITION_ID,getCurrencyId:SEARCH_CURRENCY_ID,getItemLocationId: SelcetCityId,getRemarkItem:txtViewMeetUp.text!,getDescription:txtViewDescription.text!,getHighLightInfo:txtViewHightlightInfo.text!,getPrice:tfPrice.text!,getDealOptionId:SEARCH_ITEM_DEAL_ID,getBrand:tfBrand.text!,getBusinessMode:shop,getIsSoldOut:getProductItemDetailModel.isSoldOut ?? "",getTitle:txtViewListingTitle.text!,getAddress:tfAdrees.text!,getLat:tfLat.text!,getLong:tfLong.text!,getId:itemId,getAddedUserId:UserId)
                }
                else
                {
                    AddListingApi(getCatId:SEARCH_CATEGORY_ID,getSubCat:SEARCH_SUB_CATEGORY_ID,getItemTypeId:SEARCH_ITEM_TYPE_ID,getPriceTypeId:SEARCH_ITEM_PRICE_ID,getConditionItemId:SEARCH_ITEM_CONDITION_ID,getCurrencyId:SEARCH_CURRENCY_ID,getItemLocationId: SelcetCityId,getRemarkItem:txtViewMeetUp.text!,getDescription:txtViewDescription.text!,getHighLightInfo:txtViewHightlightInfo.text!,getPrice:tfPrice.text!,getDealOptionId:SEARCH_ITEM_DEAL_ID,getBrand:tfBrand.text!,getBusinessMode:shop,getIsSoldOut:"",getTitle:txtViewListingTitle.text!,getAddress:tfAdrees.text!,getLat:tfLat.text!,getLong:tfLong.text!,getId:"",getAddedUserId:UserId)
                }
              
            }
           
        }

    }
    
    @IBAction func action_mapBtnTapped(_ sender: UIButton)
    {
        
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
        if checkScreen == "Edit"
        {
            if self.imgArr.count != 0
            {
                return self.imgArr.count
            }
            else
            {
                return  1
            }
           
        }
        else
        {
            if arrImages.count != 0
            {
                return arrImages.count
            }
            else
            {
                return  1
            }
        }
      
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
     let cell:AddImgCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImgCollectionViewCell", for: indexPath) as! AddImgCollectionViewCell
        if checkScreen == "Edit"
        {
            if self.imgArr.count != 0
            {
         
                var imageUrl =  BaseViewController.IMG_URL
                imageUrl.append("\(self.imgArr[indexPath.row])")
                            cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                if  cell.imgView.image ==  #imageLiteral(resourceName: "iconDe")
                
                {
                    cell.imgView.image = self.imgArr[indexPath.row] as? UIImage
                }
                
                
                     
                
                
            }
            else
            {
                cell.imgView.image = UIImage(named: "addImg")
            }
        }
        else
        {
            if arrImages.count != 0
            {
                cell.imgView.image = arrImages[indexPath.row]
            }
            else
            {
                cell.imgView.image = UIImage(named: "addImg")
              
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

      return  CGSize(width: 100, height:100)
      
    
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
        for i in 0..<arrImages.count
        {
          if arrImages[i] == UIImage(named: "addImg")
          {
            arrImages.remove(at: i)
          }
        }
        print(arrImages)
        showActionSheet()
       
    }
    
    func AddListingApi(getCatId:String,getSubCat:String,getItemTypeId:String,getPriceTypeId:String,getConditionItemId:String,getCurrencyId:String,getItemLocationId:String,getRemarkItem:String,getDescription:String,getHighLightInfo:String,getPrice:String,getDealOptionId:String,getBrand:String,getBusinessMode:String,getIsSoldOut:String,getTitle:String,getAddress:String,getLat:String,getLong:String,getId:String,getAddedUserId:String)
    {
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        
        let params: [String: Any] = ["cat_id":getCatId,"sub_cat_id":getSubCat,"item_type_id":getItemTypeId,"item_price_type_id":getPriceTypeId ,"item_currency_id":getCurrencyId,"condition_of_item_id":getConditionItemId,"item_location_id":getItemLocationId,"deal_option_remark":getRemarkItem,"description":getDescription,"highlight_info":getHighLightInfo,"price":getPrice,"deal_option_id":getDealOptionId,"brand":getBrand,"business_mode":getBusinessMode,"is_sold_out":getIsSoldOut,"title":getTitle,"address":getAddress,"lat":getLat,"lng":getLong,"id":getId,"added_user_id":getAddedUserId]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/items/add/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
                 
        self.getAddItemModel = Mapper<AddItemModel>().map(JSONObject: response)

        if self.getAddItemModel.status != "error"
        {
            self.itemId = self.getAddItemModel.id ?? ""
           if self.itemId != ""
            {
            for i in 0..<self.arrImages.count
            {
                if self.arrImages[i] == UIImage(named: "addImg")
              {
                    self.arrImages.remove(at: i)
              }
            }
           
                if self.arrImages.count != 0
                {
                    for i in 0..<self.arrImages.count
                    {
                        
                      var name = ""
                        if i < self.imgNameArr.count {
                            name = self.imgNameArr[i] as! String
                        }
                        var extensionN = ""
                          if i < self.imgExtensionType.count {
                            extensionN = self.imgExtensionType[i] as! String
                          }
//                        self.uploadImages()
                     
                        //        DispatchQueue.main.async {
                            self.editProfileImage(getItemId:self.itemId,getImage:self.arrImages[i], getImgId: "\(i)", imgName: name, extention: extensionN, index: i)
                        
                    }
                }

            }
         
           
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddItemModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
        
      }
    
    }
    
    func editProfileImage(getItemId:String,getImage:UIImage,getImgId:String,imgName:String,extention:String,index:Int)
    {
//        DispatchQueue.main.async {
     
         let parameters: [String:Any] =  [
        
         "img_id":"",
            "item_id":getItemId,
            
        
        ]
        
            self.objHudShow()
     
     
         
           print(parameters)
        guard var imgData1 = getImage.jpegData(compressionQuality: 0.1) else{return}
     if extention == "png" {
         imgData1 = getImage.pngData()!
     }


 
           Alamofire.upload(multipartFormData: { multipartFormData in
               multipartFormData.append(imgData1, withName: "file",fileName: imgName, mimeType: "image/jpg/png/jpeg")
            
               for (key, value) in parameters {
                   multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
               }
           }, usingThreshold: UInt64.init(),to: BaseViewController.API_URL+"rest/images/upload_item/api_key/teampsisthebest", method: .post, headers: nil) { (result) in
               switch result {
               case .success(let upload,_, _):
                   upload.uploadProgress(closure: { (progress) in
                       let value = Float(progress.fractionCompleted)*100
                       print(progress.fractionCompleted)
                       print(value)
                   })
                   upload.responseJSON { response in
                       print("Succesfully uploaded = \(response)")
                    self.objHudHide()
                   
                      if let jsonDict : NSDictionary = response.result.value as? NSDictionary
                     {
                       let status =  "\(jsonDict["status"] ?? "")"
                       if status != "error"
                       {
                        
                        if self.getIndex == self.arrImages.count - 1 {
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5)
//                        {
                           
                            self.view.makeToast(NSLocalizedString("Item added successfully", comment: ""), duration: 1.0, position: .center)

                              self.navigationController?.popViewController(animated: true)
                            }
//                       }
                        self.getIndex  =  self.getIndex + 1
                        print("***********************************")
                        print(self.getIndex)
                        print("***********************************")
                       }
                     }
                    
                  
                   }
               case .failure(let encodingError):
                
                self.objHudHide()
                   print("Error in upload: \(encodingError.localizedDescription)")
           }
                          
//        }
//        }
        }
    }
   

}
