//
//  FilterVC.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit

class FilterVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewBgDealOption: UIView!
    @IBOutlet weak var viewBgItemCondition: UIView!
    @IBOutlet weak var viewBgPriceType: UIView!
    @IBOutlet weak var viewBgType: UIView!
    @IBOutlet weak var viewBgSubCategory: UIView!
    @IBOutlet weak var viewBgCategory: UIView!
    @IBOutlet weak var viewBgMaax: UIView!
    @IBOutlet weak var viewBgMin: UIView!
    @IBOutlet weak var tfMax: UITextField!
    @IBOutlet weak var tfMin: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var btnItemCondition: UIButton!
    @IBOutlet weak var btnPriceType: UIButton!
    @IBOutlet weak var btnDealOption: UIButton!
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        clearSearchData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
        setDropDownData()
    }
    
    func clearSearchData()  {
        SEARCH_CATEGORY = ""
        SEARCH_CATEGORY_ID = ""
        SEARCH_SUB_CATEGORY_ID = ""
        SEARCH_ITEM_TYPE_ID = ""
        SEARCH_ITEM_CONDITION_ID = ""
        SEARCH_ITEM_PRICE_ID = ""
        SEARCH_ITEM_DEAL_ID = ""
        SEARCH_SUB_CATEGORY = ""
        SEARCH_ITEM_TYPE = ""
        SEARCH_ITEM_CONDITION = ""
        SEARCH_ITEM_PRICE_TYPE = ""
        SEARCH_ITEM_DEAL_OPTION = ""
        SEARCH_SELECTED_ITEM = ""
        OPTION_TYPE = 0
    }
    //MARK:- Custom Methods
    func setDropDownData(){
            
            if  SEARCH_CATEGORY.count>0  {
                
                    btnCategory.setTitle(SEARCH_CATEGORY, for: .normal)
                    

            }
              if SEARCH_SUB_CATEGORY.count>0 {
               
                btnSubCategory.setTitle(SEARCH_SUB_CATEGORY, for: .normal)
                
            }
              if  SEARCH_ITEM_TYPE.count>0 {
                btnType.setTitle(SEARCH_ITEM_TYPE, for: .normal)
            }
              if  SEARCH_ITEM_CONDITION.count>0 {
                btnItemCondition.setTitle(SEARCH_ITEM_CONDITION, for: .normal)
            }
              if  SEARCH_ITEM_PRICE_TYPE.count>0 {
                btnPriceType.setTitle(SEARCH_ITEM_PRICE_TYPE, for: .normal)
            }
              if  SEARCH_ITEM_DEAL_OPTION.count>0 {
                btnDealOption.setTitle(SEARCH_ITEM_DEAL_OPTION, for: .normal)
            }

            
        }
    func setInitials()
    {
        btnFilter.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnFilter.layer.cornerRadius = 15
        btnFilter.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        viewBgCategory.layer.cornerRadius = 5
        viewBgCategory.layer.borderWidth = 1
        viewBgCategory.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgSubCategory.layer.cornerRadius = 5
        viewBgSubCategory.layer.borderWidth = 1
        viewBgSubCategory.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgDealOption.layer.cornerRadius = 5
        viewBgDealOption.layer.borderWidth = 1
        viewBgDealOption.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgItemCondition.layer.cornerRadius = 5
        viewBgItemCondition.layer.borderWidth = 1
        viewBgItemCondition.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgPriceType.layer.cornerRadius = 5
        viewBgPriceType.layer.borderWidth = 1
        viewBgPriceType.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        viewBgType.layer.cornerRadius = 5
        viewBgType.layer.borderWidth = 1
        viewBgType.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
           
            textfield.borderStyle = .none
            textfield.layer.cornerRadius = 20
            textfield.clipsToBounds = true
            
         }
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_filterBtnTapped(_ sender: UIButton)
    {
        
        if tfMin.text?.count ?? 0 > 0 && tfMax.text?.count ?? 0 > 0 {
            let minRange = Float(tfMin.text ?? "")
            let maxRange = Float(tfMax.text ?? "")
            
            if maxRange! <= minRange!{
                self.view.makeToast(NSLocalizedString("Please enter valid price range", comment: ""), duration: 3.0, position: .bottom)
                return
            }
            else
            {
                SEARCH_MIN_RANGE = tfMin.text ?? ""
                SEARCH_MAX_RANGE = tfMax.text ?? ""
                SEARCH_TITLE = searchBar.text ?? ""
               
                
               
                
                let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
                objRef.screenCheck = "search"
                objRef.searchDict = ["searchterm":searchBar.text ?? "" ,"cat_id":SEARCH_CATEGORY_ID,"sub_cat_id":SEARCH_SUB_CATEGORY_ID,"order_type":"","order_by":"","item_type_id":SEARCH_ITEM_TYPE_ID,"item_price_type_id":SEARCH_ITEM_PRICE_ID,"condition_of_item_id":SEARCH_ITEM_CONDITION_ID,"deal_option_id":SEARCH_ITEM_DEAL_ID,"max_price":tfMax.text ?? "" ,"min_price":tfMin.text ?? "","login_user_id":defaultValues.value(forKey: "UserID") as? String ?? ""]
             
                
                self.navigationController?.pushViewController(objRef, animated: true)
            }
        }
        else
        {
           
        }
        
  
       

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
    
    @IBAction func action_itemConditionBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
    OPTION_TYPE = 4
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_priceTYpeBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 5
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_priceTypeBtnTapped(_ sender: UIButton)
    {
        
    }
    @IBAction func action_dealOptionBtnTapped(_ sender: UIButton)
    {
        let objRef:DropDownListingVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownListingVC") as! DropDownListingVC
        OPTION_TYPE = 6
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_sortByBtnTapped(_ sender: UIButton)
    {
        
    }
 
}
