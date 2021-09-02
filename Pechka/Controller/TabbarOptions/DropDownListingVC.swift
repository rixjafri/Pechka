//
//  DropDownListingVC.swift
//  Pechka
//
//  Created by USER on 18/05/21.
//

import UIKit
import Alamofire
import ObjectMapper

class DropDownListingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbleView: UITableView!
    
    
    @IBOutlet weak var btnTitle: UIButton!
    
    
    
    
    var catId = ""
    var selectStr = ""
    var checkScreen = ""
    var titleName = ""
    //MARK:- Variable Declaration
    
    var arrListing = NSMutableArray()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
        tbleView.delegate = self
        tbleView.dataSource = self
        if OPTION_TYPE == 1  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_CATEGORY, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/categories/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_CATEGORY
        }
        else if OPTION_TYPE == 2  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_SUB_CATEGORY, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/subcategories/get/api_key/teampsisthebest/cat_id/\(catId)/limit/30/offset/0")
            selectStr = SEARCH_SUB_CATEGORY
        }
        else   if OPTION_TYPE == 3  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_ITEM_TYPE, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/itemtypes/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_ITEM_TYPE
        }
        
        else   if OPTION_TYPE == 4  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_ITEM_CONDITION, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/conditions/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_ITEM_CONDITION
        }
        
        else   if OPTION_TYPE == 5  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_ITEM_PRICE_TYPE, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/pricetypes/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_ITEM_PRICE_TYPE
        }
        else   if OPTION_TYPE == 6  {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_ITEM_DEAL_OPTION, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/options/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_ITEM_DEAL_OPTION
        }
        else if  OPTION_TYPE == 7
        {
            btnTitle.setTitle(NSLocalizedString(CHOOSE_CURRENCY_OPTION, comment: ""), for: .normal)
            getListFromAPI(apiName: "rest/currencies/get/api_key/teampsisthebest/limit/30/offset/0")
            selectStr = SEARCH_CURRENCY
        }
        
        
    }
    
    //MARK:- IBActions
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrListing.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tbleView.dequeueReusableCell(withIdentifier: "LanguageTbleViewCell") as! LanguageTbleViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.btnSelectUnSelect.tag = indexPath.row
        cell.isUserInteractionEnabled = true
        if let tempDic1 : Dictionary = arrListing[indexPath.row] as? Dictionary<String,Any>
        {
            if OPTION_TYPE == 1 {
                if let getCatName : String = tempDic1["cat_name"] as? String
                {
                    cell.lblTitle.text = getCatName
                   
                }
                
            }
            else if OPTION_TYPE == 7
            {
               
                if let getCatName : String = tempDic1["currency_symbol"] as? String
                {
                    cell.lblTitle.text = getCatName
                   
                }
            }
           
            else{
                if let getCatName : String = tempDic1["name"] as? String
                {
                    cell.lblTitle.text = getCatName
                   
                }
            }
        }
        if cell.lblTitle.text == selectStr
        {
            
            cell.imgCheck.isHidden = false
        }
        else
        {
            
            cell.imgCheck.isHidden = true
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tempDic1 : Dictionary = arrListing[indexPath.row] as? Dictionary<String,Any>
        {
        if OPTION_TYPE == 1 {
            if let getCatName : String = tempDic1["cat_name"] as? String
            {
                SEARCH_CATEGORY = getCatName
            }
            if let getId : String = tempDic1["cat_id"] as? String
            {
                SEARCH_CATEGORY_ID = getId
            }
         
        }
          
        else{
            if let getCatName : String = tempDic1["name"] as? String
            {
                
               
                  if OPTION_TYPE == 2{
                     
                          SEARCH_SUB_CATEGORY = getCatName
                    if let getId : String = tempDic1["id"] as? String
                    {
                        SEARCH_SUB_CATEGORY_ID = getId
                    }
                   
   
                  }
              else    if OPTION_TYPE == 3 {
                    SEARCH_ITEM_TYPE = getCatName
                if let getId : String = tempDic1["id"] as? String
                {
                    SEARCH_ITEM_TYPE_ID = getId
                }
                
                }
                else  if OPTION_TYPE == 4 {
                    SEARCH_ITEM_CONDITION = getCatName
                    if let getId : String = tempDic1["id"] as? String
                    {
                        SEARCH_ITEM_CONDITION_ID = getId
                    }
                }
                else  if OPTION_TYPE == 5 {
                    SEARCH_ITEM_PRICE_TYPE = getCatName
                    if let getId : String = tempDic1["id"] as? String
                    {
                        SEARCH_ITEM_PRICE_ID = getId
                    }
                }
                else  if OPTION_TYPE == 6 {
                    SEARCH_ITEM_DEAL_OPTION = getCatName
                    if let getId : String = tempDic1["id"] as? String
                    {
                        SEARCH_ITEM_DEAL_ID = getId
                    }
                }
               
 
            }
            else
            {
               if OPTION_TYPE == 7 {
                    if let getCatNameCurrency : String = tempDic1["currency_symbol"] as? String
                    {
                        SEARCH_CURRENCY = getCatNameCurrency
                    }
                   
                    if let getId : String = tempDic1["id"] as? String
                    {
                        SEARCH_CURRENCY_ID = getId
                    }
                }
            }
        }
        }
        if checkScreen == "Recent"
        {
          if SEARCH_CATEGORY == "" {
              self.view.makeToast(NSLocalizedString("Please select category first", comment: ""), duration: 3.0, position: .bottom)
          }
          else{
          let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
          OPTION_TYPE = 2
          objRef.catId = SEARCH_CATEGORY_ID
          objRef.checkScreen = "subCategory"
          objRef.titleName = titleName
          self.navigationController?.pushViewController(objRef, animated: true)
          }
        }
        else if checkScreen == "subCategory"
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is RecentProductsItemsVC {
                    defaultValues.setValue("subCategory", forKey: "subCategory")
                    defaultValues.setValue(titleName, forKey: "TypeOfScreen")
                    defaultValues.synchronize()
                    self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    
    //    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    //    {
    //
    //        if optionType == 1 {
    //            searchCategory = "sdfsf"
    //        }
    //        self.navigationController?.popViewController(animated: true)
    //     }
    
    //MARK:- Cell Method
    @IBAction func action_languageBtnTapped(_ sender: UIButton)
    {
        
       
    }
    
    //MARK:- Web Services
    func getListFromAPI(apiName: String)
    {
        //self.objHudShow()
        //self.blurEffect.isHidden = false
        
        let headers1 = [
            "Accept": "application/json"
            
        ]
        
        
        let parametersList:[String : Any] = [
            :
        ]
        
        Alamofire.request(BaseViewController.API_URL+apiName, method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in
            
            switch response.result {
            
            case .success (let value):
                if (value as AnyObject).count != 0
                {
                    let resultsArray = value as? [AnyObject]
                    self.arrListing.removeAllObjects()
                    if resultsArray?.count != 0 && resultsArray != nil
                    {
                        for i in 0..<resultsArray!.count
                        {
                            self.arrListing.insert(resultsArray?[i] as Any, at: self.arrListing.count)
                        }
                    }
                }
                
                
                
                print(self.arrListing)
                self.tbleView.reloadData()
                
                
                break
                
            case .failure:
                //self.objHudHide();
                // self.refreshControl.endRefreshing()
                
                // self.blurEffect.isHidden = true
                
                self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                
                break
            }
        }
    }
}
