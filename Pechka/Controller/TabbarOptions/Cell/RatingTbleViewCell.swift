//
//  RatingTbleViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit
import FloatRatingView

class RatingTbleViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var widthStackView: NSLayoutConstraint!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNum: UILabel!
    @IBOutlet weak var viewrating: FloatRatingView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTotalRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblverfied: UILabel!
    @IBOutlet weak var btnFacebookVer: UIButton!
    @IBOutlet weak var btnVerifiedGoogle: UIButton!
    @IBOutlet weak var btnCallVer: UIButton!
    @IBOutlet weak var btnGmailVer: UIButton!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTotalRating.layer.cornerRadius = 5
        lblTotalRating.clipsToBounds = true
    }

   

}
