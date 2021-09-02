//
//  LandingScreenVC.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit

class LandingScreenVC: UIViewController {

    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    //MARK:- IBActions
    @IBAction func action_landBtnTapped(_ sender: UIButton)
    {
        APPDELEGATE.userTabbar()
    }
    
   

}
