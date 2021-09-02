//
//  UserSideMenuVC.swift
//  FindAuto
//
//  Created by PBS9 on 11/09/19.
//  Copyright © 2019 Possibilty. All rights reserved.
//

import UIKit

class UserSideMenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK:- Variable Declaration
    let menuNames = ["Home","Logout"]
    let icons = ["home","logout"]

    var businessStatus = Int()
    var name  = ""
    var number = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "SidemenuCell", bundle: nil), forCellReuseIdentifier: "SidemenuCell")
        tableview.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")

    }
    
    //MARK:- Tableview Delegate and Data Source
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
          return 1
        }
        else
        {
          return icons.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
        let cell = tableview.dequeueReusableCell(withIdentifier: "profileCell") as! profileCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        }
        else
        {
        let cell = tableview.dequeueReusableCell(withIdentifier: "SidemenuCell") as! SidemenuCell
        cell.lbl.text = menuNames[indexPath.row]
        cell.imgview.image = UIImage(named: icons[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        sideMenuController?.hideLeftViewAnimated(sender: Any.self)
            switch indexPath.row {
            case 0:
                let viewController = KMainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
              
                let navigationController = sideMenuController!.rootViewController as! UINavigationController
                navigationController.pushViewController(viewController, animated: true)
                
            case 1:
                defaultValues.set(nil, forKey: "UserID")
                defaultValues.synchronize()
                APPDELEGATE.configureSideMenu()
            default:
                break
                }
     }

}



