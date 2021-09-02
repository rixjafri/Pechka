//
//  CategoryModel.swift
//  Pechka
//
//  Created by Neha Saini on 14/05/21.
//

import Foundation
import ObjectMapper

class  CategoryModel: Mappable {
    
       var status : String?
       var message : String?
       var addedDate : String?
       var addedDateStr : String?
       var catId : String?
       var catName : String?
       var catOrdering : String?
       var defaultIcon : CategoryDefaultIcon?
       var defaultPhoto : CategoryDefaultPhoto?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
        status <- map["status"]
        message <- map["message"]
        addedDate <- map["added_date"]
        addedDateStr <- map["added_date_str"]
        catId <- map["cat_id"]
        catName <- map["cat_name"]
        catOrdering <- map["cat_ordering"]
        defaultIcon <- map["default_icon"]
        defaultPhoto <- map["default_photo"]

    }
}
class  CategoryDefaultIcon: Mappable {
    
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

class  CategoryDefaultPhoto: Mappable {
    
       var addedDate : String!
       var addedUserId : String!
       var imgDesc : String!
       var imgHeight : String!
       var imgId : String!
       var imgParentId : String!
       var imgPath : String!
       var imgType : String!
       var imgWidth : String!
       var updatedDate : String!
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
