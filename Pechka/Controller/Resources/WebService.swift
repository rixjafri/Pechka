//
//  WebService.swift
//  BellyMelly_App
//
//  Created by iOS on 30/08/19.
//  Copyright © 2019 POSSIBILITY SOLUTIONS. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import SystemConfiguration
import NVActivityIndicatorView
class WebService: NSObject {
    
    static let shared:WebService = {
        
        let sharedInsatnce = WebService()
        return sharedInsatnce
    }()
    
    //MARK:- Acticity Indicator
    var objNVHud = ActivityData(size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE, message: nil, messageFont: nil, type: NVActivityIndicatorType.ballRotateChase, color:BaseViewController.appColor, padding: nil, displayTimeThreshold: NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD, minimumDisplayTime: NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME);
    
    func objHudShow(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(objNVHud,nil)
    }
    func objHudHide(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
   
    //********************** Api Get Method ******************
    //MARK: - GET
    func apiGet(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        print(url)
        print(parameters)
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
        }
        
//        SVProgressHUD.show()
//
//        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
//        SVProgressHUD.setBackgroundColor(.clear)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120

        manager.request(url, method:.get, parameters: parameters, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.dismiss()
        
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                    
                    completion(nil,response.error)
                }
            }
            else
            {
                print("")
                completion(nil,response.error)
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    func apiGetPrems(url:String ,id: String , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
            
        }
        SVProgressHUD.show()
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
        SVProgressHUD.setBackgroundColor(.clear)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let Mainurl = url + "/" + id
        print(Mainurl)

        manager.request(Mainurl, method:.get, parameters: nil, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.dismiss()
            
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                    
                }else{
                    Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                    
                    completion(nil,response.error)
                }
            }
            else
            {
                print("")
                completion(nil,response.error)
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    //********************** Api Post Method ******************
    //MARK: - POST
    func apiPostClient(url:String,parameters:[String:Any] , completion: @escaping (_ data:[String:Any]? , _ error:Error?) -> Void)
    {
        print(url)
        print(parameters)
        if !CheckInternet.Connection()
        {
            Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
        }
//        SVProgressHUD.show()
//        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
//        SVProgressHUD.setBackgroundColor(.clear)
        //objHudShow()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
//            SVProgressHUD.setDefaultMaskType(.clear)
//            SVProgressHUD.dismiss()
          //  self.objHudHide()
            if response.result.isSuccess
            {
                print("Response Data: \(response)")
                
                if let data = response.result.value as? [String:Any]
                {
                    completion(data , nil)
                    
                }else{
                    print("")
                    
                    completion(nil,response.error)
                }
            }
            else
            {
                print("")
                completion(nil,response.error)
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
    //MARK: - Api Get Method
       func apiGetMethod(url:String,parameters:[String:Any] , completion: @escaping (_ data:Data? , _ error:Error?) -> Void)
       {
           print(url)
           print(parameters)
         if !CheckInternet.Connection()
                 {
                     Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
                 }
//                 SVProgressHUD.show()
//                 SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
//                 SVProgressHUD.setBackgroundColor(.clear)
         // objHudShow()
          UIApplication.shared.isNetworkActivityIndicatorVisible = true
           
           let manager = Alamofire.SessionManager.default
           manager.session.configuration.timeoutIntervalForRequest = 120
           
           manager.request(url, method:.get, parameters: parameters, encoding: URLEncoding.default, headers: headersintoApi()).responseJSON { (response:DataResponse<Any>) in
               UIApplication.shared.isNetworkActivityIndicatorVisible = false
//               SVProgressHUD.setDefaultMaskType(.clear)
//               SVProgressHUD.dismiss()
           // self.objHudHide()
               if response.result.isSuccess
               {
                   print("Response Data: \(response)")
                   
                   if let data = response.result.value as? [String:Any]
                   {
                       let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
                       completion(jsonData , nil)
                       
                   }
                   else{
                    print("")
                       
                       completion(nil,response.error)
                   }
               }
               else
               {
                  // Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                   completion(nil,response.error)
                   print("Error \(String(describing: response.result.error))")
               }
               
           }
       }
    //MARK: - Api POST Method
       func apiDataPostMethod(url:String,parameters:[String:Any] , completion: @escaping (_ data:Data? , _ error:Error?) -> Void)
       {
           print(url)
           print(parameters)
           if !CheckInternet.Connection()
           {
               Helper.Alertmessage(title: "Alert!", message: "Please Check Internet Connection", vc: nil)
           }
//           SVProgressHUD.show()
//           SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
//           SVProgressHUD.setBackgroundColor(.clear)
                  
          // UIApplication.shared.isNetworkActivityIndicatorVisible = true
         //  objHudShow()
           let manager = Alamofire.SessionManager.default
           manager.session.configuration.timeoutIntervalForRequest = 45
           
        manager.request(url, method:.post, parameters: parameters, encoding: URLEncoding.default, headers: .none).responseJSON { (response:DataResponse<Any>) in
               
               UIApplication.shared.isNetworkActivityIndicatorVisible = false
//               SVProgressHUD.setDefaultMaskType(.clear)
//               SVProgressHUD.dismiss()
          //  self.objHudHide()
               if response.result.isSuccess
               {
                   print("Response Data: \(response)")
                   
                   if let data = response.result.value as? [String:Any]
                   {
                        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
                       completion(jsonData , nil)
                       
                   }else{
                    print("")
                       
                       completion(nil,response.error)
                   }
               }
               else
               {
                   //Helper.Alertmessage(title: "Info:", message: (response.error?.localizedDescription)!, vc: nil)
                   completion(nil,response.error)
                   print("Error \(String(describing: response.result.error))")
               }
               
           }
       }
       
    func headersintoApi() -> [String:String]
    {
        let string = defaultValues.string(forKey: "Token") ?? ""

        print(string)
        
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Accept":"application/json"]
        return headers
    }
    
    func showlogoutAlert()
    {
        let alert = UIAlertController(title: "", message: "Your Session is expired", preferredStyle: UIAlertController.Style.alert);
        let action = UIAlertAction.init(title: "ok", style: .default) { (sction) in
            //  Helper.shared.appDelegate.loggout()
        }
        alert.addAction(action)
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}

