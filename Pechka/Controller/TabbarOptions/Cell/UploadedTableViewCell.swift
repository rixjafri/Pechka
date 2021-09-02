//
//  UploadedTableViewCell.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit

class UploadedTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int)
       {
           collectionView.register(UINib(nibName: "UploadedCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UploadedCollectionViewCell")
           collectionView.delegate = dataSourceDelegate
           collectionView.dataSource = dataSourceDelegate
           collectionView.layoutIfNeeded()
           collectionView.reloadData()
           collectionView.showsHorizontalScrollIndicator = false
       }
    
}
