//
//  OffersTableViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 28/05/21.
//

import UIKit

class OffersTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnOffered: UIButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTotalCount: UILabel!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTotalCount.layer.cornerRadius = lblTotalCount.frame.height/2
        lblTotalCount.layer.masksToBounds = true
    }

}
