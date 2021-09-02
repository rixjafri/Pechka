//
//  MyTabbarViewController.swift
//  Lima
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MyTabbarViewController: UITabBarController,UITabBarControllerDelegate {
    
    //MARK:- Tabbar Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        tabBar.tintColor = UIColor.init(red: 254/255, green: 87/255, blue: 34/225, alpha: 1)
      
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateControllers), name: NSNotification.Name(rawValue: "UpdateControllers"), object: nil)
      
        
       

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
        if userId != ""
        {
          
            let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
            userProfileVC.tabBarItem = icon1
            self.viewControllers?[2] = userProfileVC
         
        }
        else
        {
           
            let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
            let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
            userProfileVC.tabBarItem = icon1
            self.viewControllers?[2] = userProfileVC
        }
    }
    @objc func UpdateControllers(_ notification: Notification)
    {
        if (notification.name.rawValue == "UpdateControllers")
        {
          
             let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
             if userId != ""
             {
                
                 let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                 let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
                 userProfileVC.tabBarItem = icon1
                 self.viewControllers?[2] = userProfileVC
              
             }
             else
             {
                 let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                 let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
                 let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
                 userProfileVC.tabBarItem = icon1
                 self.viewControllers?[2] = userProfileVC
             }
            
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
 
        let tabBarIndex = tabBarController.selectedIndex

                if tabBarIndex == 4
                {
                    let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "MyTabbarViewController") as! MyTabbarViewController
                    let nav = UINavigationController(rootViewController: vc)
                    nav.setNavigationBarHidden(true, animated: true)
                    APPDELEGATE.window?.rootViewController = nav
                    vc.selectedIndex = 4
                }
               else if tabBarIndex == 2
               {
                let userId = "\(defaultValues.value(forKey: "UserID") ?? "")"
                if userId != ""
                {
                
                    let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
                    userProfileVC.tabBarItem = icon1
                    self.viewControllers?[2] = userProfileVC
                 
                }
                else
                {
                  
                    let userProfileVC = KMainStoryBoard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
                    let icon1 = UITabBarItem(title: NSLocalizedString("User", comment: ""), image: UIImage(named: "user"), tag: 2)
                    userProfileVC.tabBarItem = icon1
                    self.viewControllers?[2] = userProfileVC
                }
               }

    }
    
}


