//
//  ChatVC.swift
//  Pechka
//
//  Created by Neha Saini on 10/05/21.
//

import UIKit
import ObjectMapper

class ChatVC: BaseViewController, UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnSpeech: UIButton!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewBgTf: UIView!
    @IBOutlet weak var BtnMore: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfSendMessage: UITextField!
    @IBOutlet weak var lblNoMessage: UILabel!
    @IBOutlet weak var tbleView: UITableView!
    
  
    
    //MARK:- Variable Declaration
    var refreshControl = UIRefreshControl()
    var getChatModel:ChatModel!
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
        
        tbleView.delegate = self
        tbleView.dataSource = self
        tfSendMessage.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
          tap.cancelsTouchesInView = false
          view.addGestureRecognizer(tap)
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tbleView.addSubview(refreshControl) // n
    }
    
    
    @objc func dismissKeyboard() {
          //Causes the view (or one of its embedded text fields) to resign the first responder status.
          view.endEditing(true)
    }
    
    @objc func refresh(_ sender: AnyObject)
    {
      
        refreshControl.endRefreshing()
    }
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_moreBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func action_sendBtnTapped(_ sender: UIButton)
    {
        if tfSendMessage.text != ""
        {
          self.view.makeToast(NSLocalizedString("Please enter message.", comment: ""), duration: 3.0, position: .center)
          
        }
    }
    
    @IBAction func action_galleryBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_speechBtnTapped(_ sender: UIButton)
    {
        
    }
}

extension ChatVC: UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let Cell:senderTblcell = tbleView.dequeueReusableCell(withIdentifier: "senderTblcell", for: indexPath) as! senderTblcell
            return Cell
        }
        else
        {
            let Cell:receiverTblCell = tbleView.dequeueReusableCell(withIdentifier: "receiverTblCell", for: indexPath) as! receiverTblCell
            return Cell
        }
       
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
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
func getChatAPi(return_Type:String)
{
    objHudShow()
    var deviceID = ""
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
      print(uuid)
        deviceID = uuid
    }
    var userIdStr = defaultValues.value(forKey: "UserID") as? String ?? ""
    let params: [String: Any] = ["user_id":userIdStr,"item_id":"","buyer_user_id":"","seller_user_id":""]
    
    print(params);
    
    WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/get_chat_history/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
        if error == nil{
            self.objHudHide()
   self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
       
   if self.getChatModel.status != "error"
   {
//       if let data = self.getMessagesModel.ratingDetails
//       {
//
//       }
    
   }else{
    self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
   }

    }
        self.objHudHide()
    
}



}


    //MARK:- Web Services
    func sendMessageAPi(return_Type:String)
    {
        objHudShow()
        var deviceID = ""
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
          print(uuid)
            deviceID = uuid
        }
        var userIdStr = defaultValues.value(forKey: "UserID") as? String ?? ""
        let params: [String: Any] = ["user_id":userIdStr,"item_id":"","buyer_user_id":"","seller_user_id":""]
        
        print(params);
        
        WebService.shared.apiPostClient(url: BaseViewController.API_URL+"rest/chats/add/api_key/teampsisthebest/limit/30/offset/0", parameters: params) { (response, error) in
            if error == nil{
                self.objHudHide()
       self.getChatModel = Mapper<ChatModel>().map(JSONObject: response)
           
       if self.getChatModel.status != "error"
       {
    //       if let data = self.getMessagesModel.ratingDetails
    //       {
    //
    //       }
        
       }else{
        self.view.makeToast(NSLocalizedString(self.getChatModel.message ?? "", comment: ""), duration: 1.0, position: .center)
       }

        }
            self.objHudHide()
    }
    
   
    
}
    
  


}
extension String
{
    func isStringAnInt() -> Bool {
        
        if let _ = Int(self) {
            return true
        }
        return false
    }
}
extension String {
    
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
