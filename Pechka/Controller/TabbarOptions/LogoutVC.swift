//
//  LogoutVC.swift
//  Pechka
//
//  Created by Neha Saini on 21/05/21.
//

import UIKit

class LogoutVC: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var viewCustom: UIView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        btnYes
            .layer.backgroundColor = BaseViewController.appColor.cgColor
        btnYes.layer.cornerRadius = 15
        btnYes.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        btnNo.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        btnNo.layer.cornerRadius = 15
        btnNo.layer.borderWidth = 1
        btnNo.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        viewCustom.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- IBActions
    @IBAction func action_yesBtnTapped(_ sender: UIButton)
    {
        defaultValues.set(nil, forKey: "UserID")
        defaultValues.set(nil, forKey: "userName")
        defaultValues.set(nil, forKey: "profile")
        defaultValues.set(nil, forKey: "addedDate")
        defaultValues.set(nil, forKey: "ratingCount")
        defaultValues.set(nil, forKey: "followingCount")
        defaultValues.set(nil, forKey: "followerCount")
        defaultValues.set(nil, forKey: "History")
        defaultValues.synchronize()
        APPDELEGATE.configureSideMenu()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func action_noBtnTapped(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
