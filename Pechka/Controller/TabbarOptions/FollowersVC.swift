//
//  FollowersVC.swift
//  Pechka
//
//  Created by Neha Saini on 27/05/21.
//

import UIKit
import Alamofire

class FollowersVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFollowersListApi()
    }
    //MARK:- Custom Methods
    func setInitials()
    {
        tbleView.delegate = self
        tbleView.dataSource = self
    }
    
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
   
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return APPDELEGATE.getFollowersList.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
      let cell = tbleView.dequeueReusableCell(withIdentifier: "FollowersTbleViewCell") as! FollowersTbleViewCell
        if let tempDic1 : Dictionary = APPDELEGATE.getFollowersList[indexPath.row] as? Dictionary<String,Any>
         {
            if let getCatName : String = tempDic1["added_date"] as? String
            {
                cell.lblJoined.text = "Joined - \(getCatName)"
            }
            if let getCatName : String = tempDic1["user_name"] as? String
            {
                cell.lblName.text = getCatName
            }
            if let getCatName : String = tempDic1["rating_count"] as? String
            {
                cell.viewRating.rating = Double(getCatName) ?? 0.0
            }
            if let getSliderName : String = tempDic1["user_profile_photo"] as? String
            {
               
                    var imageUrl =  BaseViewController.IMG_URL
                        imageUrl.append(getSliderName)
                    
                    cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "catgory"))
                  
                    cell.imgView.layer.masksToBounds = true
            }
        }
       cell.selectionStyle = UITableViewCell.SelectionStyle.none
       return cell
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    //MARK:- web Services
    func getFollowersListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let parametersList:[String : Any] = ["login_user_id" : userId,
                                           "id" : "",
                                           "return_types" : "follower",
                                           "overall_rating" : "",
                                           "user_name" : "",
                                          
                                        
]
        objHudShow()
      
      Alamofire.request(BaseViewController.API_URL+"rest/userfollows/search/api_key/teampsisthebest/offset/0/limit/6", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
        self.objHudHide();
            switch response.result {

            case .success (let value):
               
                APPDELEGATE.getFollowersList.removeAllObjects()
              
                if let array = response.result.value as? [Any] {
                    print("Got an array with \(array.count) objects")
                    let resultsArray = value as! [AnyObject]
                   
                    for i in 0..<resultsArray.count
                    {
                        APPDELEGATE.getFollowersList.insert(resultsArray[i], at:  APPDELEGATE.getFollowersList.count)
                        
                       
                    }
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .center)
                }
                
              
               print("Recent Items:\(APPDELEGATE.getFollowersList)")
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
