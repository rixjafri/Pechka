//
//  AboutUsVC.swift
//  Pechka
//
//  Created by Neha Saini on 20/05/21.
//

import UIKit

class AboutUsVC: UIViewController,UITextViewDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    //MARK:- Variable Declaration
    var saftyText = ""
    
    //MARK:- View Life Cycle
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
        txtView.delegate = self
        self.txtView.text = saftyText
    }
    
    //MARK:- IBActions
    @IBAction func action_backBtnTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
