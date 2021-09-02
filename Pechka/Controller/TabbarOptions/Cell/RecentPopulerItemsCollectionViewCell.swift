//
//  RecentPopulerItemsCollectionViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit

class RecentPopulerItemsCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IBOutltes
    @IBOutlet weak var constHeightImg: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnItemTap: UIButton!
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet weak var viewSold: UIView!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBG.layer.cornerRadius = 10
        viewBG.layer.borderWidth = 1
        viewBG.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        constHeightImg.constant = imgProduct.frame.width
        imgUser.layer.cornerRadius = imgUser.frame.height/2
        
    }
}
