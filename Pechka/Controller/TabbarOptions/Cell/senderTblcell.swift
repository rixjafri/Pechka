//
//  senderTblell.swift
//  JopPosting
//
//  Created by POSSIBILITY on 16/07/20.
//  Copyright © 2020 POSSIBILITY. All rights reserved.
//

import UIKit

class senderTblcell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var senderView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendTxt: UITextView!
    @IBOutlet var lblDate: UILabel!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sendTxt.sizeToFit()
        sendTxt.isScrollEnabled = false
        sendTxt.textColor = #colorLiteral(red: 0.4431372549, green: 0.4431372549, blue: 0.4431372549, alpha: 1)
        senderView.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.3411764706, blue: 0.1333333333, alpha: 0.11)
        Helper.TopedgeviewCorner(viewoutlet: senderView, radius: 5)
       
    }


}
