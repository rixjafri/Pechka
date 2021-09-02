//
//  SignUpWithPhoneVC.swift
//  Pechka
//
//  Created by Neha Saini on 13/05/21.
//

import UIKit
import ObjectMapper

class SignUpWithPhoneVC:BaseViewController,UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imgMobileNum: UIImageView!
    @IBOutlet weak var tfMobileNum: UITextField!
    @IBOutlet weak var lineMobileNum: UILabel!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var imgUserName: UIImageView!
    @IBOutlet weak var lineUserName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    var valueTf = 0
    var getAddUserModel:AddUserModel!
    var getAddUserRatingDetail:AddUserRatingDetail!
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Custom Method
    func setInitials()
    {
        btnRegister.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnRegister.layer.cornerRadius = 15
        btnRegister.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        tfUserName.delegate = self
        tfMobileNum.delegate = self
    }
    
    func usernameValidation() {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
           lineUserName.backgroundColor = BaseViewController.appColor
           imgUserName.isHidden = true

        }
        else
        {
            lineUserName.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgUserName.isHidden = false
        }
    }
    
    func validateMobile() {
        if Helper.shared.isFieldEmpty(field: tfMobileNum.text!)
         {
            lineMobileNum.backgroundColor = BaseViewController.appColor
            imgMobileNum.isHidden = true
        }
        else
         {
           
            if tfMobileNum.text!.count >= 9
            {
                lineMobileNum.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
                imgMobileNum.isHidden = false
            }
            else
            {
                lineMobileNum.backgroundColor = BaseViewController.appColor
                imgMobileNum.isHidden = true
            }
        }
        
    }
    
    //MARK:- UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        if textField == tfUserName && range.length == 1 && range.location == 0 {
            lineUserName.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgUserName.isHidden = true

        }
      
        else if textField == tfMobileNum && range.length == 1 && range.location == 0 {

            lineMobileNum.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgMobileNum.isHidden = true

        }
        else if textField == tfUserName {
            usernameValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }
        else if textField == tfMobileNum{
            if  tfMobileNum.text != ""
            {
                validateMobile()
            }
        }
        
       
       
        return true
    }
    
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == tfUserName && tfUserName.text?.count == 0 {
        lineUserName.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
        imgUserName.isHidden = true

    }
   else if textField == tfMobileNum && tfMobileNum.text?.count == 0 && tfMobileNum.text!.count < 10 {

           lineMobileNum.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
           imgMobileNum.isHidden = true

        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
//        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == tfUserName
        {
            tfMobileNum.becomeFirstResponder()
        }
        else if textField ==  tfMobileNum
        {
            tfMobileNum.resignFirstResponder()
        }
       
        
        return true
    }
    //MARK:- IBActions
    @IBAction func action_registerBtnTapped(_ sender: UIButton)
    {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
          usernameValidation()
        }
        else if Helper.shared.isFieldEmpty(field: tfMobileNum.text!)
        {
           validateMobile()
        }
        else if tfMobileNum.text!.count < 10
        {
            validateMobile()
        }
        else
        {
            SignUpWithPhoneApi(getUserName:tfUserName.text!,getUserPhone:tfMobileNum.text!)
        }
    }
    
    @IBAction func action_signInBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- WebServices
    func SignUpWithPhoneApi(getUserName:String,getUserPhone:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        
        let params: [String: Any] = ["user_name":getUserName,"phone_id":deviceID,"user_phone":"\(getUserPhone)","device_token":"nodevicetoken"]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/phone_register/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
            
        if self.getAddUserModel.status != "error"
        {
            if let data = self.getAddUserModel.ratingDetails
            {
                self.getAddUserRatingDetail = data
//                APPDELEGATE.getAddUserModel = self.getAddUserModel
//                APPDELEGATE.getAddUserRatingDetail = self.getAddUserRatingDetail
//                defaultValues.setValue(self.getAddUserModel.userId, forKey: "UserID")
//
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.userName ?? "", forKey: "userName")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.userProfilePhoto ?? "", forKey: "profile")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.addedDate ?? "", forKey: "addedDate")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.ratingCount ?? "", forKey: "ratingCount")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.followingCount ?? "", forKey: "followingCount")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.followerCount ?? "", forKey: "followerCount")
//                defaultValues.setValue(APPDELEGATE.getAddUserModel.userEmail ?? "", forKey: "Email")
//                defaultValues.synchronize()
                let objRef:ConfirmationCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmationCodeVC") as! ConfirmationCodeVC
                objRef.userEmail = self.tfMobileNum.text!
                objRef.checkScreen = "Mobile"
                self.navigationController?.pushViewController(objRef, animated: true)
            }
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getAddUserModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
}
