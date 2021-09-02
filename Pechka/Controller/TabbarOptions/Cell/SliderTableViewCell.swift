//
//  SliderTableViewCell.swift
//  CleanMart
//
//  Created by Macbook2012 on 02/03/21.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    
    //MARK:- IBOulets
    @IBOutlet weak var viewPg: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int)
       {
           collectionView.register(UINib(nibName: "SlidersCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SlidersCollectionViewCell")
           collectionView.delegate = dataSourceDelegate
           collectionView.dataSource = dataSourceDelegate
           collectionView.layoutIfNeeded()
           collectionView.reloadData()
           
           collectionView.showsHorizontalScrollIndicator = false
       }
   
}
