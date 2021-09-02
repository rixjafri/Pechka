//
//  PendingItemsVC.swift
//  Pechka
//
//  Created by Neha Saini on 19/05/21.
//

import UIKit

class PendingItemsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlets
    @IBOutlet weak var btnTitl: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    //MARK:- Variable Declaration
    var checkScreen = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
        if checkScreen == "Follow"
        {
            btnTitl.setTitle(NSLocalizedString("Listing", comment: ""), for: .normal)
        }
        else if checkScreen == "Items from your followers"
        {
            btnTitl.setTitle(NSLocalizedString("Items from your followers", comment: ""), for: .normal)
        }
        else
        {
            btnTitl.setTitle(NSLocalizedString(checkScreen, comment: ""), for: .normal)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Custom Method
    func setInitials()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.register(UINib(nibName: "ItemPaidCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemPaidCollectionViewCell")
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Collection View data source and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if checkScreen == "Follow"
        {
            return APPDELEGATE.getSellerList.count
        }
        else if checkScreen == "Items from your followers"
        {
            return APPDELEGATE.getFollowersItems.count
        }
        else if checkScreen == "Listing"
        {
            return APPDELEGATE.getPendingList.count
        }
        else if checkScreen == "All Listing"
        {
            return APPDELEGATE.getApproveList.count
        }
        else if checkScreen == "Disabled"
        {
            return APPDELEGATE.getDisabledList.count
        }
        else if checkScreen == "Rejected"
        {
            return  APPDELEGATE.getRejectedList.count
        }
        else if checkScreen == "Paid Ad"
        {
            return APPDELEGATE.getPaidAdList.count
        }
        else
        {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
      if checkScreen == "Follow"
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
        else if checkScreen == "Items from your followers"
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
            cell.btnLike.tag = indexPath.row
            cell.btnItemTap.tag = indexPath.row
            cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
            cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary = APPDELEGATE.getFollowersItems[indexPath.row] as? Dictionary<String,Any>
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
        else if checkScreen == "Listing"
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
        else if checkScreen == "All Listing"
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
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
        else if checkScreen == "Disabled"
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
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
        else if checkScreen == "Rejected"
        {
            let cell:RecentPopulerItemsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPopulerItemsCollectionViewCell", for: indexPath) as! RecentPopulerItemsCollectionViewCell
            cell.btnLike.tag = indexPath.row
            cell.btnItemTap.tag = indexPath.row
            cell.btnLike.setImage(UIImage(named: "grayHeart"), for: .normal)
            cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
            if let tempDic1 : Dictionary = APPDELEGATE.getRejectedList[indexPath.row] as? Dictionary<String,Any>
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
        else
        {
            let cell:ItemPaidCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemPaidCollectionViewCell", for: indexPath) as! ItemPaidCollectionViewCell
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
                        if let tempDicItemCurrency : Dictionary = tempDic1["item_currency"] as? Dictionary<String,Any>
                         {
                            if let getCatpriceCurrency : String = tempDicItemCurrency["currency_symbol"] as? String
                            {
                                cell.lblPrice.text = "\(getCatpriceCurrency) \(getCatName)"
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
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
     {

     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let yourWidth = collectionView.frame.width/2
        // let yourHeight = yourWidth
        if checkScreen == "Paid Ad"
        {
            return  CGSize(width: yourWidth, height:450)
        }
        else
        {
            return  CGSize(width: yourWidth, height:355)
        }
    }

     func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
     {
        if checkScreen == "Paid Ad"
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if checkScreen == "Follow"
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
        else if checkScreen == "Items from your followers"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getFollowersItems[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["id"] as? String
                {
                    objRef.catId = getId
                   
                }
                
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else if checkScreen == "Listing"
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
        else if checkScreen == "All Listing"
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
        else if checkScreen == "Disabled"
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
        else if checkScreen == "Rejected"
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
        else if checkScreen == "Paid Ad"
        {
            let objRef:ProductDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            if let tempDic1 : Dictionary = APPDELEGATE.getPaidAdList[indexPath.row] as? Dictionary<String,Any>
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

    
}
