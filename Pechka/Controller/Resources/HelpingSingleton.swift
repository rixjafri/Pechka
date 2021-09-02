//
//  HelpingSingleton.swift
//  MedConnex
//
//  Created by PBS9 on 16/07/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import Foundation

import UIKit

struct Helper
{
    static var shared = Helper()
    //App delegate
    
    // Mark: - Alert Message
    // =====================================
    static func Alertmessage(title:String, message:String , vc:UIViewController?)
    {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        
        if vc != nil
        {
            vc!.present(alert, animated: true, completion: nil)
        }
        else
        {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate
            {
                appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    struct Alert {
        static func errorAlert(title: String, message: String?, cancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default) {
                _ in
                guard let completion = completion else { return }
                completion()
            }
            alert.addAction(actionOK)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            cancel.setValue(#colorLiteral(red: 0.08235294118, green: 0.6509803922, blue: 0.3411764706, alpha: 1), forKey: "titleTextColor")
            if cancelButton { alert.addAction(cancel) }
            
            return alert
        }
        
    }
    // =========== UIview only top edges cornerradius ================
    
    static func TopedgeviewCorner(viewoutlet:UIView, radius: CGFloat)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = radius
        viewoutlet.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    static func BottemedgeviewCorner(viewoutlet:UIView, radius: CGFloat)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = radius
        viewoutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    static func viewCornerRadius(viewoutlet:UIView)
    {
        viewoutlet.clipsToBounds = true
        viewoutlet.layer.cornerRadius = 15
        viewoutlet.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // ============  UITextView CornerRadius =======================
    
    static func TextviewcornerRadius(textviewoutlet:UITextView)
    {
        textviewoutlet.layer.borderWidth = 1
        textviewoutlet.layer.borderColor = UIColor.init(red: 175/255, green: 178/255, blue: 197/225, alpha: 0.2).cgColor
        textviewoutlet.layer.cornerRadius = 15
    }
    
    // Mark: - Valid Email or Not
    /*************************************************************/
    
    func isValidEmail(candidate: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
        if valid {
            valid = !candidate.contains("..")
        }
        return !valid
    }
    
    // Mark: - Field empty or not
    /*************************************************************/
    
    func isFieldEmpty(field: String) -> Bool {
        return field.count == 0
    }
}
struct PollTime {
    let time: Int
    let description: String
}

struct pollModel {
    let days: [PollTime]
    let hours: [PollTime]
    let minutes: [PollTime]
    
    var currentTime: (day: PollTime, hour: PollTime, minute: PollTime)?
    
    init() {
        days = [Int](0...7).map { PollTime(time: $0, description: $0 == 0 || $0 > 1 ? "days" : "day") }
        hours = [Int](0...23).map { PollTime(time: $0, description: $0 == 0 || $0 > 1 ? "hours" : "hour") }
        minutes = [Int](0...59).map { PollTime(time: $0, description: $0 == 0 || $0 > 1 ? "min" : "min") }
    }
    
    private func timeBiggerThan10Minutes() -> Bool {
        guard let currentTime = currentTime else {
            return false
        }
        return currentTime.minute.time > 9 || currentTime.hour.time > 0 || currentTime.day.time > 0
    }
    
    private func timeLessThan7Days() -> Bool {
        guard let currentTime = currentTime else {
            return false
        }
        if currentTime.day.time == 7 {
            return currentTime.hour.time == 0 && currentTime.minute.time == 0
        }
        return currentTime.day.time < 8
    }
    
    func validateCurrenTime() -> Bool {
        return timeBiggerThan10Minutes() && timeLessThan7Days()
    }
}
