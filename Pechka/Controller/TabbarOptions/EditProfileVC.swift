//
//  EditProfileVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import ObjectMapper
import Alamofire
import Photos

class EditProfileVC: BaseViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var imgProfileCover: UIImageView!
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var txtViewAboutMe: UITextView!
    @IBOutlet weak var viewBgAboutMe: UIView!
    @IBOutlet weak var txtViewAddress: UITextView!
    @IBOutlet weak var viewBgAddress: UIView!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var imgMobileNum: UIImageView!
    @IBOutlet weak var tfMobileNum: UITextField!
    @IBOutlet weak var lineMobileNum: UILabel!
    @IBOutlet weak var lineEmail: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var lineUsername: UILabel!
    @IBOutlet weak var imgUserName: UIImageView!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK:- Variable Declaration
    var imgType = "png"
    var imgName = ""
    var selectedImg = ""
    var getAddUserModel:AddUserModel!
    var getAddUserRatingDetail:AddUserRatingDetail!
    var getForgotModel:ForgotModel!
    var imgUrl = ""
    //MARK:-View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        if imgUrl != ""{
                let imgName = "\(imgUrl)"
                var imageUrl = BaseViewController.IMG_URL
                imageUrl.append(imgName)
            
            self.imgProfile.sd_setShowActivityIndicatorView(true)
            self.imgProfile.sd_setIndicatorStyle(.gray)
            self.imgProfile!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:UIImage(named: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
            self.imgProfileCover.sd_setShowActivityIndicatorView(true)
            self.imgProfileCover.sd_setIndicatorStyle(.gray)
            self.imgProfileCover!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:UIImage(named: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
            
            }
      
        if let userName = defaultValues.value(forKey: "userName")
        {
            tfUserName.text = "\(userName)"
        }
        
        if let userEmail = defaultValues.value(forKey: "Email")
        {
            tfEmail.text = "\(userEmail)"
        }
        
        if let userCity = defaultValues.value(forKey: "City")
        {
            tfCity.text = "\(userCity)"
        }
        if let userAbout = defaultValues.value(forKey: "AboutMe")
        {
            txtViewAboutMe.text = "\(userAbout)"
        }
        if let userAddress = defaultValues.value(forKey: "Address")
        {
            txtViewAddress.text = "\(userAddress)"
        }
        if let userPhone = defaultValues.value(forKey: "Phone")
        {
           tfMobileNum.text = "\(userPhone)"
        }
     
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
       
        btnsave.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnsave.layer.cornerRadius = 15
        btnsave.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        txtViewAddress.layer.cornerRadius = 5
        txtViewAddress.layer.borderWidth = 1
        txtViewAddress.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewAboutMe.layer.cornerRadius = 5
        txtViewAboutMe.layer.borderWidth = 1
        txtViewAboutMe.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.8235294118, blue: 0.8235294118, alpha: 1)
        txtViewAddress.delegate = self
        txtViewAddress.text = "Address"
        txtViewAddress.textColor = .lightGray
        txtViewAboutMe.delegate = self
        txtViewAboutMe.text = "About me"
        txtViewAboutMe.textColor = .lightGray
        tfUserName.delegate = self
        tfEmail.delegate = self
        tfMobileNum.delegate = self
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtViewAddress
        {
            if (txtViewAddress.text ==  NSLocalizedString("Address", comment: ""))
            {
                txtViewAddress.text = ""
                txtViewAddress.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
        else
        {
            if (txtViewAboutMe.text ==  NSLocalizedString("About me", comment: ""))
            {
                txtViewAboutMe.text = ""
                txtViewAboutMe.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.73)
            }
        }
      
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtViewAddress
        {
            if (txtViewAddress.text == "")
            {
                txtViewAddress.text = NSLocalizedString("Address", comment: "")
                txtViewAddress.textColor = .lightGray
            }
           
        }
        else
        {
            if (txtViewAboutMe.text == "")
            {
                txtViewAboutMe.text = NSLocalizedString("About me", comment: "")
                txtViewAboutMe.textColor = .lightGray
            }
        }
       
    }
    
    func emailValidation() {
        if Helper.shared.isFieldEmpty(field: tfEmail.text!) || Helper.shared.isValidEmail(candidate: tfEmail.text!)
        {
          lineEmail.backgroundColor = BaseViewController.appColor
           imgEmail.isHidden = true

        }
        else
        {
            lineEmail.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
            imgEmail.isHidden = false
        }
    }
    
    func usernameValidation() {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
           lineUsername.backgroundColor = BaseViewController.appColor
           imgUserName.isHidden = true

        }
        else
        {
            lineUsername.backgroundColor = #colorLiteral(red: 0, green: 0.6508188248, blue: 0.02769207582, alpha: 1)
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
            lineUsername.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgUserName.isHidden = true

        }
        else if textField == tfEmail && range.length == 1 && range.location == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

        }
        else if textField == tfMobileNum && range.length == 1 && range.location == 0 {

            lineMobileNum.backgroundColor = #colorLiteral(red: 0.8110396266, green: 0.8110588193, blue: 0.8110484481, alpha: 1)
            imgMobileNum.isHidden = true

        }
        else if textField == tfUserName {
            usernameValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }
        else if textField == tfEmail {
            emailValidation()
//          tfPassword.becomeFirstResponder()
           
            
        }else if textField == tfMobileNum{
            if  tfMobileNum.text != ""
            {
                validateMobile()
            }
          
           
        }
        return true
    }
    
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == tfUserName && tfUserName.text?.count == 0 {
        lineUsername.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
        imgUserName.isHidden = true

    }
    else if textField == tfEmail && tfEmail.text?.count == 0 {
            lineEmail.backgroundColor = #colorLiteral(red: 0.8548173308, green: 0.8549612164, blue: 0.8547983766, alpha: 1)
            imgEmail.isHidden = true

    }else if textField == tfMobileNum && tfMobileNum.text?.count == 0 && tfMobileNum.text!.count < 10 {

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
            tfEmail.becomeFirstResponder()
        }
        else if textField == tfEmail
        {
            tfMobileNum.becomeFirstResponder()
        }
        else if textField == tfMobileNum
        {
            tfCity.becomeFirstResponder()
        }
        else if textField == tfCity
        {
            tfCity.resignFirstResponder()
        }
        
        return true
    }
    //MARK:- Upload Image
    func showActionSheet(){
            
            let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("UPLOAD IMAGE", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            actionSheetController.view.tintColor = UIColor.black
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
//            let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
//            { action -> Void in
//                self.camera()
//            }
//            actionSheetController.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
            { action -> Void in
                self.gallery()
            }
            actionSheetController.addAction(deleteActionButton)
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
        func camera()
        {
            let myPickerControllerCamera = UIImagePickerController()
            myPickerControllerCamera.delegate = self
            myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
            myPickerControllerCamera.allowsEditing = true
            self.present(myPickerControllerCamera, animated: true, completion: nil)
        }
        
        func gallery()
        {
            let myPickerControllerGallery = UIImagePickerController()
            myPickerControllerGallery.delegate = self
            myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPickerControllerGallery.allowsEditing = true
            self.present(myPickerControllerGallery, animated: true, completion: nil)
        }
        
        
    //MARK:- UIImagePickerController delegate Methods
      @objc func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
      {
          guard let selectedImage = info[.originalImage] as? UIImage else {
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        imgName = fileUrl.lastPathComponent
        imgType = fileUrl.pathExtension

        self.imgProfile.image = cropToBounds(image: selectedImage, width: 800, height: 800)
        self.imgProfileCover.image = cropToBounds(image: selectedImage, width: 800, height: 800)
        selectedImg = "\(cropToBounds(image: selectedImage, width: 800, height: 800))"
        editProfileImage()
          
          dismiss(animated: true, completion: nil)
      }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
        }
    
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_profileBtnTapped(_ sender: UIButton)
    {
        showActionSheet()
    }
    
    @IBAction func action_changePassBtnTapped(_ sender: UIButton)
    {
        let objRef:ChangePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
    @IBAction func action_saveBtnTapped(_ sender: UIButton)
    {
        if Helper.shared.isFieldEmpty(field: tfUserName.text!)
        {
          usernameValidation()
        }
        if Helper.shared.isFieldEmpty(field: tfEmail.text!)
        {
          emailValidation()
        }
        else if Helper.shared.isValidEmail(candidate: tfEmail.text!)
        {
          emailValidation()
        }
//        else if Helper.shared.isFieldEmpty(field: tfMobileNum.text!)
//        {
//           validateMobile()
//        }
//        else if tfMobileNum.text!.count < 10
//        {
//            validateMobile()
//        }
//        else if tfCity.text == ""
//        {
//            self.view.makeToast(NSLocalizedString("Please enter city", comment: ""), duration: 1.0, position: .center)
//        }
//        else if txtViewAddress.text == "" || txtViewAddress.text == "Address"
//        {
//            self.view.makeToast(NSLocalizedString("Please enter address", comment: ""), duration: 1.0, position: .center)
//        }
//        else if txtViewAboutMe.text == "" || txtViewAboutMe.text == "About me"
//        {
//            self.view.makeToast(NSLocalizedString("Please enter about me", comment: ""), duration: 1.0, position: .center)
//        }
        else
        {
            EditProfileApi(getUserName:tfUserName.text!,getUserEmail:tfEmail.text!,getUserMobile:tfMobileNum.text!,getUserCity:tfCity.text!,getUserAddress:txtViewAddress.text!,getUserAboutMe:txtViewAboutMe.text)
        }
    }
  
    
    //MARK:- WebServices
    func EditProfileApi(getUserName:String,getUserEmail:String,getUserMobile:String,getUserCity:String,getUserAddress:String,getUserAboutMe:String)
    {
        objHudShow()
        let userId = defaultValues.value(forKey: "UserID") ?? ""
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        
        let params: [String: Any] = ["user_id":userId,"user_phone":getUserMobile,"user_address":getUserAddress,"city":getUserCity ,"user_name":getUserName,"user_email":getUserEmail,"user_about_me":getUserAboutMe,"device_token":deviceID]
        
        print(params);
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/users/profile_update/api_key/teampsisthebest", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
        self.getForgotModel = Mapper<ForgotModel>().map(JSONObject: response)
            
        if self.getForgotModel.status != "error"
        {
         
            defaultValues.setValue(self.tfUserName.text!, forKey: "userName")
            defaultValues.synchronize()
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
        else
        {
            self.view.makeToast(NSLocalizedString(self.getForgotModel.message ?? "", comment: ""), duration: 1.0, position: .center)
        }
            
       }
            self.objHudHide()
      }
    
    }
    
    func editProfileImage()
    {
   
         let UserId = defaultValues.value(forKey: "UserID") ?? ""
         let parameters: [String:Any] =  [
        
         "user_id":UserId,
         "platform_name":"ios"
        
        ]
        
      objHudShow()
      print("*************")
        
        
     
         
           print(parameters)
        
        guard let image1 = imgProfile.image else{return}
         
        
        
           guard var imgData1 = image1.jpegData(compressionQuality: 0.1) else{return}
        if imgType == "png" {
            imgData1 = image1.pngData()!
        }
        
       
        
           Alamofire.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(imgData1, withName: "pic",fileName: self.imgName, mimeType: "image/jpg/png/jpeg")
            
               for (key, value) in parameters {
                   multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
               }
           }, usingThreshold: UInt64.init(),to: BaseViewController.API_URL+"rest/images/upload/api_key/teampsisthebest", method: .post, headers: WebService().headersintoApi()) { (result) in
               switch result {
               case .success(let upload,_, _):
                   upload.uploadProgress(closure: { (progress) in
                       let value = Float(progress.fractionCompleted)*100
                       print(progress.fractionCompleted)
                       print(value)
                   })
                   upload.responseJSON { response in
                       print("Succesfully uploaded = \(response)")
                    
                    self.objHudHide()
                      if let jsonDict : NSDictionary = response.result.value as? NSDictionary
                     {
                       let status =  "\(jsonDict["status"] ?? "")"
                       if status != "error"
                       {
                       
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5)
                        {
                           
                            defaultValues.setValue(jsonDict["user_profile_photo"] , forKey: "profile")
                            defaultValues.setValue("Edit", forKey: "edit")
                            defaultValues.synchronize()
                            self.view.makeToast(NSLocalizedString("Profile update successfully", comment: ""), duration: 1.0, position: .center)
                        }
                        
                       }
                     }
                    
                  
                   }
               case .failure(let encodingError):
                
                self.objHudHide()
                   print("Error in upload: \(encodingError.localizedDescription)")
           }
                          
        }
    }
}
