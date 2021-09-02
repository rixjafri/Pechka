//
//  SelectCityVC.swift
//  Pechka
//
//  Created by Neha Saini on 18/05/21.
//

import UIKit
import Alamofire

class SelectCityVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tbleView: UITableView!
    
    //MARK:- Variable Declaration
    var checkScreen = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Custom Methods
    func setInitials()
    {
        getCityApi()
        tbleView.delegate = self
        tbleView.dataSource = self
        searchBar.delegate = self
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
            textfield.placeholder = NSLocalizedString("select city", comment: "")
            textfield.borderStyle = .roundedRect
//            textfield.layer.cornerRadius = 20
            textfield.clipsToBounds = true
           
         }
    }
    
    //MARK:- IBActions
    @IBAction func action_cancelBtnTapped(_ sender: UIButton)
    {
        searchBar.text = ""
        getCityApi()
    }
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_filterBtnTapped(_ sender: UIButton)
    {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text != ""
        {
            getCityApi()
        }
        else
        {
            self.view.makeToast(NSLocalizedString("Please enter text", comment: ""), duration: 3.0, position: .bottom)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        getCityApi()
    }
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return APPDELEGATE.getCity.count
    }
    
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:SelectCityTbleCell = tbleView.dequeueReusableCell(withIdentifier: "SelectCityTbleCell") as! SelectCityTbleCell
        if let tempDic1 : Dictionary = APPDELEGATE.getCity[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["name"] as? String
            {
                cell.lblTitle.text = getCatName
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if checkScreen == "Home"
        {
            defaultValues.set(nil, forKey: "selectCity")
            defaultValues.synchronize()
            if let tempDic1 : Dictionary = APPDELEGATE.getCity[indexPath.row] as? Dictionary<String,Any>
            {
              if let getCityId : String = tempDic1["id"] as? String
               {
                  defaultValues.setValue("\(getCityId)", forKey: "selectCity")
                  if let getCityIdname : String = tempDic1["name"] as? String
                  {
                      defaultValues.setValue("\(getCityIdname)", forKey: "selectCityName")
                  }
                 
                  defaultValues.synchronize()
               }
                if let getCityLat : String = tempDic1["lat"] as? String
                 {
                    defaultValues.setValue("\(getCityLat)", forKey: "USER_LATITUDE")
                 }
                if let getCityLong : String = tempDic1["lng"] as? String
                 {
                    defaultValues.setValue("\(getCityLong)", forKey: "USER_LONGITUDE")
                 }
               
             }
            defaultValues.setValue("\(checkScreen)", forKey: "checkScreen")
            defaultValues.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateCity"), object: nil, userInfo: nil)
            APPDELEGATE.userTabbarCheck(value: 0)
        }
        else if checkScreen == "Listing"
        {
            defaultValues.set(nil, forKey: "selectCityNameListing")
            defaultValues.synchronize()
            defaultValues.setValue("\(checkScreen)", forKey: "checkScreen")
            defaultValues.synchronize()
            if let tempDic1 : Dictionary = APPDELEGATE.getCity[indexPath.row] as? Dictionary<String,Any>
            {
              if let getCityId : String = tempDic1["id"] as? String
               {
                  defaultValues.setValue("\(getCityId)", forKey: "selectCityListing")
                  if let getCityIdname : String = tempDic1["name"] as? String
                  {
                      defaultValues.setValue("\(getCityIdname)", forKey: "selectCityNameListing")
                  }
                 
                  defaultValues.synchronize()
               }
                if let getCityLat : String = tempDic1["lat"] as? String
                 {
                    defaultValues.setValue("\(getCityLat)", forKey: "USER_LATITUDE")
                 }
                if let getCityLong : String = tempDic1["lng"] as? String
                 {
                    defaultValues.setValue("\(getCityLong)", forKey: "USER_LONGITUDE")
                 }
                defaultValues.synchronize()
             }
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            defaultValues.set(nil, forKey: "selectCity")
            defaultValues.synchronize()
            if let tempDic1 : Dictionary = APPDELEGATE.getCity[indexPath.row] as? Dictionary<String,Any>
            {
              if let getCityId : String = tempDic1["id"] as? String
               {
                  defaultValues.setValue("\(getCityId)", forKey: "selectCity")
                  if let getCityIdname : String = tempDic1["name"] as? String
                  {
                      defaultValues.setValue("\(getCityIdname)", forKey: "selectCityName")
                  }
                if let getCityLat : String = tempDic1["lat"] as? String
                 {
                    defaultValues.setValue("\(getCityLat)", forKey: "USER_LATITUDE")
                 }
                if let getCityLong : String = tempDic1["lng"] as? String
                 {
                    defaultValues.setValue("\(getCityLong)", forKey: "USER_LONGITUDE")
                 }
                  defaultValues.synchronize()
               }
             }
            defaultValues.setValue("\(checkScreen)", forKey: "checkScreen")
            defaultValues.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateCity"), object: nil, userInfo: nil)
            APPDELEGATE.userTabbarCheck(value: 0)
        }
       
    
    }
    //MARK:- WebServices
    func getCityApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

        let parametersList:[String : Any] = [
                                           "order_by" : "ordering",
                                           "order_type" : "desc",
                                           "keyword":searchBar.text!
]
        objHudShow()
        let userId = defaultValues.value(forKey: "UserID") ?? ""
       Alamofire.request(BaseViewController.API_URL+"rest/itemlocations/search/api_key/teampsisthebest/limit/30/offset/0/login_user_id/\(userId)", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
                APPDELEGATE.getCity.removeAllObjects()
               
                  if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                       
                        APPDELEGATE.getCity.insert(resultsArray[i], at:  APPDELEGATE.getCity.count)
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .center)
                }
                
              
            
                print("Recent Items:\(APPDELEGATE.getCity)")
                 self.tbleView.reloadData()
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
    
    
}
