//
//  promoteTbleViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 01/06/21.
//

import UIKit

class promoteTbleViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnSelectUnSelect: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnTapItem: UIButton!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        defaultValues.setValue(nil, forKey: "PromotePrice")
        defaultValues.synchronize()
        tfPrice.delegate = self
    }

   
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == tfPrice
        {
          
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
       if textField == tfPrice
         {
            let custDesiredPrice = Int(tfPrice.text!)
            defaultValues.setValue(custDesiredPrice, forKey: "PromotePrice")
            defaultValues.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatePrice"), object: nil, userInfo: nil)
         }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
         if textField == tfPrice
            {
                let custDesiredPrice = Int(tfPrice.text!)
                defaultValues.setValue(custDesiredPrice, forKey: "PromotePrice")
                defaultValues.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatePrice"), object: nil, userInfo: nil)
            }
    }
}
