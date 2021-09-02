//
//  ChangePasswordVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import ObjectMapper

class ChangePasswordVC: BaseViewController,UITextFieldDelegate{

    //MARK:- IBOutlets
    @IBOutlet weak var imgConfirmPass: UIImageView!
    @IBOutlet weak var tfConfirmPass: UITextField!
    @IBOutlet weak var lineConfirmPass: UILabel!
    @IBOutlet weak var tfCreatePass: UITextField!
    @IBOutlet weak var imgCreatePass: UIImageView!
    @IBOutlet weak var lineCreatePass: UILabel!
    @IBOutlet weak var lineOldPass: UILabel!
    @IBOutlet weak var imgOldPass: UIImageView!
    @IBOutlet weak var tfOldPass: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variable Declaration
    var getForgotModel:ForgotModel!
    
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
   
    tfOldPass.delegate = self
    tfConfirmPass.delegate = self
    tfCreatePass.delegate = self
    btnSave.layer.backgroundColor = BaseViewController.appColor.cgColor
    btnSave.layer.cornerRadius = 15
    btnSave.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
   }
    
   func validateOldPasword() {
         if Helper.shared.isFieldEmpty(field: tfOldPass.text!)
         {
            lineOldPass.backgroundColor = BaseViewController.appColor
            imgOldPass.isHidden = true
        }
        else
         {
          
            lineOldPass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgOldPass.isHidden = false
            
        }
        
    }
    
    func validateCreatePasword() {
         if Helper.shared.isFieldEmpty(field: tfCreatePass.text!)
         {
            lineCreatePass.backgroundColor = BaseViewController.appColor
            imgCreatePass.isHidden = true
        }
        else
         {
            if tfCreatePass.text!.count < 5  {
                
                lineCreatePass.backgroundColor = BaseViewController.appColor
                imgCreatePass.isHidden = true

            }
            else
            {
                
                  lineCreatePass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
                  imgCreatePass.isHidden = false
            }
          
            
        }
        
    }
    
    func validateConfirmPasword() {
         if Helper.shared.isFieldEmpty(field: tfConfirmPass.text!)
         {
            lineConfirmPass.backgroundColor = BaseViewController.appColor
            imgConfirmPass.isHidden = true
        }
         else
          {
             if tfConfirmPass.text!.count < 4  {
                 
                lineConfirmPass.backgroundColor = BaseViewController.appColor
                imgConfirmPass.isHidden = true

             }
             else
             {
                 
                lineConfirmPass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
                imgConfirmPass.isHidden = false
             }
           
             
         }
        
    }
    
    //MARK:- UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == tfOldPass && range.length == 1 && range.location == 0 {
//           lineOldPass.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
//            imgOldPass.isHidden = true
//
//        }
         if textField == tfCreatePass && range.length == 1 && range.location == 0 {

            lineCreatePass.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgCreatePass.isHidden = true

        }
        else if textField == tfConfirmPass && range.length == 1 && range.location == 0 {

            lineConfirmPass.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgConfirmPass.isHidden = true

        }
//        else if textField == tfOldPass {
//            lineOldPass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
//            imgOldPass.isHidden = false
//           
//            
//        }
        else if textField == tfCreatePass && tfCreatePass.text!.count >= 4 {
            lineCreatePass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgCreatePass.isHidden = false
           
        }
        else if textField == tfConfirmPass && tfConfirmPass.text!.count >= 4{
            lineConfirmPass.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgConfirmPass.isHidden = false
           
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == tfOldPass && tfOldPass.text?.count == 0 {
//            lineOldPass.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
//            imgOldPass.isHidden = true
//
//        }
         if textField == tfCreatePass && tfCreatePass.text?.count == 0 {

            lineCreatePass.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
           imgCreatePass.isHidden = true

        }
        else if textField == tfConfirmPass && tfConfirmPass.text?.count == 0 {

            lineConfirmPass.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgConfirmPass.isHidden = true

        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
//        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        if textField == tfOldPass
//        {
//            tfCreatePass.becomeFirstResponder()
//        }
         if textField == tfCreatePass
        {
            tfConfirmPass.becomeFirstResponder()
        }
        else
        {
            tfConfirmPass.resignFirstResponder()
        }
        
        return true
    }
    
   //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_moreBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_saveBtnTapped(_ sender: UIButton)
    {
//        if Helper.shared.isFieldEmpty(field: tfOldPass.text!)
//        {
//            validateOldPasword()
      //  }
        if  Helper.shared.isFieldEmpty(field: tfCreatePass.text!){
            
          validateCreatePasword()
        }
        else if tfCreatePass.text != "" && tfCreatePass.text!.count < 4
        {
            validateCreatePasword()
        }
        else if tfConfirmPass.text != "" && tfConfirmPass.text!.count < 4
        {
            validateConfirmPasword()
        }
        else if tfConfirmPass.text != tfCreatePass.text
        {
            lineConfirmPass.backgroundColor = BaseViewController.appColor
            imgConfirmPass.isHidden = true
        }
        else
        {
            ChangePasswordApi(getPassword:tfCreatePass.text!)
        }
    }
    
    //MARK:- WebServices
    func ChangePasswordApi(getPassword:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        let params: [String: Any] = ["user_password":getPassword,"user_id":userId]

        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/password_update/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
        self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)

        if self.getForgotModel.status == "success"
        {
            self.navigationController?.popViewController(animated: true)
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
