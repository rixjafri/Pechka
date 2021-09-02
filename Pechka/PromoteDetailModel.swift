//
//  PromoteDetailModel.swift
//  Pechka
//
//  Created by Neha Saini on 03/06/21.
//

import Foundation
import ObjectMapper

class  PromoteDetailModel: Mappable {
    
       var message : String?
       var offlinePayment : [PromoteDetailOfflinePayment]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
        message <- map["message"]
        offlinePayment  <- map["offline_payment"]
        
    }
}
class PromoteDetailOfflinePayment: Mappable {
    
        var addedDate : String?
        var addedUserId : String?
        var defaultIcon : CategoryDefaultIcon?
        var descriptionField : String?
        var id : String?
        var status : String?
        var title : String?
        var updatedDate : String?
        var updatedUserId : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        addedUserId <- map["added_user_id"]
        defaultIcon <- map["default_icon"]
        descriptionField <- map["description"]
        id <- map["id"]
        status <- map["status"]
        title <- map["title"]
        updatedDate <- map["updated_date"]
        updatedUserId <- map["updated_user_id"]
       

    }
}



