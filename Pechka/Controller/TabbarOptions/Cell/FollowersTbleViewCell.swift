//
//  FollowersTbleViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 27/05/21.
//

import UIKit
import FloatRatingView

class FollowersTbleViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var lblJoined: UILabel!
    @IBOutlet weak var viewRating: FloatRatingView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = imgView.frame.height/2
    }

   
}
