//
//  ConfirmationCodeVC.swift
//  Pechka
//
//  Created by Neha Saini on 14/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import FirebaseAuth

class ConfirmationCodeVC: BaseViewController,UITextFieldDelegate {

    
    //MARK:- IBoutlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tfSix: UITextField!
    @IBOutlet weak var tfFifth: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnBell: UIButton!
    @IBOutlet weak var tfOne: UITextField!
    @IBOutlet weak var tfSecond: UITextField!
    @IBOutlet weak var tfThird: UITextField!
    @IBOutlet weak var tfFourth: UITextField!
    @IBOutlet weak var btnResendSmsCode: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnChangeEmail: UIButton!
    @IBOutlet weak var lblNotificationCount: UILabel!
    
    
    //MARK:- Variable Declaration
    var userEmail = ""
    var getOtp = ""
    var window : UIWindow?
    var getForgotModel:ForgotModel!
    var checkScreen = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
        lblNotificationCount.layer.cornerRadius = lblNotificationCount.frame.height/2
        lblNotificationCount.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.shared.enable = true
        let notificationCount = "\(defaultValues.value(forKey: "PushNotiCount") ?? "")"
        if notificationCount != "0" && notificationCount != ""
        {
            self.lblNotificationCount.isHidden = false
            self.lblNotificationCount.text = notificationCount
        }
        else
        {
            self.lblNotificationCount.isHidden = true
        }
     
        
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
        if checkScreen == "Mobile"
        {
            tfOne.keyboardType = .phonePad
            tfSecond.keyboardType = .phonePad
            tfThird.keyboardType = .phonePad
            tfFourth.keyboardType = .phonePad
            tfFifth.keyboardType = .phonePad
            tfSix.keyboardType = .phonePad
            lblEmail.text = userEmail
            lblMessage.text = NSLocalizedString("You've just received phone message containing otp code on", comment: "")
            img.image = UIImage(named: "Cell")
            btnChangeEmail.isHidden = true
            btnResendSmsCode.isHidden = true
            PhoneAuthProvider.provider().verifyPhoneNumber(userEmail, uiDelegate: nil) { (verificationID, error) in
                   if ((error) != nil) {
                       // Verification code not sent.
                    print(error ?? "")
                   } else {
                       // Successful. -> it's sucessfull here
                         print(verificationID!)
                       UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
                       UserDefaults.standard.synchronize()
                   }
               }
            tfSix.isHidden = false
        }
        else
        {
            tfOne.keyboardType = .default
            tfSecond.keyboardType = .default
            tfThird.keyboardType = .default
            tfFourth.keyboardType = .default
            tfFifth.keyboardType = .default
            lblEmail.text = userEmail
            lblMessage.text = NSLocalizedString("You've just received an email containing verification code on", comment: "")
            img.image = UIImage(named: "mobile")
            btnChangeEmail.isHidden = false
            btnResendSmsCode.isHidden = false
            tfSix.isHidden = true
        }
        
        tfOne.layer.cornerRadius = 5
        tfOne.layer.borderWidth = 1
        tfOne.layer.borderColor = BaseViewController.appColor.cgColor
        tfSecond.layer.cornerRadius = 5
        tfSecond.layer.borderWidth = 1
        tfSecond.layer.borderColor = BaseViewController.appColor.cgColor
        tfThird.layer.cornerRadius = 5
        tfThird.layer.borderWidth = 1
        tfThird.layer.borderColor = BaseViewController.appColor.cgColor
        tfFourth.layer.cornerRadius = 5
        tfFourth.layer.borderWidth = 1
        tfFourth.layer.borderColor = BaseViewController.appColor.cgColor
        
        tfFifth.layer.cornerRadius = 5
        tfFifth.layer.borderWidth = 1
        tfFifth.layer.borderColor = BaseViewController.appColor.cgColor
        
        tfSix.layer.cornerRadius = 5
        tfSix.layer.borderWidth = 1
        tfSix.layer.borderColor = BaseViewController.appColor.cgColor
        
        btnSubmit.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnSubmit.layer.cornerRadius = 15
        btnSubmit.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        IQKeyboardManager.shared.enable = true
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
               self.view.addGestureRecognizer(tap)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(resetTapped))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(resetTapped))
        toolBar.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        toolBar.isTranslucent = true
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
         
        tfOne.inputAccessoryView = toolBar
        tfOne.delegate = self
         
        tfSecond.inputAccessoryView = toolBar
        tfSecond.delegate = self
         
        tfThird.inputAccessoryView = toolBar
        tfThird.delegate = self
         
        tfFourth.inputAccessoryView = toolBar
        tfFourth.delegate = self
         
        tfFifth.delegate = self
        tfFifth.inputAccessoryView = toolBar
        
        tfSix.delegate = self
        tfSix.inputAccessoryView = toolBar
        
         
    }
    
    @objc func resetTapped() {
        
        tfOne.resignFirstResponder()
        tfSecond.resignFirstResponder()
        tfThird.resignFirstResponder()
        tfFourth.resignFirstResponder()
        tfFifth.resignFirstResponder()
        tfSix.resignFirstResponder()
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if checkScreen == "Mobile"
        {
            if ((textField.text?.count ?? 0) < 1) && (string.count > 0) {
                
                let nextTag = textField.tag + 1
                let nextResponder = textField.superview?.viewWithTag(nextTag)
                if nextResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if textField == tfSix
                {
                    if textField.text != ""
                    {
                        if tfOne.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfSecond.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfThird.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfFourth.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfFifth.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfSix.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else
                        {
                            let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                            let finalOtp = otp+tfFifth.text!+tfSix.text!
                            if finalOtp != ""
                            {
                                let verifyID = "\(UserDefaults.standard.value(forKey: "firebase_verification") ?? "")"
                                    let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: finalOtp)
                                    Auth.auth().signIn(with: credentials) { (result, err) in //here i am signing in...
                                           if let error = err{
                                               let generator = UINotificationFeedbackGenerator()
                                               generator.notificationOccurred(.error)
                                             
                                               self.view.makeToast(NSLocalizedString(error.localizedDescription, comment: ""), duration: 1.0, position: .center)
                                               return
                                           }
                                       }
                            }

                        }
                    }
                }
               
                if nextResponder != nil {
                    nextResponder?.becomeFirstResponder()
                }
                return false
            } else if ((textField.text?.count ?? 0) >= 1) && (string.count > 0) {
                
                let nextTag = textField.tag + 1
                let nextResponder = textField.superview?.viewWithTag(nextTag)
                if nextResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if nextResponder != nil {
                    nextResponder?.becomeFirstResponder()
                }
                return false
            }
            else if ((textField.text?.count ?? 0) >= 1) && (string.count == 0) {
                let prevTag = textField.tag - 1
                let prevResponder = textField.superview?.viewWithTag(prevTag)
                if prevResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if prevResponder != nil {
                    prevResponder?.becomeFirstResponder()
                }
                return false
            }
            else if ((textField.text?.count ?? 0) >= 1) && (string.count == 0) {
                    let prevTag = textField.tag - 1
                    let prevResponder = textField.superview?.viewWithTag(prevTag)
                    if prevResponder == nil {
                        textField.resignFirstResponder()
                    }
                    textField.text = string
                    if prevResponder != nil {
                        prevResponder?.becomeFirstResponder()
                    }
                    return false
                }
            else if ((textField.text?.count ?? 0) >= 1) && (string.count == 0) {
                    let prevTag = textField.tag - 1
                    let prevResponder = textField.superview?.viewWithTag(prevTag)
                    if prevResponder == nil {
                        textField.resignFirstResponder()
                    }
                    textField.text = string
                    if prevResponder != nil {
                        prevResponder?.becomeFirstResponder()
                    }
                    return false
                }
            else {
                textField.resignFirstResponder()
            }
        }
        else
        {
            if ((textField.text?.count ?? 0) < 1) && (string.count > 0) {
                
                let nextTag = textField.tag + 1
                let nextResponder = textField.superview?.viewWithTag(nextTag)
                if nextResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if textField == tfFifth
                {
                    if textField.text != ""
                    {
                        if tfOne.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfSecond.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfThird.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfFourth.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else if tfFifth.text == ""
                        {
                            self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                        }
                        else
                        {
                            let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                            let finalOtp = otp+tfFifth.text!
                            if finalOtp != ""
                            {
                                VerifyOtpApi(getOtp:finalOtp)
                            }

                        }
                    }
                }
               
                if nextResponder != nil {
                    nextResponder?.becomeFirstResponder()
                }
                return false
            } else if ((textField.text?.count ?? 0) >= 1) && (string.count > 0) {
                
                let nextTag = textField.tag + 1
                let nextResponder = textField.superview?.viewWithTag(nextTag)
                if nextResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if nextResponder != nil {
                    nextResponder?.becomeFirstResponder()
                }
                return false
            }
            else if ((textField.text?.count ?? 0) >= 1) && (string.count == 0) {
                let prevTag = textField.tag - 1
                let prevResponder = textField.superview?.viewWithTag(prevTag)
                if prevResponder == nil {
                    textField.resignFirstResponder()
                }
                textField.text = string
                if prevResponder != nil {
                    prevResponder?.becomeFirstResponder()
                }
                return false
            }
                else if ((textField.text?.count ?? 0) >= 1) && (string.count == 0) {
                    let prevTag = textField.tag - 1
                    let prevResponder = textField.superview?.viewWithTag(prevTag)
                    if prevResponder == nil {
                        textField.resignFirstResponder()
                    }
                    textField.text = string
                    if prevResponder != nil {
                        prevResponder?.becomeFirstResponder()
                    }
                    return false
                }
            else {
                textField.resignFirstResponder()
            }
        }
      
        return true
    }
    
    @IBAction func endEditingTextfield(_ sender: UITextField)
    {
       
        if sender.text != ""
        {
            if checkScreen == "Mobile"
            {
                if tfOne.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfSecond.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfThird.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfFourth.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfFifth.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfSix.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else
                {
                    let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                    let finalOtp = otp+tfFifth.text!+tfSix.text!
                    if finalOtp != ""
                    {
                        let verifyID = "\(UserDefaults.standard.value(forKey: "firebase_verification") ?? "")"
                            let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: finalOtp)
                            Auth.auth().signIn(with: credentials) { (result, err) in //here i am signing in...
                                   if let error = err{
                                       let generator = UINotificationFeedbackGenerator()
                                       generator.notificationOccurred(.error)
                                     
                                       self.view.makeToast(NSLocalizedString(error.localizedDescription, comment: ""), duration: 1.0, position: .center)
                                       return
                                   }
                               }
                    }

                }
            }
            else
            {
                if tfOne.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfSecond.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfThird.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfFourth.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
                else if tfFifth.text == ""
                {
                    self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
                }
               
                else
                {
                    let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                    let finalOtp = otp+tfFifth.text!
                    if finalOtp != ""
                    {
                        VerifyOtpApi(getOtp:finalOtp)
                    }

                }
            }
            
        }
       
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_bellBtnTapped(_ sender: UIButton)
    {
        let objRef:NotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_resendBtnTapped(_ sender: UIButton)
    {
        ResentCodeApi(getEmail:userEmail)
    }
    
    @IBAction func action_submitBtnTapped(_ sender: UIButton)
    {
        if checkScreen == "Mobile"
        {
            if tfOne.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfSecond.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfThird.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfFourth.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfFifth.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfSix.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else
            {
                let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                let finalOtp = otp+tfFifth.text!+tfSix.text!
                if finalOtp != ""
                {
                    let verifyID = "\(UserDefaults.standard.value(forKey: "firebase_verification") ?? "")"
                        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verifyID, verificationCode: finalOtp)
                        Auth.auth().signIn(with: credentials) { (result, err) in //here i am signing in...
                               if let error = err{
                                   let generator = UINotificationFeedbackGenerator()
                                   generator.notificationOccurred(.error)
                                 
                                   self.view.makeToast(NSLocalizedString(error.localizedDescription, comment: ""), duration: 1.0, position: .center)
                                   return
                               }
                           }

                }
            }
        }
        else
        {
            if tfOne.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfSecond.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfThird.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfFourth.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
            else if tfFifth.text == ""
            {
                self.view.makeToast(NSLocalizedString(confirmationCodeMessage, comment: ""), duration: 1.0, position: .bottom)
            }
           
            else
            {
                let otp = tfOne.text!+tfSecond.text!+tfThird.text!+tfFourth.text!
                let finalOtp = otp+tfFifth.text!
                if finalOtp != ""
                {
                   VerifyOtpApi(getOtp:finalOtp)
                }
            }
        }
       
    }
    
    @IBAction func action_changeEmailBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- WebServices
    func VerifyOtpApi(getOtp:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["user_id":userId,"code":getOtp]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/verify/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)
            
        if self.getForgotModel.status != "error"
        {
            self.NotificationRegisterApi()
            APPDELEGATE.userTabbarCheck(value: 2)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil, userInfo: nil)
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    
    func ResentCodeApi(getEmail:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["user_email":getEmail]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/request_code/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)
            
        if self.getForgotModel.status != "error"
        {
           
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
      self.objHudHide()
      }
    
    }
    
    func NotificationRegisterApi()
    {
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let deviceToken = defaultValues.value(forKey: "DeviceID") ?? ""
        let params: [String: Any] = ["device_token":deviceToken,"user_id":userId,"platform_name":"ios"]
        objHudHide()
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/notis/register/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

        if self.getForgotModel.status == "success"
        {
            defaultValues.setValue("Push", forKey: "PushNoti")
            defaultValues.synchronize()
            //self.navigationController?.popViewController(animated: true)
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }

       }
            self.objHudHide()
      }

    }
}
