//
//  BannerVC.swift
//  Pechka
//
//  Created by Neha Saini on 26/05/21.
//

import UIKit
import Alamofire

class BannerVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    //MARK:- IBOutlets
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var lblTitle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK:- Variable Declaration
    var checkScreen = ""
    var indexTag = Int()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblTitle.setTitle(NSLocalizedString(checkScreen, comment: ""), for: .normal)
        if checkScreen == "Notification Detail"
        {
            if let tempDic1 : Dictionary = APPDELEGATE.getNotificationList[indexTag] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["is_read"] as? String
                {
                    if getCatName == "0"
                    {
                        if let getNotiId : String = tempDic1["id"] as? String
                        {
                            let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
                            let deviceToken = "\(defaultValues.value(forKey: "DeviceID") ?? "")"
                            notificationReadApi(getNotiId:getNotiId, getUserId:userId, getDeviceToken:deviceToken)
                        }
                       
                    }
                }
            }
        }
        
    }
    
    //MARK:- Custom Method
    func setInitials()
    {
        tbleView.delegate = self
        tbleView.dataSource = self
    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if checkScreen == "Blog Detail"
        {
            return APPDELEGATE.getBannersItems.count
        }
        else
        {
            return APPDELEGATE.getNotificationList.count
        }
       
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if checkScreen == "Blog Detail"
        {
            let cell:BannerBlogTbleViewCell = tbleView.dequeueReusableCell(withIdentifier: "BannerBlogTbleViewCell") as! BannerBlogTbleViewCell
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
                    if let title:String = tempDic1["name"] as? String
                    {
                        cell.lblTitle.text = title
                    }
                    if let getCattitle: String = tempDic1["description"] as? String
                    {
                        let newString5 = getCattitle.replacingOccurrences(of: "<p>", with: "", options: .literal, range: nil)
                        let newString6 = newString5.replacingOccurrences(of: "&nbsp;</p>", with: "", options: .literal, range: nil)
                       
                        cell.lblSubTitle.text = newString6
                    }
                }
               
                }
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tbleView.dequeueReusableCell(withIdentifier: "BannerBlogTbleViewCell") as! BannerBlogTbleViewCell
            if let tempDic1 : Dictionary = APPDELEGATE.getNotificationList[indexPath.row] as? Dictionary<String,Any>
             {
                if let getCatName : String = tempDic1["added_date"] as? String
                {
                    cell.lbltime.text = getCatName
                }
                if let getCatName : String = tempDic1["message"] as? String
                {
                    cell.lblTitle.text = getCatName
                }
                
                if let tempDicImg : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                            cell.imgView.layer.masksToBounds = true
                           
                        }
                       else
                        {
                            cell.imgView.image = UIImage(named: "iconDe")
                        }
                }
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
       
    }
    
   
   //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Web Services
    func notificationReadApi(getNotiId:String,getUserId:String,getDeviceToken:String)
    {
           //self.objHudShow()
           //self.blurEffect.isHidden = false

        let headers1 = [
            "Accept": "application/json"
           
        ]
   
       
       let parametersList:[String : Any] = ["noti_id":getNotiId,
                                            "user_id":getUserId,
                                            "device_token":getDeviceToken
       
         ]
    //   objHudShow()
     Alamofire.request(BaseViewController.API_URL+"rest/notis/is_read/api_key/teampsisthebest", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
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
}
