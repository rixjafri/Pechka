//
//  Constants.swift
//  MedConnex
//
//  Created by PBS9 on 16/07/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import Foundation

let defaultValues = UserDefaults.standard
var message = defaultValues.value(forKey: "message") as? String ?? ""
var token = defaultValues.value(forKey: "token") as? String ?? ""
var deviceId = defaultValues.value(forKey: "DeviceId") as? String ?? ""
var userId = defaultValues.value(forKey: "userId") as? String ?? ""
var firstName = defaultValues.value(forKey: "firstName") as? String ?? ""
var lastName = defaultValues.value(forKey: "lastName") as? String ?? ""
var email = defaultValues.value(forKey: "email") as? String ?? ""
var phone = defaultValues.value(forKey: "phone") as? String ?? ""
var status = defaultValues.value(forKey: "status") as? String ?? ""
var about = defaultValues.value(forKey: "about") as? String ?? ""
var useraddress = defaultValues.value(forKey: "address") as? String ?? ""
var age = defaultValues.value(forKey: "age") as? String ?? ""
var profileimage = defaultValues.value(forKey: "profileimage") as? String ?? ""
var usertype = defaultValues.value(forKey: "usertype") as? String ?? ""
var latitude = defaultValues.value(forKey: "latitude") as? String ?? ""
var longitude = defaultValues.value(forKey: "longitude") as? String ?? ""
var address = defaultValues.value(forKey: "address") as? String ?? ""
var mainType = defaultValues.value(forKey: "mainType") as? String ?? ""

 
var Postlatitude = 0.0
var Postlongitude = 0.0
var PostAddress = String()

