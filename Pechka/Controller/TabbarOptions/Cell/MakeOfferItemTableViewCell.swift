//
//  MakeOfferItemTableViewCell.swift
//  Pechka
//
//  Created by Neha'Mac on 15/06/21.
//

import UIKit

class MakeOfferItemTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBgPrice: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblTitlePrice: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var heightStackAcceptReject: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnReject.layer.borderWidth = 1
        btnReject.layer.borderColor = BaseViewController.appColor.cgColor
        btnReject.layer.cornerRadius = 15
        btnReject.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        btnAccept.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btnAccept.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnAccept.layer.cornerRadius = 15
        btnAccept.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]    }

   
    
}
