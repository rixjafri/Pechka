//
//  GalleryVC.swift
//  Pechka
//
//  Created by Neha Saini on 20/05/21.
//

import UIKit

class GalleryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK:- IBOutlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variable Declartion
    var getAddItemDefaultPhoto: AddItemDefaultPhoto!
    //MARK:- View Lifw Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- Custom Methods
    func setInitials()
    {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Collection View data source and delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return APPDELEGATE.getImages.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
     let cell:GalleryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        if let tempDic1 : Dictionary = APPDELEGATE.getImages[indexPath.row] as? Dictionary<String,Any>
         {
          
          
                if let getSliderNameImg : String = tempDic1["img_path"] as? String
                {
                    var imageUrl =  BaseViewController.IMG_URL
                        imageUrl.append(getSliderNameImg)
                    
                    cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                    cell.imgView.layer.cornerRadius = 5
                    cell.imgView.layer.masksToBounds = true
                }
            
            
        }
      
    return cell
   
    }



     func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
     {

     }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let yourWidth = collectionView.frame.width/3
        // let yourHeight = yourWidth

      return  CGSize(width: yourWidth, height:yourWidth)
      
    
    }

     func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
     {
        let yourWidth = collectionView.frame.width/3
       return yourWidth
     }
     func scrollCollectionView(indexpath:IndexPath,collectionView:UICollectionView)
       {
        // collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
         //collectionView.selectItem(at: indexpath, animated: true, scrollPosition: .left)
        // collectionView.scrollToItem(at: indexpath, at:.left, animated: true)

     }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
      if let tempDic1 : Dictionary = APPDELEGATE.getImages[indexPath.row] as? Dictionary<String,Any>
      {
        if let getSliderNameImg : String = tempDic1["img_path"] as? String
        {
            var imageUrl =  BaseViewController.IMG_URL
                imageUrl.append(getSliderNameImg)
            let objRef:ImageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            objRef.ImgUrl = imageUrl
            objRef.modalPresentationStyle = .fullScreen
            self.present(objRef, animated: true, completion: nil)
        }
      }
    
    }
}
