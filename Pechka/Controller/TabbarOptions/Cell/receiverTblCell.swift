//
//  receiverTblCell.swift
//  JopPosting
//
//  Created by POSSIBILITY on 16/07/20.
//  Copyright © 2020 POSSIBILITY. All rights reserved.
//

import UIKit

class receiverTblCell: UITableViewCell {

    
    //MARK:- IBOutlets
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var receiverView: UIView!
    @IBOutlet weak var reciveTxt: UITextView!
    @IBOutlet var lblDate: UILabel!

    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reciveTxt.sizeToFit()
        reciveTxt.isScrollEnabled = false
        reciveTxt.textColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
        receiverView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        Helper.BottemedgeviewCorner(viewoutlet: receiverView, radius: 5)
    }

   
}
