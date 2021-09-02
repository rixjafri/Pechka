//
//  ChatModel.swift
//  Pechka
//
//  Created by USER on 17/05/21.
//

import Foundation
import ObjectMapper
class  ChatModel: Mappable {
    
       var status : String?
       var message : String?
       var addedDate : String?
       var addedDateStr : String?
       var catId : String?
       var catName : String?
       var catOrdering : String?
       var id : String?
       var itemId : String?
       var buyerUserId : String?
       var sellerUserId : String?
       var negoPrice : String?
       var buyerUnreadCount : String?
       var selleUnreadCount : String?
       var isAccept : String?
       var isOffer : String?
       var offerAmount : String?
       var item : AddItemModel?
       var seller : AddUserModel?
       var buyer : AddUserModel?
//       var defaultIcon : CategoryDefaultIcon?
//       var defaultPhoto : CategoryDefaultPhoto?
    
   

    
    
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
        id <- map["id"]
        itemId <- map["item_id"]
        buyerUserId <- map["buyer_user_id"]
        sellerUserId <- map["seller_user_id"]
        negoPrice <- map["nego_price"]
        buyerUnreadCount <- map["buyer_unread_count"]
        selleUnreadCount <- map["seller_unread_count"]
        isAccept <- map["is_accept"]
        isOffer <- map["is_offer"]
        offerAmount <- map["offer_amount"]
        item <- map["item"]
        seller <- map["seller"]
        buyer <- map["buyer"]
//        defaultIcon <- map["default_icon"]
//        defaultPhoto <- map["default_photo"]

    }
}

//class  CategoryDefaultIcon: Mappable {
//
//        var addedDate : String?
//        var addedUserId : String?
//        var imgDesc : String?
//        var imgHeight : String?
//        var imgId : String?
//        var imgParentId : String?
//        var imgPath : String?
//        var imgType : String?
//        var imgWidth : String?
//        var updatedDate : String?
//        var updatedUserId : String?
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//
//        addedDate <- map["added_date"]
//        addedUserId <- map["added_user_id"]
//        imgDesc <- map["img_desc"]
//        imgHeight <- map["img_height"]
//        imgId <- map["img_id"]
//        imgParentId <- map["img_parent_id"]
//        imgPath <- map["img_path"]
//        imgType <- map["img_type"]
//        imgWidth <- map["img_width"]
//        updatedDate <- map["updated_date"]
//        updatedUserId <- map["updated_user_id"]
//
//    }
//}

//class  CategoryDefaultPhoto: Mappable {
//
//       var addedDate : String!
//       var addedUserId : String!
//       var imgDesc : String!
//       var imgHeight : String!
//       var imgId : String!
//       var imgParentId : String!
//       var imgPath : String!
//       var imgType : String!
//       var imgWidth : String!
//       var updatedDate : String!
//       var updatedUserId : String?
//
//    required init?(map: Map) {
//
//    }
//
//    func mapping(map: Map) {
//
//
//        addedDate <- map["added_date"]
//        addedUserId <- map["added_user_id"]
//        imgDesc <- map["img_desc"]
//        imgHeight <- map["img_height"]
//        imgId <- map["img_id"]
//        imgParentId <- map["img_parent_id"]
//        imgPath <- map["img_path"]
//        imgType <- map["img_type"]
//        imgWidth <- map["img_width"]
//        updatedDate <- map["updated_date"]
//        updatedUserId <- map["updated_user_id"]
//
//    }
//}
