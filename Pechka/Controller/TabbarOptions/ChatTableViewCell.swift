//
//  ChatTableViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 06/05/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblMessageCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
