//
//  SlidersCollectionViewCell.swift
//  CleanMart
//
//  Created by Macbook2012 on 02/03/21.
//

import UIKit

class SlidersCollectionViewCell: UICollectionViewCell {

    
    //MARK:- IBOutlets
    @IBOutlet var bgView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var viewPg: UIView!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.shadowColor = UIColor.lightGray.cgColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowOffset = CGSize(width: -1, height: 1)
        bgView.layer.shadowRadius = 1
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds =  false
    }

}
