//
//  UserFollowTbleViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 20/05/21.
//

import UIKit
import FloatRatingView

class UserFollowTbleViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobileNum: UILabel!
    @IBOutlet weak var viewrating: FloatRatingView!
    @IBOutlet weak var imgUser: UIImageView!
 
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblverfied: UILabel!
   
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
