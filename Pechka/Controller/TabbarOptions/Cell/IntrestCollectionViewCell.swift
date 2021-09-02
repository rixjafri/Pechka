//
//  IntrestCollectionViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 06/05/21.
//

import UIKit

class IntrestCollectionViewCell: UICollectionViewCell {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSub: UIImageView!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        imgSub.layer.cornerRadius = imgSub.frame.height/2
    }

}
