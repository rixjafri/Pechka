//
//  AddItemModel.swift
//  Pechka
//
//  Created by Neha Saini on 19/05/21.
//

import Foundation
import ObjectMapper

class  AddItemModel: Mappable {
    
    
       var addedDate : String?
       var addedDateStr : String?
       var addedUserId : String?
       var address : String?
       var brand : String?
       var businessMode : String?
       var catId : String?
       var category : AddItemCategory?
       var conditionOfItem : AddItemConditionOfItem?
       var conditionOfItemId : String?
       var dealOption : AddItemDealOption?
       var dealOptionId : String?
       var dealOptionRemark : String?
       var defaultPhoto : AddItemDefaultPhoto?
       var descriptionField : String?
       var favouriteCount : String?
       var highlightInfo : String?
       var id : String?
       var isFavourited : String?
       var isOwner : String?
       var isPaid : String?
       var isSoldOut : String?
       var itemCurrency : AddItemItemCurrency?
       var itemCurrencyId : String?
       var itemLocation : AddItemItemLocation?
       var itemLocationId : String?
       var itemPriceType : AddItemItemPriceType?
       var itemPriceTypeId : String?
       var itemType : AddItemItemType?
       var itemTypeId : String?
       var lat : String?
       var lng : String?
       var paidStatus : String?
       var photoCount : String?
       var price : String?
       var status : String?
       var subCatId : String?
       var subCategory : AddItemSubCategory?
       var title : String?
       var touchCount : String?
       var updatedDate : String?
       var updatedFlag : String?
       var updatedUserId : String?
       var user : AddItemUser?
       var message : String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
      
        addedDate <- map["added_date"]
        addedDateStr <- map["added_date_str"]
        addedUserId <- map["added_user_id"]
        address <- map["address"]
        brand <- map["brand"]
        businessMode <- map["business_mode"]
        catId <- map["cat_id"]
        category <- map["category"]
        conditionOfItem <- map["condition_of_item"]
        conditionOfItemId <- map["condition_of_item_id"]
        dealOption <- map["deal_option"]
        dealOptionId <- map["deal_option_id"]
        dealOptionRemark <- map["deal_option_remark"]
        defaultPhoto <- map["default_photo"]
        descriptionField <- map["description"]
        favouriteCount <- map["favourite_count"]
        highlightInfo <- map["highlight_info"]
        id <- map["id"]
        isFavourited <- map["is_favourited"]
        isOwner <- map["is_owner"]
        isPaid <- map["is_paid"]
        isSoldOut <- map["is_sold_out"]
        itemCurrency <- map["item_currency"]
        itemCurrencyId <- map["item_currency_id"]
        itemLocation <- map["item_location"]
        itemLocationId <- map["item_location_id"]
        itemPriceType <- map["item_price_type"]
        itemPriceTypeId <- map["item_price_type_id"]
        itemType <- map["item_type"]
        itemTypeId <- map["item_type_id"]
        lat <- map["lat"]
        lng <- map["lng"]
        paidStatus <- map["paid_status"]
        photoCount <- map["photo_count"]
        price <- map["price"]
        status <- map["status"]
        subCatId <- map["sub_cat_id"]
        subCategory <- map["sub_category"]
        title <- map["title"]
        touchCount <- map["touch_count"]
        updatedDate <- map["updated_date"]
        updatedFlag <- map["updated_flag"]
        updatedUserId <- map["updated_user_id"]
        user <- map["user"]
        message <- map["message"]
    }
}
class  AddItemCategory: Mappable {
    
      var addedDate : String?
      var catId : String?
      var catName : String?
      var catOrdering : String?
      var defaultIcon : ProductItemDetailDefaultIcon?
      var defaultPhoto : ProductItemDetailDefaultPhoto?
      var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        catId <- map["cat_id"]
        catName <- map["cat_name"]
        catOrdering <- map["cat_ordering"]
        defaultIcon <- map["default_icon"]
        defaultPhoto <- map["default_photo"]
        status <- map["status"]
       

    }
}
class  AddItemConditionOfItem: Mappable {
    
    var addedDate : String?
    var id : String?
    var name : String?
    var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]

    }
}
class  AddItemDealOption: Mappable {
    
    var addedDate : String?
    var id : String?
    var name : String?
    var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
    }
}

class  AddItemDefaultPhoto: Mappable {
    
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
class  AddItemItemCurrency: Mappable {
    
      var addedDate : String?
      var currencyShortForm : String?
      var currencySymbol : String?
      var id : String?
      var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        currencyShortForm <- map["currency_short_form"]
        currencySymbol <- map["currency_symbol"]
        id <- map["id"]
        status <- map["status"]
      

    }
}
class  AddItemItemLocation: Mappable {
    
    var addedDate : String?
    var id : String?
    var name : String?
    var status : String?
    var lat : String?
    var lng : String?
    var ordering : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        lat <- map["lat"]
        lng <- map["lng"]
        ordering <- map["ordering"]
        

    }
}
class  AddItemItemPriceType: Mappable {
    
    var addedDate : String?
    var id : String?
    var name : String?
    var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]

    }
}
class  AddItemItemType: Mappable {
    
       var addedDate : String?
       var id : String?
       var name : String?
       var status : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
       

    }
}
class   ProductItemDetailDefaultPhoto: Mappable {
    
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
class  AddItemSubCategory: Mappable {
    
        var addedDate : String?
        var addedUserId : String?
        var catId : String!
        var defaultPhoto : ProductItemDetailDefaultPhoto?
        var id : String?
        var name : String?
        var status : String?
        var updatedDate : String?
        var updatedFlag : String?
        var updatedUserId : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        addedUserId <- map["added_user_id"]
        catId <- map["cat_id"]
        defaultPhoto <- map["default_photo"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        updatedFlag <- map["updated_flag"]
        updatedDate <- map["updated_date"]
        updatedUserId <- map["updated_user_id"]

    }
}
class  AddItemUser: Mappable {
    
    var addedDate : String?
    var addedDateStr : String?
    var appleId : String?
    var appleVerify : String?
    var city : String?
    var code : String?
    var deviceToken : String?
    var emailVerify : String?
    var facebookId : String?
    var facebookVerify : String?
    var followerCount : String?
    var followingCount : String?
    var googleId : String?
    var googleVerify : String?
    var isBanned : String?
    var isFollowed : String?
    var messenger : String?
    var overallRating : String?
    var phoneId : String?
    var phoneVerify : String?
    var ratingCount : String?
    var ratingDetails : AddUserRatingDetail?
    var roleId : String?
    var status : String?
    var userAboutMe : String?
    var userAddress : String?
    var userCoverPhoto : String?
    var userEmail : String?
    var userId : String?
    var userIsSysAdmin : String?
    var userName : String?
    var userPhone : String?
    var userProfilePhoto : String?
    var whatsapp : String?
    var message : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        addedDate <- map["added_date"]
        addedDateStr <- map["added_date_str"]
        appleId <- map["apple_id"]
        appleVerify <- map["apple_verify"]
        city <- map["city"]
        code <- map["code"]
        deviceToken <- map["device_token"]
        emailVerify <- map["email_verify"]
        facebookId <- map["facebook_id"]
        facebookVerify <- map["facebook_verify"]
        followerCount <- map["follower_count"]
        followingCount <- map["following_count"]
        googleId <- map["google_id"]
        googleVerify <- map["google_verify"]
        isBanned <- map["is_banned"]
        isFollowed <- map["is_followed"]
        messenger <- map["messenger"]
        overallRating <- map["overall_rating"]
        phoneId <- map["phone_id"]
        phoneVerify <- map["phone_verify"]
        ratingCount <- map["rating_count"]
        ratingDetails <- map["rating_details"]
        roleId <- map["role_id"]
        status <- map["status"]
        userAboutMe <- map["user_about_me"]
        userAddress <- map["user_address"]
        userCoverPhoto <- map["user_cover_photo"]
        userEmail <- map["user_email"]
        userId <- map["user_id"]
        userIsSysAdmin <- map["user_is_sys_admin"]
        userName <- map["user_name"]
        userPhone <- map["user_phone"]
        userProfilePhoto <- map["user_profile_photo"]
        whatsapp <- map["whatsapp"]
        message <- map["message"]


    }
}
class ProductItemDetailDefaultIcon: Mappable {
    
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
