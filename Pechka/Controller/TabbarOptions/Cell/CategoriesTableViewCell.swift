//
//  CategoriesTableViewCell.swift
//  CleanMart
//
//  Created by Macbook2012 on 02/03/21.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int)
       {
           collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
           collectionView.delegate = dataSourceDelegate
           collectionView.dataSource = dataSourceDelegate
           collectionView.layoutIfNeeded()
           collectionView.reloadData()
           
           collectionView.showsHorizontalScrollIndicator = false
       }
    
}
