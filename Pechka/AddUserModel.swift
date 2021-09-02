//
//  AddUserModel.swift
//  Pechka
//
//  Created by Neha Saini on 13/05/21.
//

import Foundation
import ObjectMapper

class AddUserModel: Mappable {
    
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
        followerCount <- map["following_count"]
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
class AddUserRatingDetail: Mappable {
    
       var fiveStarCount : String?
       var fiveStarPercent : String?
       var fourStarCount : String?
       var fourStarPercent : String?
       var oneStarCount : String?
       var oneStarPercent : String?
       var threeStarCount : String?
       var threeStarPercent : String?
       var totalRatingCount : String?
       var totalRatingValue : String?
       var twoStarCount : String?
       var twoStarPercent : String?
      
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        fiveStarCount <- map["five_star_count"]
        fiveStarPercent <- map["five_star_percent"]
        fourStarCount <- map["four_star_count"]
        fourStarPercent <- map["four_star_percent"]
        oneStarCount <- map["one_star_count"]
        oneStarPercent <- map["one_star_percent"]
        threeStarCount <- map["three_star_count"]
        threeStarPercent <- map["three_star_percent"]
        totalRatingCount <- map["total_rating_count"]
        totalRatingValue <- map["total_rating_value"]
        twoStarCount <- map["two_star_count"]
        twoStarPercent <- map["two_star_percent"]
       

    }
    
    
   

}
