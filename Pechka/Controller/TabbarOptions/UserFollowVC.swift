//
//  UserFollowVC.swift
//  Pechka
//
//  Created by Neha Saini on 20/05/21.
//

import UIKit
import ObjectMapper
import Alamofire

class UserFollowVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlets
    @IBOutlet weak var viewBgSeller: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var lblJoinnedDate: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblName: UIButton!
    @IBOutlet weak var btnVerifiedGoogle: UIButton!
    @IBOutlet weak var btnFacebookIc: UIButton!
    @IBOutlet weak var btnGmailVer: UIButton!
    @IBOutlet weak var btnCallVer: UIButton!
    
    //MARK:- Variable Declaration
    var getAddItemUser:AddItemUser!
    var getProductItemDetailModel:ProductItemDetailModel!
    var userName = ""
    var followUserId = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        UserFollowApi()
        getSellerItemsListApi()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Custom Methods
   func setInitials()
   {
     lblName.setTitle(userName, for: .normal)
     tbleView.delegate = self
     tbleView.dataSource = self
     collectionView.delegate = self
     collectionView.dataSource = self
   
   }
    
   //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_viewAllBtnTapped(_ sender: UIButton)
    {
        let objRef:PendingItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingItemsVC") as! PendingItemsVC
        objRef.checkScreen = "Follow"
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    @IBAction func action_followBtnTapped(_ sender: UIButton)
    {
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            self.view.makeToast(NSLocalizedString("You can not follow yourself.", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
            if sender.currentTitle == NSLocalizedString("Follow", comment: "")
            {
                sender.setTitle(NSLocalizedString("UnFollow", comment: ""), for: .normal)
            }
            else
            {
                sender.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
            }
            FollowUnFollowApi()
        }
       
    }
    
    //MARK:- Collection View data source and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         return APPDELEGATE.getSellerList.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
     let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
        cell.btnLike.tag = indexPath.row
        cell.btnItemTap.tag = indexPath.row
        cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        if let tempDic1 : Dictionary = APPDELEGATE.getSellerList[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date_str"] as? String
            {
                cell.lblTime.text = getCatName
            }
            if let title:String = tempDic1["favourite_count"] as? String
            {
                cell.btnLike.setTitle(title, for: .normal)
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



     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
     {

     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let yourWidth = collectionView.frame.width/2
        // let yourHeight = yourWidth

      return  CGSize(width: yourWidth, height:360)
      
    
    }

     func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
     {
       return 360
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
        let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        if let tempDic1 : Dictionary = APPDELEGATE.getSellerList[indexPath.row] as? Dictionary<String,Any>
         {
            if let getId : String = tempDic1["id"] as? String
            {
                objRef.catId = getId
               
            }
            
        }
       
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return 1
    }
    
    
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
   
        return 140
 
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
      let cell = tbleView.dequeueReusableCell(withIdentifier: "UserFollowTbleViewCell") as! UserFollowTbleViewCell
      cell.btnFollow.tag = indexPath.row
       if getAddItemUser != nil
       {
        if let imgUrl = self.getAddItemUser.userProfilePhoto
        {
         var imageUrl =  BaseViewController.IMG_URL
             imageUrl.append(imgUrl)
         
         cell.imgUser.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "userIcon"))
            cell.imgUser.layer.masksToBounds = true
         
        }
        
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        let addedUserId = self.getAddItemUser.userId
        if userId == addedUserId
        {
            cell.btnFollow.isHidden = true
        }
        else
        {
            cell.btnFollow.isHidden = false
        }
        if self.getAddItemUser.isFollowed == "0"
        {
            cell.btnFollow.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
        }
        else
        {
            cell.btnFollow.setTitle(NSLocalizedString("UnFollow", comment: ""), for: .normal)
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
            cell.viewrating.rating = Double(imgRating) ?? 0.0
        }
        if self.getAddItemUser.facebookVerify ==  "0"
        {
            self.btnFacebookIc.isHidden = true
        }
        else
        {
            self.btnFacebookIc.isHidden = false
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
           self.btnVerifiedGoogle.isHidden = true
        }
        else
        {
            self.btnVerifiedGoogle.isHidden = false
        }
        if self.getAddItemUser.phoneVerify  ==  "0"
        {
            self.btnCallVer.isHidden = true
        }
        else
        {
            self.btnCallVer.isHidden = false
        }

       }
       cell.selectionStyle = UITableViewCell.SelectionStyle.none
       return cell
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
     
    }
   
    //MARK:- Web Services
    func getSellerItemsListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
        if followUserId == ""
        {
         followUserId = self.getAddItemUser.userId ?? ""
        }
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
                                           "added_user_id" : followUserId,
                                           "is_paid" : "paid_item_first",
                                           "status" : "1"
]
        objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/items/search/api_key/teampsisthebest/offset/0/limit/6/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getSellerList.removeAllObjects()
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getSellerList.insert(resultsArray[i], at:  APPDELEGATE.getSellerList.count)
                       
                    }
                    self.viewBgSeller.isHidden = false
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                    self.viewBgSeller.isHidden = true
                }
                
              
               print("Recent Items:\(APPDELEGATE.getSellerList)")
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
    
    func FollowUnFollowApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        if followUserId == ""
        {
         followUserId = self.getAddItemUser.userId ?? ""
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["followed_user_id":followUserId,"user_id":userId]

        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/userfollows/add_follow/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{

        self.getProductItemDetailModel = Mapper<ProductItemDetailModel>().map(JSONObject: response)

        if self.getProductItemDetailModel.status != "error"
        {
            print("touches")
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getProductItemDetailModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }

       }

      }

    }
    
    func UserFollowApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        if followUserId == ""
        {
         followUserId = self.getAddItemUser.userId ?? ""
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["id":followUserId,"login_user_id":userId]

        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/userfollows/search/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{

        self.getAddItemUser = Mapper<AddItemUser>().map(JSONObject: response)

        if self.getAddItemUser.status != "error"
        {
           
            self.lblJoinnedDate.text = "Joined - \(self.getAddItemUser.addedDate ?? "")"
            self.tbleView.reloadData()
            print("touches")
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddItemUser.message ?? "", comment: ""), duration: 1.0, position: .center)
        }

       }

      }

    }
    
}
