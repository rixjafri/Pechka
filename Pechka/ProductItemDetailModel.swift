//
//  ProductItemDetailModel.swift
//  Pechka
//
//  Created by Neha Saini on 19/05/21.
//

import Foundation
import ObjectMapper

class ProductItemDetailModel: Mappable {
    
    
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
