//
//  ChatImagesReceiverTableViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 10/06/21.
//

import UIKit

class ChatImagesReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var btnImgTap: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var heightConstImgView: NSLayoutConstraint!
    @IBOutlet weak var lblMakeOffer: UILabel!
    @IBOutlet weak var lblMakeOfferPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
