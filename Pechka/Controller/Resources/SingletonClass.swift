//
//  SingletonClass.swift
//  AlgoDelivery
//
//  Created by Apple on 12/09/18.
//  Copyright © 2018 possibilitySolution. All rights reserved.
//

import UIKit

class Singleton {
    
    var NSDataImage = NSData()
    var latitude : String = ""
    var longitude : String = ""
    var MainAddress : String = ""
    var Name : String = ""
    var Email : String = ""
    var Password : String = ""
    var CheckBox : String = ""
    var Phone : String = ""
    var Address : String = ""
    var Postalcode : String = ""
    var TechId : String = ""
    var OrderId : String = ""
    var vehicleCount : String = ""
    var vehicleName : String = ""
    var vehicleNumber : String = ""
    var vehicleColor : String = ""
    var vehicleModel : String = ""
    var vehicleOdometer : String = ""
    var inspectionCharges : String = ""
   


    class var sharedInstance : Singleton {
        struct Static {
            static let instance : Singleton = Singleton()
        }
        return Static.instance
    }
    var imageData : NSData {
        get{
            return self.NSDataImage
        }
        set {
            self.NSDataImage = newValue
        }
    }
    var lat : String {
        get{
            return self.latitude
        }
        set {
            self.latitude = newValue
        }
    }
    var long : String {
        
        get{
            return self.longitude
        }
        set {
            self.longitude = newValue
        }
    }
    var mainAddress : String {
        
        get{
            return self.MainAddress
        }
        set {
            self.longitude = newValue
        }
    }
    var name : String {
        
        get{
            return self.Name
        }
        set {
            self.Name = newValue
        }
    }
    var email : String {
        get{
            return self.Email
        }
        set {
            self.Email = newValue
        }
    }
    var password : String {
        get{
            return self.Password
        }
        set {
            self.Password = newValue
        }
    }
    var check : String {
        
        get{
            return self.CheckBox
        }
        set {
            self.CheckBox = newValue
        }
    }
    var phone : String {
        get{
            return self.Phone
        }
        set {
            self.Phone = newValue
        }
    }

    var address : String {
        get{
            return self.Address
        }
        set {
            self.Address = newValue
        }
    }
    var postalcode : String {
        get{
            return self.Postalcode
        }
        set {
            self.Postalcode = newValue
        }
    }
    var techId : String {
        get{
            return self.TechId
        }
        set {
            self.Postalcode = newValue
        }
    }
    var orderId : String {
        get{
            return self.OrderId
        }
        set {
            self.Postalcode = newValue
        }
    }
    var vehiclecount : String {
        get{
            return self.vehicleCount
        }
        set {
            self.Postalcode = newValue
        }
    }
    
    var vehiclename : String {
        get{
            return self.vehicleName
        }
        set {
            self.Postalcode = newValue
        }
    }
    var vehiclenumber : String {
        get{
            return self.vehicleNumber
        }
        set {
            self.Postalcode = newValue
        }
    }
    
    var vehiclecolor : String {
        get{
            return self.vehicleColor
        }
        set {
            self.Postalcode = newValue
        }
    }
    var vehiclemodel : String {
        get{
            return self.vehicleModel
        }
        set {
            self.Postalcode = newValue
        }
    }
    
    var vehicleodometer : String {
        get{
            return self.vehicleOdometer
        }
        set {
            self.Postalcode = newValue
        }
    }
    var inspectioncharges : String {
        get{
            return self.inspectionCharges
        }
        set {
            self.Postalcode = newValue
        }
    }

}
class SharedClass: NSObject {
    
    static let sharedInstance = SharedClass()
    
    //This is my padding function.
    func textFieldLeftPadding(textFieldName: UITextField) {
        // Create a padding view
        textFieldName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textFieldName.frame.height))
        textFieldName.leftViewMode = .always//For left side padding
        textFieldName.rightViewMode = .always//For right side padding
    }
    private override init() {
        
    }
}
