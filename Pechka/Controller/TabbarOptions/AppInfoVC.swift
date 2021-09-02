//
//  AppInfoVC.swift
//  Pechka
//
//  Created by Neha Saini on 27/05/21.
//

import UIKit
import Alamofire

class AppInfoVC: BaseViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnYoutube: UIButton!
    @IBOutlet weak var btnPinterest: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnGooglePlus: UIButton!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var imgAppIcon: UIImageView!
    
    //MARK:- Variable Declaration
    var phone = ""
    var browser = ""
    var youtube = ""
    var facebook = ""
    var googlePlus = ""
    var twitter = ""
    var instagram = ""
    var pinterest = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAboutUsApi()
    }
    
    private func callNumber(phoneNumber: String) {
       guard let url = URL(string: "telprompt://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) else {
           return
       }
       UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_websiteBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: browser) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func action_phoneBtnTapped(_ sender: UIButton)
    {
        let getPhoneNo = self.phone.replacingOccurrences(of: " ", with: "")
        let trimmedPhoneNo = getPhoneNo.trimmingCharacters(in: .whitespacesAndNewlines)
        self.phone = trimmedPhoneNo
        
        if self.phone == ""
        {
           self.view.makeToast(NSLocalizedString("Contact number not available.", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
           self.callNumber(phoneNumber: phone)
        }
    }
    @IBAction func action_facebookBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: facebook) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func action_googlePlusBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: googlePlus) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func action_twitterBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: twitter) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func action_instagramBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: instagram) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func action_youtubeBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: youtube) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func action_pinterestBtnTapped(_ sender: UIButton)
    {
        if let url = URL(string: pinterest) {
            UIApplication.shared.open(url)
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
                        if let getSliderNameImg : String = tempDic1["about_description"] as? String
                        {
                            self.txtView.text = getSliderNameImg
                        }
                        if let getPhone : String = tempDic1["about_phone"] as? String
                        {
                            self.btnPhone.setTitle(getPhone, for: .normal)
                            self.phone = getPhone
                        }
                        if let getWebsite : String = tempDic1["about_website"] as? String
                        {
                            self.btnWebsite.setTitle(getWebsite, for: .normal)
                            self.browser = getWebsite
                        }
                        if let getFacebook : String = tempDic1["facebook"] as? String
                        {
                            self.btnFacebook.setTitle(getFacebook, for: .normal)
                            self.facebook = getFacebook
                        }
                        if let getGooglePlus : String = tempDic1["google_plus"] as? String
                        {
                            self.btnGooglePlus.setTitle(getGooglePlus, for: .normal)
                            self.googlePlus = getGooglePlus
                        }
                        if let getInstagram : String = tempDic1["instagram"] as? String
                        {
                            self.btnInstagram.setTitle(getInstagram, for: .normal)
                            self.instagram = getInstagram
                        }
                        if let getPinterest : String = tempDic1["pinterest"] as? String
                        {
                            self.btnPinterest.setTitle(getPinterest, for: .normal)
                            self.pinterest = getPinterest
                        }
                        if let getTwitter : String = tempDic1["twitter"] as? String
                        {
                            self.btnTwitter.setTitle(getTwitter, for: .normal)
                            self.twitter = getTwitter
                        }
                        if let getYoutube : String = tempDic1["youtube"] as? String
                        {
                            self.btnYoutube.setTitle(getYoutube, for: .normal)
                            self.youtube = getYoutube
                        }
                    }
                         
                   
                }
                else if let dictionary = response.result.value as? [AnyHashable: Any] {
                    print("Got a dictionary: \(dictionary)")
                    self.view.makeToast(NSLocalizedString("No data found", comment: ""), duration: 3.0, position: .bottom)
                }
                print(APPDELEGATE.getAboutUs)
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
}
