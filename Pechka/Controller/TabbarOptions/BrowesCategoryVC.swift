//
//  BrowesCategoryVC.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit
import Alamofire

class BrowesCategoryVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var getCategory = NSMutableArray()
    var catId = ""
    var catName = ""
    var subCatId = ""
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Custom Methods
    func setInitials()
    {
    
        collectionView.delegate = self
        collectionView.dataSource = self
        if catId == ""
        {
            collectionView.reloadData()
            lblTitle.setTitle(NSLocalizedString("What is your interest?", comment: ""), for: .normal)
        }
        else
        {
            getSubCategoryListApi()
            lblTitle.setTitle(catName, for: .normal)
        }
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
        
            return getCategory.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
    
     let cell:IntrestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntrestCollectionViewCell", for: indexPath) as! IntrestCollectionViewCell
        cell.viewBg.layer.cornerRadius = 5
        if let tempDic1 : Dictionary = getCategory[indexPath.row] as? Dictionary<String,Any>
         {
            if catId != ""
            {
                if let getCatName : String = tempDic1["name"] as? String
                {
                    cell.lblTitle.text = getCatName
                }
                
            }
            else
            {
                if let getCatName : String = tempDic1["cat_name"] as? String
                {
                    cell.lblTitle.text = getCatName
                }
                
            }
            
            if let getSliderName : Dictionary = tempDic1["default_photo"] as? Dictionary<String,Any>
            {
                if let getSliderNameImg : String = getSliderName["img_path"] as? String
                {
                    var imageUrl =  BaseViewController.IMG_URL
                        imageUrl.append(getSliderNameImg)
                    
                    cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "iconDe"))
                    cell.imgView.layer.cornerRadius = 5
                    cell.imgView.layer.masksToBounds = true
                }
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
       return 100
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
        if catId == ""
        {
            let objRef:BrowesCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BrowesCategoryVC") as! BrowesCategoryVC
            if let tempDic1 : Dictionary = getCategory[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["cat_id"] as? String
                {
                    objRef.catId = getId
                    if let getCatName : String = tempDic1["cat_name"] as? String
                    {
                        objRef.catName = getCatName
                    }
                    if let getCatName : String = tempDic1["id"] as? String
                    {
                        objRef.subCatId = getCatName
                    }
                    
                }
            }
           
            self.navigationController?.pushViewController(objRef, animated: true)
        }
        else
        {
            let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
            if let tempDic1 : Dictionary = getCategory[indexPath.row] as? Dictionary<String,Any>
             {
                if let getId : String = tempDic1["cat_id"] as? String
                {
                    objRef.CatId = getId
                    if let getCatName : String = tempDic1["id"] as? String
                    {
                        objRef.subCatId = getCatName
                    }
                }
                if let getCatName : String = tempDic1["name"] as? String
                {
                    objRef.titleName = getCatName
                    objRef.CatName = getCatName
                }
            }
           
            
            self.navigationController?.pushViewController(objRef, animated: true)
          
        }
        }
       

    //MARK:- Web Services
    func getSubCategoryListApi()
     {
            //self.objHudShow()
            //self.blurEffect.isHidden = false

         let headers1 = [
             "Accept": "application/json"
            
         ]
    

      let parametersList:[String : Any] = [
        :
          ]

      Alamofire.request(BaseViewController.API_URL+"rest/subcategories/get/api_key/teampsisthebest/cat_id/\(catId)/limit/30/offset/0", method: .get , parameters: parametersList,headers:headers1).responseJSON{ response in

            switch response.result {

            case .success (let value):
                if (value as AnyObject).count != 0
                {
                    let resultsArray = value as? [AnyObject]
                    self.getCategory.removeAllObjects()
                    if resultsArray?.count != 0 && resultsArray != nil
                    {
                        for i in 0..<resultsArray!.count
                        {
                            self.getCategory.insert(resultsArray?[i], at: self.getCategory.count)
                        }
                    }
                }
         
                
               
                print(self.getCategory)
                self.collectionView.reloadData()

            break

            case .failure:
            //self.objHudHide();
            // self.refreshControl.endRefreshing()

           // self.blurEffect.isHidden = true

            //self.view.makeToast(NSLocalizedString("No data available", comment: ""), duration: 3.0, position: .bottom)

            break
            }
          }
 }
}
