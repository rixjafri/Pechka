//
//  PromoteModel.swift
//  Pechka
//
//  Created by Neha Saini on 02/06/21.
//

import Foundation
import ObjectMapper

class  PromoteModel: Mappable {
    
        var appSetting : PromoteAppSetting?
        var currencyShortForm : String?
        var currencySymbol : String?
        var deleteHistory : [AnyObject]?
        var offlineEnabled : String?
        var offlineMessage : String?
        var oneday : String?
        var paypalEnabled : String?
        var razorEnabled : String?
        var razorKey : String?
        var stripeEnabled : String?
        var stripePublishableKey : String?
        var userInfo : PromoteUserInfo?
        var version : PromoteVersion?
        var message : String?
        var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
        appSetting <- map["app_setting"]
        currencyShortForm  <- map["currency_short_form"]
        currencySymbol  <- map["currency_symbol"]
        deleteHistory  <- map["delete_history"]
        offlineEnabled  <- map["offline_enabled"]
        offlineMessage  <- map["offline_message"]
        oneday  <- map["oneday"]
        paypalEnabled  <- map["paypal_enabled"]
        razorEnabled  <- map["razor_enabled"]
        razorKey  <- map["razor_key"]
        stripeEnabled  <- map["stripe_enabled"]
        stripePublishableKey  <- map["stripe_publishable_key"]
        userInfo  <- map["user_info"]
        version  <- map["version"]
        message <- map["message"]
        status <- map["status"]
    }
}
class PromoteAppSetting: Mappable {
    
        var addedDate : String?
        var addedUserId : String?
        var imgDesc : String?
        var imgHeight : String?
        var imgId : String?
        var imgParentId : String?
        var imgPath : String?
        var imgType : String?
        var imgWidth : String?
        var updatedDate : String?
        var updatedUserId : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        addedUserId <- map["added_user_id"]
        imgDesc <- map["img_desc"]
        imgHeight <- map["img_height"]
        imgId <- map["img_id"]
        imgParentId <- map["img_parent_id"]
        imgPath <- map["img_path"]
        imgType <- map["img_type"]
        imgWidth <- map["img_width"]
        updatedDate <- map["updated_date"]
        updatedUserId <- map["updated_user_id"]

    }
}

class PromoteVersion: Mappable {
    
        var versionForceUpdate : String?
        var versionMessage : String?
        var versionNeedClearData : String?
        var versionNo : String?
        var versionTitle : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
        versionForceUpdate <- map["version_force_update"]
        versionMessage <- map["version_message"]
        versionNeedClearData <- map["version_need_clear_data"]
        versionNo  <- map["version_no"]
        versionTitle <- map["version_title"]
        

    }
}
class PromoteUserInfo: Mappable {
    
    var userStatus : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        userStatus <- map["user_status"]
        

    }
}

