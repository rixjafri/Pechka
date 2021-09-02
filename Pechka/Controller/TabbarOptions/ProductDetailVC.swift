//
//  ProductDetailVC.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit
import ObjectMapper
import Alamofire
class ProductDetailVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

//MARK:- IBOutlets
@IBOutlet weak var btnPaidStatus: UIButton!
@IBOutlet weak var heightPromotingYourItem: NSLayoutConstraint!
@IBOutlet weak var topConstPromoteYourItem: NSLayoutConstraint!
@IBOutlet weak var topConstLocationItem: NSLayoutConstraint!
@IBOutlet weak var heightConstBtnPromote: NSLayoutConstraint!
@IBOutlet weak var lblPromoteYourItem: UILabel!
@IBOutlet weak var heightConstViewBgPromote: NSLayoutConstraint!
@IBOutlet weak var viewBgPromote: UIView!
@IBOutlet weak var lblPromote: UILabel!
@IBOutlet weak var btnPromote: UIButton!
@IBOutlet weak var topConstLblStaticDetail: NSLayoutConstraint!
@IBOutlet weak var heightConstCallChat: NSLayoutConstraint!
@IBOutlet weak var iconBeg: UIImageView!
@IBOutlet weak var iconInfo: UIImageView!
@IBOutlet weak var iconDeal: UIImageView!
@IBOutlet weak var iconQuality: UIImageView!
@IBOutlet weak var iconCat: UIImageView!
@IBOutlet weak var iconClock: UIImageView!
@IBOutlet weak var btnNoMarkAsSold: UIButton!
@IBOutlet weak var btnYesMarkAsSold: UIButton!
@IBOutlet weak var viewMarkAsSold: UIView!
@IBOutlet weak var btnMarkAsSold: UIButton!
@IBOutlet weak var btnNoDelete: UIButton!
@IBOutlet weak var btnYesDelete: UIButton!
@IBOutlet weak var viewBgDeleteItem: UIView!
@IBOutlet weak var viewEditDelete: UIView!
@IBOutlet weak var btnDelete: UIButton!
@IBOutlet weak var btnEdit: UIButton!
@IBOutlet weak var btnPhotos: UIButton!
@IBOutlet weak var btnShareThisImg: UIButton!
@IBOutlet weak var btnReportThisItem: UIButton!
@IBOutlet weak var btnNo: UIButton!
@IBOutlet weak var btnYes: UIButton!
@IBOutlet weak var viewReportItem: UIView!
@IBOutlet weak var viewReport: UIView!
@IBOutlet weak var viewAlpha: UIView!
@IBOutlet weak var lblAddress: UILabel!
@IBOutlet weak var btnViewOnMap: UIButton!
@IBOutlet weak var tbleSeller: UITableView!
@IBOutlet weak var btnSeeMoreSafty: UIButton!
@IBOutlet weak var lblSaftyTrips: UILabel!
@IBOutlet weak var lblDescription: UILabel!
@IBOutlet weak var lblsell: UILabel!
@IBOutlet weak var lblDeal: UILabel!
@IBOutlet weak var lblQuality: UILabel!
@IBOutlet weak var lblOrderItem: UILabel!
@IBOutlet weak var lblCtaegory: UILabel!
@IBOutlet weak var lblTime: UILabel!
@IBOutlet weak var btnChat: UIButton!
@IBOutlet weak var btnCall: UIButton!
@IBOutlet weak var btnLike: UIButton!
@IBOutlet weak var btnSeen: UIButton!
@IBOutlet weak var lblPrice: UILabel!
@IBOutlet weak var btnWishListLike: UIButton!
@IBOutlet weak var lblItemName: UILabel!
@IBOutlet weak var constHeightImg: NSLayoutConstraint!
@IBOutlet weak var imgView: UIImageView!
@IBOutlet weak var btnBack: UIButton!
@IBOutlet weak var btnSeeMore: UIButton!
@IBOutlet weak var lblDetailStatic: UILabel!
@IBOutlet weak var btnWishlistUnLike: UIButton!
@IBOutlet weak var lblDesStatic: UILabel!
@IBOutlet weak var lblSafetyStaic: UILabel!
@IBOutlet weak var lblSellerStatic: UILabel!
@IBOutlet weak var lblGettingStaic: UILabel!
@IBOutlet weak var lblItemLocStaic: UILabel!
@IBOutlet weak var lblMeetUpStatic: UILabel!
    
//MARK:- Variable Declartion
var catId = ""
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
var phoneNumber = ""
var getForgotModel:ForgotModel!
var checkScreen = ""
    
//MARK:- View Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    setInitials()
    getDetailApi()
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if userId != ""
    {
        TouchApi()
    }
   
    if checkScreen != "UserHistory"
    {
        getDetailListApi()
    }
    
    btnWishListLike.setImage(#imageLiteral(resourceName: "wishlist"), for: .normal)
    
}
    
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       let touch: UITouch? = touches.first
       //location is relative to the current view
       // do something with the touched point
       print("viewAlpha")
       if touch?.view == viewAlpha{
        viewAlpha.isHidden = true
       }
}


override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    tabBarController?.tabBar.isHidden = true
   
}

private func callNumber(phoneNumber: String) {
   guard let url = URL(string: "telprompt://\(phoneNumber)"),
       UIApplication.shared.canOpenURL(url) else {
       return
   }
   UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
//MARK:- Custom Methods
func setInitials()
{
    viewEditDelete.isHidden = true
    constHeightImg.constant = self.view.frame.width
    btnCall.layer.backgroundColor = BaseViewController.appColor.cgColor
    btnCall.layer.cornerRadius = 15
    btnCall.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    
    btnChat.layer.borderColor = BaseViewController.appColor.cgColor
    btnChat.layer.cornerRadius = 15
    btnChat.layer.borderWidth = 1
    btnChat.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    tbleSeller.delegate = self
    tbleSeller.dataSource = self
    
    btnYes.layer.backgroundColor = BaseViewController.appColor.cgColor
    btnYes.layer.cornerRadius = 15
    btnYes.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    
    btnNo.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    btnNo.layer.cornerRadius = 15
    btnNo.layer.borderWidth = 1
    btnNo.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    
    btnEdit.layer.backgroundColor = BaseViewController.appColor.cgColor
    btnEdit.layer.cornerRadius = 15
    btnEdit.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    
    btnDelete.layer.borderColor = BaseViewController.appColor.cgColor
    btnDelete.layer.cornerRadius = 15
    btnDelete.layer.borderWidth = 1
    btnDelete.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    
    btnYesDelete
        .layer.backgroundColor = BaseViewController.appColor.cgColor
    btnYesDelete.layer.cornerRadius = 15
    btnYesDelete.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    
    btnNoDelete.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    btnNoDelete.layer.cornerRadius = 15
    btnNoDelete.layer.borderWidth = 1
    btnNoDelete.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    
    btnYesMarkAsSold
        .layer.backgroundColor = BaseViewController.appColor.cgColor
    btnYesMarkAsSold.layer.cornerRadius = 15
    btnYesMarkAsSold.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
    
    btnNoMarkAsSold.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    btnNoMarkAsSold.layer.cornerRadius = 15
    btnNoMarkAsSold.layer.borderWidth = 1
    btnNoMarkAsSold.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    
    viewReportItem.layer.cornerRadius = 10
    viewBgDeleteItem.layer.cornerRadius = 10
    viewMarkAsSold.layer.cornerRadius = 10
    btnMarkAsSold.layer.cornerRadius = 10
}

//MARK:- IBActions
@IBAction func action_promoteBtnTapped(_ sender: UIButton)
{
    let objRef:PromoteVC = self.storyboard?.instantiateViewController(withIdentifier: "PromoteVC") as! PromoteVC
    objRef.getItemId = catId
    self.navigationController?.pushViewController(objRef, animated: true)
}
@IBAction func action_editBtnTapped(_ sender: UIButton)
{
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if self.getAddItemUser != nil
    {
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            let objRef:ListingEntryVC = self.storyboard?.instantiateViewController(withIdentifier: "ListingEntryVC") as! ListingEntryVC
            objRef.checkScreen = "Edit"
            objRef.getProductItemDetailModel = getProductItemDetailModel
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            
        }
    }
  
}

@IBAction func action_deleteBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = false
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = false
    viewMarkAsSold.isHidden = true
}

@IBAction func action_photosBtnTapped(_ sender: UIButton)
{
    if APPDELEGATE.getImages.count != 0
    {
        let objRef:GalleryVC = self.storyboard?.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        objRef.getAddItemDefaultPhoto = getAddItemDefaultPhoto
        self.navigationController?.pushViewController(objRef, animated: true)
    }
 
}

@IBAction func action_backBtnTapped(_ sender: UIButton)
{
    self.navigationController?.popViewController(animated: true)
}

@IBAction func action_seeMoreBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = false
    viewReport.isHidden = false
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
}

@IBAction func action_wishlistLikeBtnTapped(_ sender: UIButton)
{
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    let addedUserId = self.getAddItemUser.userId
    if userId != ""
    {
        if userId == addedUserId
        {
            self.view.makeToast(NSLocalizedString("You can not like this item because this item added by you.", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
            if sender.currentImage == #imageLiteral(resourceName: "wishlist")
            {
                sender.setImage(#imageLiteral(resourceName: "wishlistApp"), for: .normal)
            }
            else
            {
                sender.setImage(#imageLiteral(resourceName: "wishlist"), for: .normal)
            }
            LikeUnLikeApi()
        }
    }
    else
    {
        self.view.makeToast(NSLocalizedString("Please login first.", comment: ""), duration: 1.0, position: .center)
    }
}

@IBAction func action_wishlistUnLikeBtnTapped(_ sender: UIButton)
{
    
}

@IBAction func action_seenBtnTapped(_ sender: UIButton)
{
    
}

@IBAction func action_likeBtnTapped(_ sender: UIButton)
{
    
}

@IBAction func action_callBtnTapped(_ sender: UIButton)
{
    let getPhoneNo = self.phoneNumber.replacingOccurrences(of: " ", with: "")
    let trimmedPhoneNo = getPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
    self.phoneNumber = trimmedPhoneNo
    
    if self.phoneNumber == ""
    {
       self.view.makeToast(NSLocalizedString("Contact number not available.", comment: ""), duration: 1.0, position: .center)
    }
    else
    {
       self.callNumber(phoneNumber: phoneNumber)
    }
}

@IBAction func action_chatBtnTapped(_ sender: UIButton)
{
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if userId != ""
    {
        let objRef:MakeOfferChatVC =  self.storyboard?.instantiateViewController(withIdentifier: "MakeOfferChatVC") as! MakeOfferChatVC
        objRef.getProductItemDetailModel = getProductItemDetailModel
        objRef.itemId = getProductItemDetailModel.id ?? ""
        objRef.typeSellerBuyer = "CHAT_FROM_SELLER"
        objRef.screenType = "Product"
        if self.getAddItemUser.userId != ""
        {
            objRef.sellerUserId = self.getAddItemUser.userId ?? ""
        }
       
        if self.getAddItemUser.userProfilePhoto != ""
        {
            objRef.imgUrl = self.getAddItemUser.userProfilePhoto ?? ""
        }
        if self.getAddItemUser.userName != ""
        {
            objRef.userName = self.getAddItemUser.userName ?? ""
        }
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    else
    {
        self.view.makeToast(NSLocalizedString("Plesae login first", comment: ""), duration: 3.0, position: .bottom)
    }
    
   
}
@IBAction func action_seeMoreSaftyTripBtnTapped(_ sender: UIButton)
{
    let objRef:AboutUsVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
    objRef.saftyText = lblSaftyTrips.text!
    self.navigationController?.pushViewController(objRef, animated: true)
}

@IBAction func action_viewOnMapBtnTapped(_ sender: UIButton)
{
    var getAddress  = self.lblAddress.text!
    getAddress  = getAddress.replacingOccurrences(of: " ", with: "+")
    print(getAddress)
    getAddress =  "comgooglemaps://?daddr=" + getAddress + "&directionsmode=driving"
    
    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        UIApplication.shared.openURL(NSURL(string:   getAddress)! as URL)
        
    } else {
        if let urlDestination = URL.init(string: getAddress) {
            UIApplication.shared.open(urlDestination)
        }
        else{
                self.view.makeToast(NSLocalizedString("Could not track location. Please install google maps or chrome to track the address.", comment: ""), duration: 3.0, position: .center)
                    }
    }
}

@IBAction func action_verifiedGoogleBtnTapped(_ sender: UIButton)
{
    
}

@IBAction func action_reportThisItemBtnTapped(_ sender: UIButton)
{
    if sender.currentTitle == NSLocalizedString("Report this item", comment: "")
    {
         viewAlpha.isHidden = false
         viewReport.isHidden = true
         viewReportItem.isHidden = false
         viewBgDeleteItem.isHidden = true
         viewMarkAsSold.isHidden = true
    }
    else
    {
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if self.getAddItemUser != nil
        {
            let addedUserId = self.getAddItemUser.userId
            if userId == addedUserId
            {
                let objRef:ListingEntryVC = self.storyboard?.instantiateViewController(withIdentifier: "ListingEntryVC") as! ListingEntryVC
                objRef.checkScreen = "Edit"
                objRef.getProductItemDetailModel = getProductItemDetailModel
                self.navigationController?.pushViewController(objRef, animated: true)
            }
            else
            {
                
            }
        }
    }
   
}

@IBAction func action_shareThisImg(_ sender: UIButton)
{
    if sender.currentTitle == NSLocalizedString("Share This Image", comment: "")
    {
        viewAlpha.isHidden = true
        viewReport.isHidden = true
        viewReportItem.isHidden = true
        viewBgDeleteItem.isHidden = true
        viewMarkAsSold.isHidden = true
        let someText:AnyObject = lblItemName.text as AnyObject
        let objectsToShare:UIImage = self.imgView.image!
        let sharedObjects:[AnyObject] = [objectsToShare,someText]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter]

        self.present(activityViewController, animated: true, completion: nil)
    }
    else
    {
        viewAlpha.isHidden = false
        viewReport.isHidden = true
        viewReportItem.isHidden = true
        viewBgDeleteItem.isHidden = false
        viewMarkAsSold.isHidden = true
    }
}

@IBAction func btnYes(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewReportItem.isHidden = true
    viewMarkAsSold.isHidden = true
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if userId != ""
    {
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
        }
        else
        {
            ReportedApi()
        }
    }
    else
    {
        self.view.makeToast(NSLocalizedString("Please login first.", comment: ""), duration: 3.0, position: .center)
    }
  
}
@IBAction func action_noBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
}
@IBAction func action_yesDeleteBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if userId != ""
    {
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            DeleteApi()
        }
    }
    else
    {
        self.view.makeToast(NSLocalizedString("Please login first.", comment: ""), duration: 1.0, position: .bottom)
    }
}

@IBAction func action_noDeleteBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
}
@IBAction func action_markAsSoldBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = false
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = false
}

@IBAction func action_markAsSoldYesBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    if userId != ""
    {
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            MarkAsSoldApi()
        }
    }
    else
    {
        self.view.makeToast(NSLocalizedString("Please login first.", comment: ""), duration: 1.0, position: .bottom)
    }
}
@IBAction func action_markAsSoldNoBtnTapped(_ sender: UIButton)
{
    viewAlpha.isHidden = true
    viewReport.isHidden = true
    viewReportItem.isHidden = true
    viewBgDeleteItem.isHidden = true
    viewMarkAsSold.isHidden = true
}
//MARK:- Tableview Delegate and Data Source
func numberOfSections(in tableView: UITableView) -> Int
{
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return 1
}
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    return 140
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
      let cell = tbleSeller.dequeueReusableCell(withIdentifier: "RatingTbleViewCell") as! RatingTbleViewCell
       if getAddItemUser != nil
       {
        if let imgUrl = self.getAddItemUser.userProfilePhoto
        {
         var imageUrl =  BaseViewController.IMG_URL
             imageUrl.append(imgUrl)
         
         cell.imgUser.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
            cell.imgUser.layer.masksToBounds = true
         
        }
        if let imgName = self.getAddItemUser.userName
        {
            cell.lblName.text = imgName
        }
        if let imgName = self.getAddItemUser.addedDate
        {
            cell.lblDate.text = imgName
        }
        if let imgPhone = self.getAddItemUser.userPhone
        {
            cell.lblMobileNum.text =  imgPhone
        }
        if let imgRating = self.getAddItemUser.ratingCount
        {
            cell.lblTotalRating.text =  imgRating
            if let imgTotalRating = self.getAddItemUser.ratingDetails?.totalRatingValue
            {
                cell.viewrating.rating = Double(imgTotalRating) ?? 0.0
            }
            
        }
        if self.getAddItemUser.facebookVerify == "0" && self.getAddItemUser.emailVerify == "0" && self.getAddItemUser.googleVerify == "0" && self.getAddItemUser.phoneVerify == "0"
        {
            cell.widthStackView.constant = 120
        }
        else if (self.getAddItemUser.facebookVerify == "0" || self.getAddItemUser.emailVerify == "0") && (self.getAddItemUser.googleVerify == "0" || self.getAddItemUser.phoneVerify == "0")
        {
            cell.widthStackView.constant = 60
        }
        else if self.getAddItemUser.facebookVerify == "0" || self.getAddItemUser.emailVerify == "0" || self.getAddItemUser.googleVerify == "0" || self.getAddItemUser.phoneVerify == "0"
        {
            cell.widthStackView.constant = 30
        }
        else
        {
            cell.widthStackView.constant = 90
        }
        if self.getAddItemUser.facebookVerify ==  "0"
        {
            cell.btnFacebookVer.isHidden = true
        }
        else
        {
            cell.btnFacebookVer.isHidden  = false
        }
        if self.getAddItemUser.emailVerify  ==  "0"
        {
            cell.btnGmailVer.isHidden = true
        }
        else
        {
            cell.btnGmailVer.isHidden = false
        }
        if self.getAddItemUser.googleVerify  ==  "0"
        {
            cell.btnVerifiedGoogle.isHidden = true
        }
        else
        {
            cell.btnVerifiedGoogle.isHidden = false
        }
        if self.getAddItemUser.phoneVerify  ==  "0"
        {
            cell.btnCallVer.isHidden = true
        }
        else
        {
            cell.btnCallVer.isHidden = false
        }

       }
       cell.selectionStyle = UITableViewCell.SelectionStyle.none
       return cell
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let objRef:UserFollowVC = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowVC") as! UserFollowVC
        objRef.getAddItemUser = getAddItemUser
        objRef.userName = getAddItemUser.userName ?? ""
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
//MARK:- WebServices
func getDetailApi()
{
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }

    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
    WebService.shared.apiGet(url: BaseViewController.API_URL+"rest/items/get/api_key/teampsisthebest/id/\(catId)/login_user_id/\(userId)", parameters:[:]) { (response, error) in
    if error == nil{

    self.getProductItemDetailModel = Mapper<ProductItemDetailModel>().map(JSONObject: response)
        
    if self.getProductItemDetailModel.status != "error"
    {
//            let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
//            if userId != ""
//            {
//                if let object = defaultValues.object(forKey: "History")
//                {
//                    APPDELEGATE.getAllHistryItems = object as? NSMutableArray ?? []
//                }
//                if APPDELEGATE.getAllHistryItems.count != 0
//                {
//                    for i in 0..<APPDELEGATE.getAllHistryItems.count
//                    {
//                        if let tempDic1 : Dictionary = APPDELEGATE.getAllHistryItems[i] as? Dictionary<String,Any>
//                         {
//                            if let getCatName : String = tempDic1["id"] as? String
//                            {
//                                if self.getProductItemDetailModel.id == getCatName
//                                {
//                                    APPDELEGATE.getAllHistryItems.replaceObject(at: i, with: response as Any)
//                                    defaultValues.set(APPDELEGATE.getAllHistryItems, forKey: "History")
//                                    defaultValues.synchronize()
//                                }
////                                else
////                                {
////                                    APPDELEGATE.getAllHistryItems.insert(response as Any, at: APPDELEGATE.getAllHistryItems.count)
////                                    defaultValues.set(APPDELEGATE.getAllHistryItems, forKey: "History")
////
////                                    defaultValues.synchronize()
////                                }
//                            }
//                        }
//                    }
//
//                }
//                else
//                {
//
//                    APPDELEGATE.getAllHistryItems.insert(response as Any, at: APPDELEGATE.getAllHistryItems.count)
//                    defaultValues.set(APPDELEGATE.getAllHistryItems, forKey: "History")
//                    defaultValues.synchronize()
//                }
//
//            }
//

       self.getAddItemDefaultPhoto = self.getProductItemDetailModel.defaultPhoto
       if let imgUrl = self.getAddItemDefaultPhoto.imgPath
       {
        var imageUrl =  BaseViewController.IMG_URL
            imageUrl.append(imgUrl)
        
        self.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
        self.imgView.layer.masksToBounds = true
        
       }
       
        self.lblDesStatic.isHidden = false
        self.lblDetailStatic.isHidden = false
        self.lblSafetyStaic.isHidden = false
        self.lblGettingStaic.isHidden = false
        self.lblMeetUpStatic.isHidden = false
        self.btnSeen.isHidden = false
        self.btnLike.isHidden = false
        self.lblSellerStatic.isHidden = false
       
        self.btnViewOnMap.isHidden = false
        self.btnSeeMoreSafty.isHidden = false
        self.btnPhotos.isHidden = false
        self.iconBeg.isHidden = false
        self.iconCat.isHidden = false
        self.iconInfo.isHidden = false
        self.iconDeal.isHidden = false
        self.iconClock.isHidden = false
        self.iconQuality.isHidden = false
        self.lblItemLocStaic.isHidden = false
        if self.getProductItemDetailModel.paidStatus == "Not yet start"
        {
            self.btnPaidStatus.isHidden = false
            self.btnPaidStatus.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.65)
            self.btnPaidStatus.setTitle(NSLocalizedString("Ads is Not Yet Start", comment: ""), for: .normal)
        }
        else if self.getProductItemDetailModel.paidStatus == "Progress"
        {
            self.btnPaidStatus.isHidden = false
            self.btnPaidStatus.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5)
            self.btnPaidStatus.setTitle(NSLocalizedString("Ads In Progress", comment: ""), for: .normal)
        }
        else
        {
            self.btnPaidStatus.isHidden = true
            self.btnPaidStatus.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5)
            self.btnPaidStatus.setTitle("", for: .normal)
        }
        
        if let title = self.getProductItemDetailModel.title
        {
         self.lblItemName.text = title
        }
        if (self.getProductItemDetailModel.paidStatus ==  "Finished" || self.getProductItemDetailModel.paidStatus == "not_available" ) && self.getProductItemDetailModel.isOwner == "1" && self.getProductItemDetailModel.status == "1"
        {
            self.viewBgPromote.isHidden = false
            self.heightConstBtnPromote.constant = 30
            self.heightConstViewBgPromote.constant = 100
            self.topConstLocationItem.constant = 20
            self.topConstPromoteYourItem.constant = 20
            self.lblPromoteYourItem.isHidden = false
            self.heightPromotingYourItem.constant = 25
        }
        else
        {
            self.viewBgPromote.isHidden = true
            self.heightConstBtnPromote.constant = 0
            self.heightConstViewBgPromote.constant = 0
            self.topConstLocationItem.constant = 0
            self.topConstPromoteYourItem.constant = 0
            self.lblPromoteYourItem.isHidden = true
            self.heightPromotingYourItem.constant = 0
        }
        if let title = self.getProductItemDetailModel.addedDateStr
        {
         self.lblTime.text = title
        }
        if self.getProductItemDetailModel.isFavourited == "0"
        {
            self.btnWishListLike.setImage(#imageLiteral(resourceName: "wishlist"), for: .normal)
        }
        else
        {
            self.btnWishListLike.setImage(#imageLiteral(resourceName: "wishlistApp"), for: .normal)
        }
        if let title = self.getProductItemDetailModel.price
        {
            if let titleName = self.getProductItemDetailModel.itemPriceType?.name
            {
                if let titleCurrency = self.getProductItemDetailModel.itemCurrency?.currencySymbol
                {
                    var totalPrice = Double()
                    totalPrice = Double(title) ?? 0.0
                    self.lblPrice.text = "\(titleCurrency) \(String(format: "%.2f", totalPrice)) (\(titleName))"
                }
              
            }
        }
        if let title = self.getProductItemDetailModel.descriptionField
        {
         self.lblDescription.text = title
        }
        if let title = self.getProductItemDetailModel.dealOption?.name
        {
         self.lblDeal.text = title
        }
        if let title = self.getProductItemDetailModel.category?.catName
        {
            if let titleSub = self.getProductItemDetailModel.subCategory?.name
            {
                self.lblCtaegory.text = "\(title) / \(titleSub)"
            }
      
        }
        if let title = self.getProductItemDetailModel.address
        {
         self.lblAddress.text = title
        }
        if let title = self.getProductItemDetailModel.itemType?.name
        {
         self.lblsell.text = title
        }
        if let title = self.getProductItemDetailModel.favouriteCount
        {
            self.btnLike.setTitle("\(title) \(NSLocalizedString("Likes", comment: ""))", for: .normal)
        }
        if let title = self.getProductItemDetailModel.touchCount
        {
            self.btnSeen.setTitle("\(title) \(NSLocalizedString("Views", comment: ""))", for: .normal)
        }
//            if let title = self.getProductItemDetailModel.brand
//            {
            self.lblQuality.text = "Item can be ordered more than one."
//            }
        if let title = self.getProductItemDetailModel.conditionOfItem?.name
        {
            self.lblOrderItem.text = title
        }
        if self.getProductItemDetailModel.isSoldOut == "0"
        {
            self.btnMarkAsSold.setTitle(NSLocalizedString("Mark as Sold", comment: ""), for: .normal)
            self.btnMarkAsSold.isUserInteractionEnabled = true
        }
        else
        {
            self.btnMarkAsSold.setTitle(NSLocalizedString("Sold", comment: ""), for: .normal)
            self.btnMarkAsSold.isUserInteractionEnabled = false
        }
       
        self.getAddItemUser = self.getProductItemDetailModel.user
        self.phoneNumber = self.getAddItemUser.userPhone ?? ""
        self.tbleSeller.reloadData()
        self.getImagesListApi()
        self.getAboutUsApi()
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            self.heightConstCallChat.constant = 0
            self.btnCall.isHidden = true
            self.btnChat.isHidden = true
            self.btnReportThisItem.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
            self.btnShareThisImg.setTitle(NSLocalizedString("Delete", comment: ""), for: .normal)
            self.btnMarkAsSold.isHidden = false
            self.topConstLblStaticDetail.constant = 0
            self.btnWishListLike.isHidden = true
        }
        else
        {
            self.btnReportThisItem.setTitle(NSLocalizedString("Report this Item", comment: ""), for: .normal)
            self.btnShareThisImg.setTitle(NSLocalizedString("Share This Image", comment: ""), for: .normal)
            self.btnMarkAsSold.isHidden = true
            self.heightConstCallChat.constant = 40
            self.btnCall.isHidden = false
            self.btnChat.isHidden = false
            self.topConstLblStaticDetail.constant = 20
            self.btnWishListLike.isHidden = false
            
        }
      
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getProductItemDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }

  }

}
    
func getDetailListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

      let parametersList:[String : Any] = [
        :
          ]
     //   objHudShow()
        
    let userId = defaultValues.value(forKey: "UserID") ?? ""
      Alamofire.request(BaseViewController.API_URL+"rest/items/get/api_key/teampsisthebest/id/\(catId)/login_user_id/\(userId)", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
    //    self.objHudHide();
            switch response.result {

            case .success (let value):
              
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                    
                }
                else if let dictionary = response.result.value {
                    print("Got a dictionary: \(dictionary)")
                    APPDELEGATE.getAllHistryItems.removeAllObjects()
                    let dict = response.result.value as! NSDictionary? as! [AnyHashable: Any]?
                    let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
                    if userId != ""
                    {
                      
                        if let object = defaultValues.value(forKey: "History")
                        {
                            let arr = self.convertToDictionary(text: "\(object)") as? NSArray
                            for i in 0..<arr!.count {
                                let dict:[String:Any] = arr![i] as! [String : Any]
                                APPDELEGATE.getAllHistryItems.insert(dict, at: APPDELEGATE.getAllHistryItems.count)
                        }
                        }
                        let arrCatId = NSMutableArray()
                        for i in 0..<APPDELEGATE.getAllHistryItems.count
                        {
                            
                            if let tempDic1 : Dictionary = APPDELEGATE.getAllHistryItems[i] as? Dictionary<String,Any>
                             {
                                if let getCatName : String = tempDic1["id"] as? String
                                {
                                    arrCatId.add(getCatName)
                                }
                        }
                        }
                        if APPDELEGATE.getAllHistryItems.count != 0
                        {
                            
                                if arrCatId .contains(self.catId){
                                  let index =  arrCatId.index(of:self.catId )
                                    if APPDELEGATE.getAllHistryItems.count > index {
                                   
                                        APPDELEGATE.getAllHistryItems.replaceObject(at: index, with:dict as Any)
                                        let jsonData = try! JSONSerialization.data(withJSONObject:  APPDELEGATE.getAllHistryItems, options: .prettyPrinted
                                         )
                                         

                                         var  json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
                                        
                                         json = json.replacingOccurrences(of: "\n", with: "")
                                         UserDefaults.standard.setValue(json, forKey: "History")
                                        UserDefaults.standard.synchronize()
                                       break
                                    }

                                    
                                }
                                else{
                                    APPDELEGATE.getAllHistryItems.insert(dict as Any, at: 0)
                                    let jsonData = try! JSONSerialization.data(withJSONObject:  APPDELEGATE.getAllHistryItems, options: .prettyPrinted
                                     )
                                     

                                     var  json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
                                    
                                     json = json.replacingOccurrences(of: "\n", with: "")
                                     UserDefaults.standard.setValue(json, forKey: "History")
                                    UserDefaults.standard.synchronize()
                                    break
                                }

                        }
                        else
                        {
                       
                            APPDELEGATE.getAllHistryItems.insert(dict as Any, at: APPDELEGATE.getAllHistryItems.count)
                            let jsonData = try! JSONSerialization.data(withJSONObject:  APPDELEGATE.getAllHistryItems, options: .prettyPrinted
                             )
                             

                             var  json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
                            
                             json = json.replacingOccurrences(of: "\n", with: "")
                             UserDefaults.standard.setValue(json, forKey: "History")
                            UserDefaults.standard.synchronize()
//                            defaultValues.set(APPDELEGATE.getAllHistryItems, forKey: "History")
//                            defaultValues.synchronize()
                        }
                        
                    }
//                    self.view.makeToast(NSLocalizedString("No image found", comment: ""), duration: 3.0, position: .bottom)
                }
                if APPDELEGATE.getImages.count == 0 && APPDELEGATE.getImages.count == 1
                {
                    self.btnPhotos.setTitle("\(APPDELEGATE.getImages.count) \(NSLocalizedString("Photo", comment: ""))", for: .normal)
                }
                else
                {
                    self.btnPhotos.setTitle("\(APPDELEGATE.getImages.count) \(NSLocalizedString("Photos", comment: ""))", for: .normal)
                }
              
            break

            case .failure:
        //    self.objHudHide();
            // self.refreshControl.endRefreshing()

           // self.blurEffect.isHidden = true

            //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

            break
            }
          }
 }
func getImagesListApi()
 {
        //self.objHudShow()
        //self.blurEffect.isHidden = false

     let headers1 = [
         "Accept": "application/json"
        
     ]


  let parametersList:[String : Any] = [
    :
      ]
 //   objHudShow()
    
  
  Alamofire.request(BaseViewController.API_URL+"rest/images/get/api_key/teampsisthebest/img_parent_id/\(catId)/img_type/item", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
//    self.objHudHide();
        switch response.result {

        case .success (let value):
           APPDELEGATE.getImages.removeAllObjects()
            if let array = response.result.value as? [Any] {
                print("Got an array with \(array.count) objects")
                let resultsArray = value as! [AnyObject]
               
                for i in 0..<resultsArray.count
                {
                    APPDELEGATE.getImages.insert(resultsArray[i], at: APPDELEGATE.getImages.count)
                  
                }
            }
            else if let dictionary = response.result.value as? [AnyHashable: Any] {
                print("Got a dictionary: \(dictionary)")
                //self.view.makeToast(NSLocalizedString("No image found", comment: ""), duration: 3.0, position: .bottom)
            }

            if APPDELEGATE.getImages.count == 0 && APPDELEGATE.getImages.count == 1
            {
                self.btnPhotos.setTitle("\(APPDELEGATE.getImages.count) \(NSLocalizedString("Photo", comment: ""))", for: .normal)
            }
            else
            {
                self.btnPhotos.setTitle("\(APPDELEGATE.getImages.count) \(NSLocalizedString("Photos", comment: ""))", for: .normal)
            }
          
        break

        case .failure:
    //    self.objHudHide();
        // self.refreshControl.endRefreshing()

       // self.blurEffect.isHidden = true

        //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

        break
        }
      }
}
    
func getAboutUsApi()
 {
        //self.objHudShow()
        //self.blurEffect.isHidden = false

     let headers1 = [
         "Accept": "application/json"
        
     ]


  let parametersList:[String : Any] = [
    :
      ]
  //  objHudShow()
    
  
  Alamofire.request(BaseViewController.API_URL+"rest/abouts/get/api_key/teampsisthebest", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
  //  self.objHudHide();
        switch response.result {

        case .success (let value):
           APPDELEGATE.getAboutUs.removeAllObjects()
            if let array = response.result.value as? [Any] {
                print("Got an array with \(array.count) objects")
                let resultsArray = value as! [AnyObject]
               
                for i in 0..<resultsArray.count
                {
                    APPDELEGATE.getAboutUs.insert(resultsArray[i], at: APPDELEGATE.getAboutUs.count)
                  
                }
                if let tempDic1 : Dictionary = APPDELEGATE.getAboutUs[0] as? Dictionary<String,Any>
                 {
                    if let getSliderNameImg : String = tempDic1["safety_tips"] as? String
                    {
                        self.lblSaftyTrips.text = getSliderNameImg
                    }
                }
                     
               
            }
            else if let dictionary = response.result.value as? [AnyHashable: Any] {
                print("Got a dictionary: \(dictionary)")
                self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
            }
           
        break

        case .failure:
    //    self.objHudHide();
        // self.refreshControl.endRefreshing()

       // self.blurEffect.isHidden = true

        //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

        break
        }
      }
}
    
func TouchApi()
{
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    let userId = defaultValues.value(forKey: "UserID") ?? ""
    let params: [String: Any] = ["item_id":catId,"user_id":userId]

    print(params);
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/touches/touch_item/api_key/teampsisthebest", parameters: params) { (response, error) in
    if error == nil{

    self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

    if self.getForgotModel.status == "success"
    {
        print("touches")
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }

  }

}

func ReportedApi()
{
    objHudShow()
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    let userId = defaultValues.value(forKey: "UserID") ?? ""
    let params: [String: Any] = ["item_id":catId,"user_id":userId]

    print(params);
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/itemreports/add/api_key/teampsisthebest", parameters: params) { (response, error) in
    if error == nil{
        self.objHudHide()
    self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

    if self.getForgotModel.status == "success"
    {
        self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }
        self.objHudHide()
  }

}
func LikeUnLikeApi()
{
    
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    let userId = defaultValues.value(forKey: "UserID") ?? ""
    let params: [String: Any] = ["item_id":catId,"user_id":userId]

    print(params);
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/favourites/press/api_key/teampsisthebest", parameters: params) { (response, error) in
    if error == nil{

    self.getProductItemDetailModel = Mapper<ProductItemDetailModel>().map(JSONObject: response)

    if self.getProductItemDetailModel.status != "error"
    {
        self.getDetailApi()
        print("touches")
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getProductItemDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }

  }

}
func DeleteApi()
{
    objHudShow()
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    let userId = defaultValues.value(forKey: "UserID") ?? ""
    let params: [String: Any] = ["item_id":catId]

    print(params);
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/items/item_delete/api_key/teampsisthebest", parameters: params) { (response, error) in
    if error == nil{
        self.objHudHide()
    self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

    if self.getForgotModel.status == "success"
    {
        self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        self.navigationController?.popViewController(animated: true)
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }
        self.objHudHide()
  }

}


func MarkAsSoldApi()
{
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    let userId = defaultValues.value(forKey: "UserID") ?? ""
    let params: [String: Any] = ["item_id":catId,"user_id":userId]

    print(params);
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/items/sold_out_from_itemdetails/api_key/teampsisthebest", parameters: params) { (response, error) in
    if error == nil{

    self.getProductItemDetailModel = Mapper<ProductItemDetailModel>().map(JSONObject: response)

    if self.getProductItemDetailModel.status != "error"
    {
        self.btnMarkAsSold.setTitle(NSLocalizedString("Sold", comment: ""), for: .normal)
        self.btnMarkAsSold.isUserInteractionEnabled = false
        self.view.makeToast(NSLocalizedString(self.getProductItemDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }
    else
    {
        self.view.makeToast(NSLocalizedString(self.getProductItemDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
    }

   }

  }

}
}
