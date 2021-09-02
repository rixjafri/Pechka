//
//  MakeOfferChatVC.swift
//  Pechka
//
//  Created by Neha Saini on 27/05/21.
//

import UIKit
import ObjectMapper
import Alamofire
import Firebase

class MakeOfferChatVC: BaseViewController,UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnOfflineStatus: UIButton!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var viewAlpha: UIView!
    @IBOutlet weak var tbleView: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btnSpeech: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnMakeOffer: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnFinalMakeOffer: UIButton!
    @IBOutlet weak var imgViewPop: UIImageView!
    @IBOutlet weak var lblNamePopup: UILabel!
    @IBOutlet weak var lblPricePop: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewBgAcceptRejectOffer: UIView!
    @IBOutlet weak var lblTitleRejectAccept: UILabel!
    @IBOutlet weak var btnYesAcceptReject: UIButton!
    @IBOutlet weak var btnNoAcceptRejectOffer: UIButton!
    
    //MARK:- Variable Declaration
    private var lastChildTimeStamp = 0
    var refreshControl = UIRefreshControl()
    var getChatModel:ChatModel!
    var getProductItemDetailModel:ProductItemDetailModel!
    var getAddItemDefaultPhoto: AddItemDefaultPhoto!
    var getAddItemCategory: AddItemCategory!
    var getAddItemConditionOfItem: AddItemConditionOfItem!
    var getAddItemDealOption:AddItemDealOption!
    var getAddItemItemCurrency:AddItemItemCurrency!
    var getAddItemItemLocation:AddItemItemLocation!
    var getAddItemItemPriceType:AddItemItemPriceType!
    var getAddItemItemType:AddItemItemType!
    var getAddItemSubCategory:AddItemSubCategory!
    var getAddItemModel:AddItemModel!
    var getAddItemUser:AddItemUser!
    var getAddUserRatingDetail:AddUserRatingDetail!
    var typeSellerBuyer = ""
    var screenType = ""
    var indexTag = 0
    var sellerUserId = ""
    var buyerUserId = ""
    var itemId = ""
    var isFirstMessage = true
    var getAddUserModel:AddUserModel!
    var arrChat = NSMutableArray()
    let ChatArr = NSMutableArray()
    var imgType = "png"
    var imgName = ""
    var selectedImg = UIImage()
    var offerStatus = Int()
    var imgUrl = ""
    var userName = ""
    var imagePicker = UIImagePickerController()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        setInitials()
        let UserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
        if UserIdStr != sellerUserId
        {
            btnMakeOffer.isHidden = false
        }
        else
        {
            btnMakeOffer.isHidden = true
        }
        let messageKey = "\(defaultValues.value(forKey: "isFirstMessage") ?? "")"
        if itemId == messageKey
        {
            isFirstMessage = false
        }
        else
        {
            isFirstMessage = true
        }
        self.getMsgs()
        DispatchQueue.main.async {
          //  self.getMsgs()
            self.createUser()
            self.setFetchUserByIdObjApi()
            let userName = "\(defaultValues.value(forKey: "userName") ?? "")"
            let UserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            self.setUserPresenceStatusObj(loginUserId:UserIdStr, loginUserName:userName)
            self.setCheckReceiverStatusObj(loginUserId:UserIdStr, receiverId:self.sellerUserId,itemId:self.itemId)
            self.setUploadChattingWithObj(loginUserId:UserIdStr, receiverId:self.sellerUserId,itemId:self.itemId)
        }
        
        btnNoAcceptRejectOffer.layer.borderWidth = 1
        btnNoAcceptRejectOffer.layer.borderColor = BaseViewController.appColor.cgColor
        btnNoAcceptRejectOffer.layer.cornerRadius = 15
        btnNoAcceptRejectOffer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        btnYesAcceptReject.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btnYesAcceptReject.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnYesAcceptReject.layer.cornerRadius = 15
        btnYesAcceptReject.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.getOfferDetailAPi()
        }
      
        if typeSellerBuyer == "seller"
        {
            btnMakeOffer.isHidden = false
        }
        else
        {
            btnMakeOffer.isHidden = true
        }
        var userIdStr = ""
        var sellerIdStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserId = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            sellerIdStr = sellerUserId
            getNotificationCountApi(getItemId:itemId,getBuyerUserId:sellerIdStr,getType:"to_buyer",getSellerUserId:userIdStr)

        }
        else
        {
            if typeSellerBuyer == "seller"
            {
                userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
                sellerIdStr = sellerUserId
                getNotificationCountApi(getItemId:itemId,getBuyerUserId:sellerIdStr,getType:"to_buyer",getSellerUserId:userIdStr)

            }
            else
            {
              sellerIdStr = sellerUserId
              userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
              getNotificationCountApi(getItemId:itemId,getBuyerUserId:sellerIdStr,getType:"to_seller",getSellerUserId:userIdStr)

            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let userName = "\(defaultValues.value(forKey: "userName") ?? "")"
        let UserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
        setRemoveUserPresenceStatusObj(loginUserId:UserIdStr, loginUserName:userName)
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
        if screenType == "Offer"
        {
            if let tempDic1 : Dictionary = APPDELEGATE.getOfferList[indexTag] as? Dictionary<String,Any>
             {
                if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                 {
                
                if let getCatprice : String = tempDicItem["price"] as? String
                {
                    if let tempDicConItem : Dictionary = tempDicItem["condition_of_item"] as? Dictionary<String,Any>
                     {
                        if let getCatName : String = tempDicConItem["name"] as? String
                        {
                            var totalPrice = Double()
                            totalPrice = Double(getCatprice) ?? 0.0
                            lblPrice.text = "$ \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                            lblPricePop.text = "$ \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                            tfPrice.text = String(format: "%.2f", totalPrice)
                        }
                    }
                   
                }
              
                if let getCattitle: String = tempDicItem["title"] as? String
                {
                    lblName.text = getCattitle
                    lblNamePopup.text = getCattitle
                }
               
                if let tempDicImg : Dictionary = tempDicItem["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                            imgView.layer.masksToBounds = true
                            imgViewPop.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                            imgViewPop.layer.masksToBounds = true
                        }
                       else
                        {
                            imgView.image = #imageLiteral(resourceName: "itemDefault")
                            imgViewPop.image = #imageLiteral(resourceName: "itemDefault")
                        }
                }
                }
         
            }
        }
        else if screenType == "Message"
        {
            if let tempDic1 : Dictionary = APPDELEGATE.MessageList[indexTag] as? Dictionary<String,Any>
             {
                if let tempDicItem : Dictionary = tempDic1["item"] as? Dictionary<String,Any>
                 {
                
                if let getCatprice : String = tempDicItem["price"] as? String
                {
                    if let tempDicConItem : Dictionary = tempDicItem["condition_of_item"] as? Dictionary<String,Any>
                     {
                        if let getCatName : String = tempDicConItem["name"] as? String
                        {
                            var totalPrice = Double()
                            totalPrice = Double(getCatprice) ?? 0.0
                            lblPrice.text = "$ \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                            lblPricePop.text = "$ \(String(format: "%.2f", totalPrice)) (\(getCatName))"
                            tfPrice.text = String(format: "%.2f", totalPrice)
                        }
                    }
                   
                }
              
                if let getCattitle: String = tempDicItem["title"] as? String
                {
                    lblName.text = getCattitle
                    lblNamePopup.text = getCattitle
                }
               
                if let tempDicImg : Dictionary = tempDicItem["default_photo"] as? Dictionary<String,Any>
                 {
                        if let getSliderNameImg1 : String = tempDicImg["img_path"] as? String
                        {
                            var imageUrl =  BaseViewController.IMG_URL
                                imageUrl.append(getSliderNameImg1)
                            
                            imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                            imgView.layer.masksToBounds = true
                            imgViewPop.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "itemDefault"))
                            imgViewPop.layer.masksToBounds = true
                        }
                       else
                        {
                            imgView.image = #imageLiteral(resourceName: "itemDefault")
                            imgViewPop.image = #imageLiteral(resourceName: "itemDefault")
                        }
                }
                }
         
            }
        }
        else
        {
            self.getAddItemDefaultPhoto = self.getProductItemDetailModel.defaultPhoto
            if let imgUrl = self.getAddItemDefaultPhoto.imgPath
            {
             var imageUrl =  BaseViewController.IMG_URL
                 imageUrl.append(imgUrl)
             
             self.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                self.imgViewPop.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
             self.imgView.layer.masksToBounds = true
                if let title = self.getProductItemDetailModel.title
                {
                 self.lblName.text = title
                    self.lblNamePopup.text = title
                }
                if let title = self.getProductItemDetailModel.price
                {
                
                    if let title1 = self.getProductItemDetailModel.conditionOfItem?.name
                    {
                     self.lblPrice.text = "$ \(title) (\(title1))"
                     self.lblPricePop.text = "$ \(title) (\(title1))"
                    }
                }
                if let title = self.getProductItemDetailModel.price
                {
                     self.tfPrice.text = title
                }
               
            }
        }
       
        
        tbleView.delegate = self
        tbleView.dataSource = self
        tfMessage.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
          tap.cancelsTouchesInView = false
          view.addGestureRecognizer(tap)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tbleView.addSubview(refreshControl) // n
        btnMakeOffer.layer.cornerRadius = 10
        btnFinalMakeOffer.layer.cornerRadius = 10
        imgView.layer.cornerRadius = 5
        
        self.tbleView.register(UINib(nibName: "ChatImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableViewCell")
        self.tbleView.register(UINib(nibName: "ChatImagesReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatImagesReceiverTableViewCell")
        self.tbleView.register(UINib(nibName: "MakeOfferItemTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeOfferItemTableViewCell")
        self.tbleView.register(UINib(nibName: "MakeOfferItemReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeOfferItemReceiverTableViewCell")
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           let touch: UITouch? = touches.first
           //location is relative to the current view
           // do something with the touched point
           print("viewAlpha")
           if touch?.view == viewAlpha{
            viewAlpha.isHidden = true
           }
        }
    @objc func dismissKeyboard() {
          //Causes the view (or one of its embedded text fields) to resign the first responder status.
          view.endEditing(true)
    }
    
    @objc func refresh(_ sender: AnyObject)
    {
      
        refreshControl.endRefreshing()
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
            myPickerControllerCamera.allowsEditing = false
            self.present(myPickerControllerCamera, animated: true, completion: nil)
        }
        
        func gallery()
        {
          
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
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

       
        selectedImg = cropToBounds(image: selectedImage, width: 800, height: 800)
        if typeSellerBuyer == "seller" {
           if (imgName.contains(".webp")) {
            self.view.makeToast(NSLocalizedString("Sorry , you cannot upload .webp image", comment: ""), duration: 1.0, position: .center)
           }else {
            addChatImage(getImage: cropToBounds(image: selectedImage, width: 800, height: 800), getType: "to_seller",getBuyerId:"\(defaultValues.value(forKey: "UserID") as? String ?? "")",getSellerId:sellerUserId, getSenderId: sellerUserId)
           }
        } else {
           if (imgName.contains(".webp")) {
            self.view.makeToast(NSLocalizedString("Sorry , you cannot upload .webp image", comment: ""), duration: 1.0, position: .center)
           }else {
            addChatImage(getImage: cropToBounds(image: selectedImage, width: 800, height: 800), getType: "to_buyer",getBuyerId:sellerUserId,getSellerId:"\(defaultValues.value(forKey: "UserID") as? String ?? "")", getSenderId: "\(defaultValues.value(forKey: "UserID") as? String ?? "")")
           }
        }

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
    @IBAction func action_yesAcceptRejectOfferBtnTapped(_ sender: UIButton)
    {
        viewBgAcceptRejectOffer.isHidden = true
    }
    
    @IBAction func action_noAcceptRejectOfferBtnTapped(_ sender: UIButton)
    {
        viewBgAcceptRejectOffer.isHidden = true
    }
    
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_makeOfferBtnTapped(_ sender: UIButton)
    {
        
        viewAlpha.isHidden = false
       
    }
    @IBAction func action_galleryBtnTapped(_ sender: UIButton)
    {
        showActionSheet()
    }
    
    @IBAction func action_sendBtnTapped(_ sender: UIButton)
    {
        if tfMessage.text == ""
        {
          self.view.makeToast(NSLocalizedString("Please enter message.", comment: ""), duration: 3.0, position: .center)
          
        }
        else
        {
            
           
            sendMessageWithProperty(getText: tfMessage.text!, getType: 0, getOfferStatus: 0)
//           database.child("Message").child(sessionId).childByAutoId().updateChildValues(["message":tfMessage.text!,"addedDate":nowDouble,"id":"","isSold":soldOut,"itemId":getProductItemDetailModel.id ?? "","offerStatus":offerStatus,"sendByUserId":userIdStr,"sessionId":sessionId,"type":"0"])
            
            
            
            
        }
    }
    func generateKeyForChatHeadId(senderId:String, receiverId:String) -> String {
        if (senderId.compare(receiverId).rawValue < 0) {

           return senderId + "_" + receiverId;

       } else if (senderId.compare(receiverId).rawValue > 0) {

           return receiverId + "_" + senderId;

       } else {
           //Need to apply proper solution later

           return senderId + "_" + receiverId;
       }
    }

    func sendMessageWithProperty(getText:String,getType:Int,getOfferStatus:Int){
        
       
        var soldOut = false
        var offerStatus = 0
        var itemId = ""
        var userIdStr = ""
        var sellerIdStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserId = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            sellerIdStr = sellerUserId
            userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            if getProductItemDetailModel.isSoldOut == "0"
            {
                soldOut = false
            }
            else
            {
                soldOut = true
            }
           
            itemId = getProductItemDetailModel.id ?? ""
        }
        else
        {
            if typeSellerBuyer == "seller"
            {
                userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
                sellerIdStr = sellerUserId
            }
            else
            {
              sellerIdStr = sellerUserId
              userIdStr =  "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            }
            if self.getAddItemModel.isSoldOut == "0"
            {
                soldOut = false
            }
            else
            {
                soldOut = true
            }
            itemId = self.getAddItemModel.id ?? ""
        }
       
        let sessionId = generateKeyForChatHeadId(senderId:"\(userIdStr)", receiverId:"\(sellerIdStr)" )
        let ref = Database.database().reference().child("Message").child(sessionId).childByAutoId()
       
      
      
       
       
       
      
        let oneHourAgo = Date()
        let nowDouble = oneHourAgo.millisecondsSince1970
        if self.getChatModel.isOffer == "0"
        {
            offerStatus = 0
        }
        else
        {
            offerStatus = 1
        }
        let values: [String : Any] = ["message":getText,"addedDate":nowDouble,"id":"\(ref.key ?? "")","isSold":soldOut,"itemId":itemId,"offerStatus":getOfferStatus,"sendByUserId":"\(defaultValues.value(forKey: "UserID") as? String ?? "")","sessionId":sessionId,"type":getType]

          

           // ref.childByAutoId().updateChildValues(values)

            ref.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
               
                self.tfMessage.text = ""
                if self.isFirstMessage == true {
                    self.sendMessageAPi()
                }
           // self.getMsgs()
            }
        }
    
    func getMsgs()
    {
        var userIdStr = ""
        var sellerIdStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserId = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            sellerIdStr = sellerUserId
        }
        else
        {
            if typeSellerBuyer == "seller"
            {
                userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
                sellerIdStr = sellerUserId
            }
            else
            {
              sellerIdStr = sellerUserId
              userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            }
        }
       
       
        let sessionId = generateKeyForChatHeadId(senderId:"\(userIdStr)", receiverId: "\(sellerIdStr)")
        var query = DatabaseQuery()
        let databaseReference = Database.database().reference()
        if (lastChildTimeStamp == 0 ) {
         query = databaseReference.child("Message").child(sessionId).queryOrdered(byChild: "addedDate").queryLimited(toLast: 10)

        }
        else
        {
            query = databaseReference.child("Message").child(sessionId).queryOrdered(byChild: "addedDate").queryLimited(toLast: 10).queryEnding(atValue: lastChildTimeStamp)

        }
        
        APPDELEGATE.ArrChat.removeAllObjects()
        arrChat.removeAllObjects()
        query.observe(.childAdded, with: { (snapshot) in
            
             print("KEY : " + snapshot.key)
            let uniqueId = "\(snapshot.key)"
            let message = snapshot.value
            if APPDELEGATE.ArrChat.count != 0
            {
                let arrCatId = NSMutableArray()
                for i in 0..<APPDELEGATE.ArrChat.count
                {
                    
                    if let tempDic1 : Dictionary = APPDELEGATE.ArrChat[i] as? Dictionary<String,Any>
                     {
                        if let getCatName : String = tempDic1["id"] as? String
                        {
                            arrCatId.add(getCatName)
                        }
                }
                }
                if arrCatId.contains(uniqueId){
                  let index =  arrCatId.index(of:uniqueId)
                    if APPDELEGATE.ArrChat.count > index {
//                                APPDELEGATE.ArrChat.insert(message as Any, at: APPDELEGATE.ArrChat.count)
                           
                }
                }
                else
                {
                    APPDELEGATE.ArrChat.insert(message as Any, at: APPDELEGATE.ArrChat.count)
                }

            }
            else
            {
                
                APPDELEGATE.ArrChat.insert(message as Any, at: APPDELEGATE.ArrChat.count)
            }
           
            print(APPDELEGATE.ArrChat)
           
//            let jsonData = try! JSONSerialization.data(withJSONObject:  APPDELEGATE.ArrChat, options: .prettyPrinted
//             )
//             
//
//             var  json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
//            
//             json = json.replacingOccurrences(of: "\n", with: "")
//             UserDefaults.standard.setValue(json, forKey: "ChatMessage")
//            UserDefaults.standard.synchronize()
            print(APPDELEGATE.ArrChat)
         

         
            if APPDELEGATE.ArrChat.count != 0
            {
               
                if let tempDic1 : Dictionary = APPDELEGATE.ArrChat[0] as? Dictionary<String,Any>
                 {
            
                    if let getDate : Int = tempDic1["addedDate"] as? Int
                    {
                        self.lastChildTimeStamp = getDate
                    }
                 }
            }
            self.attemptReloadOfTableView()

           }
        
        )
        { (error) in
                    print(error.localizedDescription)
        }

    
       
        }
    
    func createUser()
    {
        let getEmail = "\(defaultValues.value(forKey: "Email") ?? "")"
        var getPassword = "\(defaultValues.value(forKey: "Password") ?? "")"
        if getPassword == ""
        {
            getPassword = getEmail
        }
        

        
        Auth.auth().createUser(withEmail: getEmail, password: getPassword) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else{
                        print("Sign Up Successfully.")
                    
                        self.login(getEmail:getEmail,getPassword:getPassword)
                    }
                }
    }
    
    func login(getEmail:String,getPassword:String)
    {
        Auth.auth().signIn(withEmail:getEmail, password: getPassword) { (user, error) in
            if user != nil {
               print("Success")
            }
            else {
                let alert = UIAlertController(title: NSLocalizedString("Useremail or Password Incorrect", comment: ""), message: nil, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setFetchUserByIdObjApi()
    {
            var deviceID = ""
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
              print(uuid)
                deviceID = uuid
            }
            
           let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        WebService.shared.apiGet(url: BaseViewController.API_URL+"rest/users/get/api_key/teampsisthebest/id/\(userId)", parameters: [:]) { (response, error) in
            if error == nil{
                self.objHudHide()
            self.getAddUserModel = Mapper<AddUserModel>().map(JSONObject: response)
                
            if self.getAddUserModel.status != "error"
            {
            }
          }
        }
    }
    
    func setUserPresenceStatusObj(loginUserId:String, loginUserName:String)
    {
        let values: [String : Any] = ["userId":loginUserId,"userName":loginUserName]
        let databaseReference = Database.database().reference()
        databaseReference.child("User_Presence").child(loginUserId).onDisconnectRemoveValue()
        databaseReference.child("User_Presence").child(loginUserId).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
           
            
        }
        
    }
    func getNotificationCountApi(getItemId:String,getBuyerUserId:String,getType:String,getSellerUserId:String)
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    
        
        let parametersList:[String : Any] = ["item_id":getItemId,
                                             "buyer_user_id":getBuyerUserId,
                                             "seller_user_id":getSellerUserId,
                                             "type":getType
        
          ]
     //   objHudShow()
      Alamofire.request(BaseViewController.API_URL+"rest/chats/reset_count/api_key/teampsisthebest", method: .post , parameters: parametersList,headers:headers1).responseJSON{ response in
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
                     let buyerCount =  Int("\(jsonDict["buyer_unread_count"] ?? "")") ?? 0
                     let sellerCount =  Int("\(jsonDict["seller_unread_count"] ?? "")") ?? 0
                     let totalCount = buyerCount + sellerCount
                  
                 
                   
                    if let tabItems = self.tabBarController?.tabBar.items {
                           // In this case we want to modify the badge number of the third tab:
                           
                           let tabItem = tabItems[3]
                           
                           if totalCount != 0
                           {
                               tabItem.badgeValue = "\(totalCount)"
                           }
                    else
                    {
                      tabItem.badgeValue = nil
                    }
                           
          
                }
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
    func setCheckReceiverStatusObj(loginUserId:String, receiverId:String,itemId:String)
    {
        let values: [String : Any] = ["userId":loginUserId]
        let databaseReference = Database.database().reference()
     //   databaseReference.child("User_Presence").child(receiverId).onDisconnectRemoveValue()
        databaseReference.child("User_Presence").child(receiverId).observe(.value, with: { (snapshot) in
            
            if snapshot.exists()
            {
                databaseReference.child("Current_Chat_With").child(receiverId).observe(.value, with: { (snapshot) in
                  
                   if (snapshot.exists()) {
                    self.ChatArr.removeAllObjects()
                       if (snapshot.value != nil) {

                           let chat = snapshot.value
                           
                           if (chat != nil) {
                            self.ChatArr.insert(chat as Any, at: self.ChatArr.count)
                            if let tempDic1 : Dictionary = chat as? Dictionary<String,Any>
                             {
                                if let getReceiverUserId : String = tempDic1["receiver_id"] as? String
                                {
                                    if let getItemId : String = tempDic1["itemId"] as? String
                                    {
                                        if getReceiverUserId == loginUserId && getItemId == self.itemId {
                                           print("Active")
                                            self.btnOfflineStatus.setTitle("Online (Active)", for: .normal)
                                       } else {
                                        print("InActive")
                                        self.btnOfflineStatus.setTitle("Online (InActive)", for: .normal)
                                       }
                                    }
                                }
                            }
                           }

                       }
                   }
                   // databaseReference.cancelDisconnectOperations()
               })
                { (error) in
                            print(error.localizedDescription)
                }
            }
                                     
          //  databaseReference.cancelDisconnectOperations()
        })
        { (error) in
                    print(error.localizedDescription)
        }

    
       
        
       

   
    }
    
    func setUploadChattingWithObj(loginUserId:String, receiverId:String,itemId:String)
    {

        let values: [String : Any] = ["sender_id":loginUserId,"receiver_id": receiverId,"itemId":itemId]
        let databaseReference = Database.database().reference()
        databaseReference.child("Current_Chat_With").child(loginUserId).onDisconnectRemoveValue()
       
               
                databaseReference.child("Current_Chat_With").child(loginUserId).updateChildValues(values) { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                   
                    
                }
    }
    func setRemoveUserPresenceStatusObj(loginUserId:String, loginUserName:String)
    {
        
        let databaseReference = Database.database().reference()
        databaseReference.child("User_Presence").child(loginUserId).removeValue()
        
    }
    var timer: Timer?

    private func attemptReloadOfTableView() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTableView), userInfo: nil, repeats: false)
    }

    @objc func handleReloadTableView() {
        
        DispatchQueue.main.async {
            self.arrChat.removeAllObjects()
            if APPDELEGATE.ArrChat.count != 0
            {
                let arrItemId = NSMutableArray()
                let arrSenderId = NSMutableArray()
                for i in 0..<APPDELEGATE.ArrChat.count
                {
                    if let tempDic1 : Dictionary = APPDELEGATE.ArrChat[i] as? Dictionary<String,Any>
                     {
                        if let getCatName : String = tempDic1["itemId"] as? String
                        {
                            arrItemId.add(getCatName)
                        }
                        if let getSenderId : String = tempDic1["sendByUserId"] as? String
                        {
                            arrSenderId.add(getSenderId)
                        }
                     }
                }
                for i in 0..<arrItemId.count
                {
                    if (arrItemId[i] as AnyObject).contains(self.itemId) && ((arrSenderId[i] as AnyObject).contains(self.sellerUserId) || (arrSenderId[i] as AnyObject).contains("\(defaultValues.value(forKey: "UserID") ?? "")")) {
                      
                        if APPDELEGATE.ArrChat.count > i {
                            self.arrChat.insert(APPDELEGATE.ArrChat[i] as Any, at: self.arrChat.count)
                               
                     }
                   }
                }
               
               

            }
           
           
            if self.arrChat.count > 1
            {
                DispatchQueue.main.async {
                    self.tbleView?.reloadData()
                    let indexpath = NSIndexPath.init(item: self.arrChat.count-1, section: 0)
                    self.tbleView?.scrollToRow(at: indexpath as IndexPath, at: .bottom, animated: true)
                }
  
            }
            else
            {
                self.tbleView.reloadData()
            }
           
        }
    }

        
    @IBAction func action_speechBtnTapped(_ sender: UIButton)
    {
        
    }
    @IBAction func action_makeFinalOfferBtnTapped(_ sender: UIButton)
    {
        if tfPrice.text != ""
        {
            makeOfferAPi()
        }
        else
        {
            self.view.makeToast(NSLocalizedString("Please enter price.", comment: ""), duration: 3.0, position: .center)
        }
        viewAlpha.isHidden = true
        
    }
}
extension MakeOfferChatVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return  arrChat.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrChat.count != 0
        {
            if let tempDic1 : Dictionary = arrChat[indexPath.row] as? Dictionary<String,Any>
             {
                if let getSendUserId : String = tempDic1["sendByUserId"] as? String
                {
                  let userIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
                 if getSendUserId == userIdStr
                 {
                    if let getType : Int = tempDic1["type"] as? Int
                    {
                      if getType == 1
                      {
                        let Cell:ChatImageTableViewCell = tbleView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
                        Cell.selectionStyle = .none
                        Cell.btnImgTap.tag = indexPath.row
                        Cell.btnImgTap.isHidden = false
                        Cell.btnImgTap.addTarget(self, action: #selector(ImgTapped(sender:)), for: .touchUpInside)
                        if let getImage : String = tempDic1["message"] as? String
                        {
                            if  getImage != ""
                            {
                                    let imgName = getImage
                                    var imageUrl = BaseViewController.IMG_URL
                                    imageUrl.append(imgName)
                              
                            
                                defaultValues.synchronize()
                                Cell.imgView.sd_setShowActivityIndicatorView(true)
                                Cell.imgView.sd_setIndicatorStyle(.gray)
                                Cell.imgView!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:#imageLiteral(resourceName: "iconDe"), options: .refreshCached , progress: nil, completed: nil)
                   
                                    
                                }
                           
                                Cell.lblMakeOfferPrice.text = ""
                                Cell.lblMakeOfferPrice.isHidden = true
                                Cell.lblMakeOffer.isHidden = true
                                Cell.heightConstImgView.constant = 150
                                Cell.imgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                Cell.imgView.layer.cornerRadius = 5
                            }
                        
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                      else if getType == 2
                      {
                        let Cell:MakeOfferItemTableViewCell = tbleView.dequeueReusableCell(withIdentifier: "MakeOfferItemTableViewCell", for: indexPath) as! MakeOfferItemTableViewCell
                       
                    
                        if let getImage : String = tempDic1["message"] as? String
                        {
                            Cell.lblPrice.text = "\(getImage)"
                          
                            Cell.viewBgPrice.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                            Cell.viewBgPrice.layer.cornerRadius = 5
                            
                        }
                             
                        
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                      else
                      {
                        let Cell:senderTblcell = tbleView.dequeueReusableCell(withIdentifier: "senderTblcell", for: indexPath) as! senderTblcell
                        if let getMessage : String = tempDic1["message"] as? String
                        {
                            
                            Cell.sendTxt.text = getMessage
                        }
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                    }
                    else
                    {
                        let Cell:senderTblcell = tbleView.dequeueReusableCell(withIdentifier: "senderTblcell", for: indexPath) as! senderTblcell
                        return Cell
                    }
                    
                    
                 }
                 else
                 {
                    if let getType : Int = tempDic1["type"] as? Int
                    {
                      if getType == 1
                      {
                        let Cell:ChatImagesReceiverTableViewCell = tbleView.dequeueReusableCell(withIdentifier: "ChatImagesReceiverTableViewCell", for: indexPath) as! ChatImagesReceiverTableViewCell
                        Cell.btnImgTap.tag = indexPath.row
                        Cell.btnImgTap.isHidden = false
                        Cell.btnImgTap.addTarget(self, action: #selector(ImgTapped(sender:)), for: .touchUpInside)
                        Cell.btnProfile.tag = indexPath.row
                        Cell.btnProfile.addTarget(self, action: #selector(ProfileBtnTapped(sender:)), for: .touchUpInside)
                        Cell.selectionStyle = .none
                        if  imgUrl != ""
                        {
                                let imgName = imgUrl
                                var imageUrl = BaseViewController.IMG_URL
                                imageUrl.append(imgName)
                          
                        
                          
                            Cell.profileImg.sd_setShowActivityIndicatorView(true)
                            Cell.profileImg.sd_setIndicatorStyle(.gray)
                            Cell.profileImg!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:#imageLiteral(resourceName: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
               
                                
                        }
                        else
                        {
                            Cell.profileImg.image = #imageLiteral(resourceName: "userIcon")
                        }
                        if let getImage : String = tempDic1["message"] as? String
                        {
                            if  getImage != ""
                            {
                                    let imgName = getImage
                                    var imageUrl = BaseViewController.IMG_URL
                                    imageUrl.append(imgName)
                              
                            
                                
                                Cell.imgView.sd_setShowActivityIndicatorView(true)
                                Cell.imgView.sd_setIndicatorStyle(.gray)
                                Cell.imgView!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:#imageLiteral(resourceName: "iconDe"), options: .refreshCached , progress: nil, completed: nil)
                   
                                    
                                }
                           
                                Cell.lblMakeOfferPrice.text = ""
                                Cell.lblMakeOfferPrice.isHidden = true
                                Cell.lblMakeOffer.isHidden = true
                                Cell.heightConstImgView.constant = 150
                                Cell.imgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                Cell.imgView.layer.cornerRadius = 5
                            }
                        
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                      else if getType == 2
                      {
                        let Cell:MakeOfferItemReceiverTableViewCell = tbleView.dequeueReusableCell(withIdentifier: "MakeOfferItemReceiverTableViewCell", for: indexPath) as! MakeOfferItemReceiverTableViewCell
                        Cell.selectionStyle = .none
                      
                        Cell.btnProfile.tag = indexPath.row
                        Cell.btnProfile.addTarget(self, action: #selector(ProfileBtnTapped(sender:)), for: .touchUpInside)
                        if  imgUrl != ""
                        {
                                let imgName = imgUrl
                                var imageUrl = BaseViewController.IMG_URL
                                imageUrl.append(imgName)
                          
                        
                            
                            Cell.imgprofile.sd_setShowActivityIndicatorView(true)
                            Cell.imgprofile.sd_setIndicatorStyle(.gray)
                            Cell.imgprofile!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:#imageLiteral(resourceName: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
               
                                
                        }
                        else
                        {
                            Cell.imgprofile.image = #imageLiteral(resourceName: "userIcon")
                        }
                        if let getImage : String = tempDic1["message"] as? String
                        {
                            Cell.lblPrice.text = "\(getImage)"
                          
                            Cell.viewBgPrice.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
                            Cell.viewBgPrice.layer.cornerRadius = 5
                          
                        }
                             
                        
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                      else
                      {
                        let Cell:receiverTblCell = tbleView.dequeueReusableCell(withIdentifier: "receiverTblCell", for: indexPath) as! receiverTblCell
                        Cell.btnProfile.tag = indexPath.row
                        Cell.btnProfile.addTarget(self, action: #selector(ProfileBtnTapped(sender:)), for: .touchUpInside)
                        if  imgUrl != ""
                        {
                                let imgName = imgUrl
                                var imageUrl = BaseViewController.IMG_URL
                                imageUrl.append(imgName)
                          
                        
                           
                            Cell.imgView.sd_setShowActivityIndicatorView(true)
                            Cell.imgView.sd_setIndicatorStyle(.gray)
                            Cell.imgView!.sd_setImage(with:URL(string: imageUrl) , placeholderImage:#imageLiteral(resourceName: "userIcon"), options: .refreshCached , progress: nil, completed: nil)
               
                                
                        }
                        else
                        {
                            Cell.imgView.image = #imageLiteral(resourceName: "userIcon")
                        }
                        if let getMessage : String = tempDic1["message"] as? String
                        {
                            
                            Cell.reciveTxt.text = getMessage
                        }
                        if let getDate : Int = tempDic1["addedDate"] as? Int
                        {
                            let valueTime = "\(getDate)"
                            let reviewTime = Double(valueTime)
                         
                            if reviewTime != nil
                            {
                                let dateTimeStamp = NSDate(timeIntervalSince1970:Double(reviewTime ?? 0.0)/1000)  //UTC time  //YOUR currentTimeInMiliseconds METHOD
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            

                                let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
                                print("Local Time", strDateSelect) //Local time
                                let messageTime = dateFormatter.date(from: strDateSelect)
                                Cell.lblDate.text = messageTime?.timeAgoSinceNow
                            }
                        }
                        
                        return Cell
                      }
                    }
                    else
                    {
                        let Cell:receiverTblCell = tbleView.dequeueReusableCell(withIdentifier: "receiverTblCell", for: indexPath) as! receiverTblCell
                        return Cell
                    }
                    
                 }
                
                }
                else
                {
                    let Cell:receiverTblCell = tbleView.dequeueReusableCell(withIdentifier: "receiverTblCell", for: indexPath) as! receiverTblCell
                    return Cell
                }
            }
            else
            {
                let Cell:senderTblcell = tbleView.dequeueReusableCell(withIdentifier: "senderTblcell", for: indexPath) as! senderTblcell
                return Cell
            }
           

        }
        else
        {
            let Cell:senderTblcell = tbleView.dequeueReusableCell(withIdentifier: "senderTblcell", for: indexPath) as! senderTblcell
            return Cell
        }
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    @objc func ProfileBtnTapped(sender:UIButton)
    {
        let objRef:UserFollowVC = self.storyboard?.instantiateViewController(withIdentifier: "UserFollowVC") as! UserFollowVC
        if let tempDic1 : Dictionary = arrChat[sender.tag] as? Dictionary<String,Any>
         {
            if let getSendUserId : String = tempDic1["sendByUserId"] as? String
            {
                objRef.followUserId = getSendUserId
            }
        }
     
        objRef.userName = userName
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    @objc func ImgTapped(sender:UIButton)
    {
        if arrChat.count != 0
        {
            
            let objRef:ImageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
           
           
            
            if let tempDic1 : Dictionary = arrChat[sender.tag] as? Dictionary<String,Any>
             {
                  if let getImage : String = tempDic1["message"] as? String
                  {
                    objRef.ImgUrl = getImage
                  }
             }
            objRef.screenType = "Chat"
            objRef.modalPresentationStyle = .fullScreen
            self.present(objRef, animated: true, completion: nil)
        }
    }
    func validateIFSC(code : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
        return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM dd, yyyy - hh:mm a"
        return  dateFormatter.string(from: date!)

    }

//MARK:- Web Services
    func makeOfferAPi()
    {
       
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        var buyerUserIdStr = ""
        var sellerUserIdStr = ""
        var typeSellerBuyerStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserIdStr = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
        }
        else
        {
          if typeSellerBuyer == "seller"
          {
            sellerUserIdStr = sellerUserId
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
          }
          else
          {
            sellerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            buyerUserIdStr =  sellerUserId
            typeSellerBuyerStr = "to_buyer"
          }
            
        }
       
        
        let params: [String: Any] = ["nego_price":tfPrice.text ?? "","item_id":itemId,"buyer_user_id":buyerUserIdStr,"seller_user_id":sellerUserIdStr,"type":typeSellerBuyerStr]
  
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/update_price/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
            if error == nil{
                self.objHudHide()
       self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
           
       if self.getChatModel.status != "error"
       {
        self.sendMessageWithProperty(getText:"$ \(self.getChatModel.negoPrice ?? "")", getType: 2, getOfferStatus: 1)
        self.getOfferDetailAPi()
        
       }else{
        self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
       }

        }
            self.objHudHide()
        
    }



    }
    func makeOfferAcceptedAPi(getPrice:String)
    {
       
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        var buyerUserIdStr = ""
        var sellerUserIdStr = ""
        var typeSellerBuyerStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserIdStr = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
        }
        else
        {
          if typeSellerBuyer == "seller"
          {
            sellerUserIdStr = sellerUserId
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
          }
          else
          {
            sellerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            buyerUserIdStr =  sellerUserId
            typeSellerBuyerStr = "to_buyer"
          }
            
        }
       
        
        let params: [String: Any] = ["nego_price":getPrice,"item_id":itemId,"buyer_user_id":buyerUserIdStr,"seller_user_id":sellerUserIdStr,"type":typeSellerBuyerStr]
  
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/update_accept/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
            if error == nil{
                self.objHudHide()
       self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
           
       if self.getChatModel.status != "error"
       {
        self.sendMessageWithProperty(getText:"$ \(self.getChatModel.negoPrice ?? "")", getType: 2, getOfferStatus: 1)
      
        
       }else{
        self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
       }

        }
            self.objHudHide()
        
    }



    }

    func getOfferDetailAPi()
    {
       
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        var buyerUserIdStr = ""
        var sellerUserIdStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserId = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            sellerUserIdStr = sellerUserId
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
        }
        else
        {
            if typeSellerBuyer == "seller"
            {
              sellerUserIdStr = sellerUserId
              buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
              
            }
            else
            {
              sellerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
              buyerUserIdStr =  sellerUserId
             
            }
        }
       
        let userIdStr = defaultValues.value(forKey: "UserID") as? String ?? ""
        let params: [String: Any] = ["item_id":itemId,"buyer_user_id":buyerUserIdStr,"seller_user_id":sellerUserIdStr]
  
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/get_chat_history/api_key/teampsisthebest", parameters: params) { (response, error) in
            if error == nil{
                self.objHudHide()
       self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
           
       if self.getChatModel.status != "error"
       {
       
        if let data = self.getChatModel.item
        {
            self.getAddItemModel = data
        }
      
        if self.getChatModel.isOffer == "1"
           {
            self.btnMakeOffer.isHidden = true
           }
           else
           {
                self.btnMakeOffer.isHidden = false
           }
        
       }else{
        self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
       }

        }
            self.objHudHide()
        
    }



    }
    
    
//func getChatAPi(return_Type:String)
//{
//    objHudShow()
//    var deviceID = ""
//    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//      print(uuid)
//        deviceID = uuid
//    }
//    var userIdStr = defaultValues.value(forKey: "UserID") as? String ?? ""
//    let params: [String: Any] = ["user_id":userIdStr,"item_id":"","buyer_user_id":"","seller_user_id":""]
//
//    print(params);
//
//    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/get_chat_history/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
//        if error == nil{
//            self.objHudHide()
//   self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
//
//   if self.getChatModel.status != "error"
//   {
////       if let data = self.getMessagesModel.ratingDetails
////       {
////
////       }
//
//   }else{
//    self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
//   }
//
//    }
//        self.objHudHide()
//
//}
//
//
//
//}


    //MARK:- Web Services
    func sendMessageAPi()
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        var buyerUserIdStr = ""
        var sellerUserIdStr = ""
        var typeSellerBuyerStr = ""
        if screenType == "Product"
        {
            getAddItemUser = self.getProductItemDetailModel.user
            sellerUserIdStr = self.getAddItemUser.userId ?? ""
            itemId = self.getProductItemDetailModel.id ?? ""
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
        }
        else
        {
          if typeSellerBuyer == "seller"
          {
            sellerUserIdStr = sellerUserId
            buyerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            typeSellerBuyerStr = "to_seller"
          }
          else
          {
            sellerUserIdStr = "\(defaultValues.value(forKey: "UserID") as? String ?? "")"
            buyerUserIdStr =  sellerUserId
            typeSellerBuyerStr = "to_buyer"
          }
            
        }
       
        let params: [String: Any] = ["type":typeSellerBuyerStr,"item_id":itemId,"buyer_user_id":buyerUserIdStr,"seller_user_id":sellerUserIdStr]
        
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/add/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
            if error == nil{
                self.objHudHide()
       self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
           
       if self.getChatModel.status != "error"
       {
        print("Sccuess")
        self.isFirstMessage = false
        defaultValues.setValue(self.itemId, forKey: "isFirstMessage")
        defaultValues.synchronize()
     
        
       }else{
        self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
       }

        }
            self.objHudHide()
    }
    }
    func addChatImage(getImage:UIImage,getType:String,getBuyerId:String,getSellerId:String,getSenderId:String)
        {
       
             let UserId = defaultValues.value(forKey: "UserID") ?? ""
             let parameters: [String:Any] =  [
            
             "sender_id":getSenderId,
             "buyer_user_id":getBuyerId,
             "seller_user_id":getSellerId,
             "item_id":itemId,
             "type":getType
                
            
            ]
            
          objHudShow()
          print("*************")
            
            
         
             
        print(parameters)
            
        let image1 = getImage
             
            
            
        guard let imgData1 = image1.jpegData(compressionQuality: 0.1) else{return}
//            if imgType == "png" {
//                imgData1 = image1.pngData()!
//            }
            
           
            
               Alamofire.upload(multipartFormData: {
                multipartFormData in
                multipartFormData.append(imgData1, withName: "file",fileName: self.imgName, mimeType: "image/jpg/png/jpeg")
                
                   for (key, value) in parameters {
                       multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                   }
               }, usingThreshold: UInt64.init(),to: BaseViewController.API_URL+"rest/images/chat_image_upload/api_key/teampsisthebest", method: .post, headers: WebService().headersintoApi()) { (result) in
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
                           let status =  "\(jsonDict["img_path"] ?? "")"
                           if status != ""
                           {
                           
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5)
                            {
                                self.sendMessageWithProperty(getText:"\(status)", getType: 1, getOfferStatus: 0)
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
extension Date {

    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }

    private func getTimeAgoSinceNow() -> String {

        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" Year ago", comment: "") : "\(interval)" + NSLocalizedString(" Year ago", comment: "")
        }

        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" Months ago", comment: "") : "\(interval)" + NSLocalizedString(" Months ago", comment: "")
        }
        interval = Calendar.current.dateComponents([.weekOfMonth], from: self, to: Date()).weekOfMonth!
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" week ago", comment: "") : "\(interval)" + NSLocalizedString(" week ago", comment: "")
        }
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" Days ago", comment: "") : "\(interval)" + NSLocalizedString(" Days ago", comment: "")
        }

        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" Hour ago", comment: "") : "\(interval)" + NSLocalizedString(" Hour ago", comment: "")
        }

        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
        if interval > 0
        {
            return interval == 1 ? "\(interval)" + NSLocalizedString(" Minute ago", comment: "") : "\(interval)" + NSLocalizedString(" Minute ago", comment: "")
        }

        return NSLocalizedString("Few seconds ago", comment: "")
    }
}


extension Date {
    func getElapsedInterval() -> String {

        var calendar = Calendar.current
        calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
    // IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN
    // WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE
    // (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME
    // IS GOING TO APPEAR IN SPANISH

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.calendar = calendar

        var dateString: String?

        let interval = calendar.dateComponents([.year, .month, .weekOfYear, .day , .hour , .minute , .second], from: self, to: Date())

        if let year = interval.year, year > 0
         {
            formatter.allowedUnits = [.year] //2 years
         }
        else if let month = interval.month, month > 0
         {
            formatter.allowedUnits = [.month] //1 month
         }
        else if let week = interval.weekOfYear, week > 0
         {
            formatter.allowedUnits = [.weekOfMonth] //3 weeks
         }
        else if let day = interval.day, day > 0
         {
            formatter.allowedUnits = [.day] // 6 days
         }

        else
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Bundle.main.preferredLocalizations[0]) //--> IF THE USER HAVE THE PHONE IN SPANISH BUT YOUR APP ONLY SUPPORTS I.E. ENGLISH AND GERMAN WE SHOULD CHANGE THE LOCALE OF THE FORMATTER TO THE PREFERRED ONE (IS THE LOCALE THAT THE USER IS SEEING THE APP), IF NOT, THIS ELAPSED TIME IS GOING TO APPEAR IN SPANISH
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            dateString = dateFormatter.string(from: self) // IS GOING TO SHOW 'TODAY'
        }

        if dateString == nil
        {
            dateString = formatter.string(from: self, to: Date())
        }

        return dateString!
}
}
