//
//  CategoryCollectionViewCell.swift
//  CleanMart
//
//  Created by Neha Saini on 14/03/21.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        imgView.layer.cornerRadius = imgView.frame.height/2
    }

}
