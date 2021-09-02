//
//  ForgotModel.swift
//  Pechka
//
//  Created by Neha Saini on 13/05/21.
//

import Foundation
import ObjectMapper

class  ForgotModel: Mappable {
    
      var status : String?
       var message : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
       
        status <- map["status"]
        message <- map["message"]

    }
}
