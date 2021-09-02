//
//  LocationServices.swift
//  Club Scene
//
//  Created by C100-107 on 06/05/19.
//  Copyright © 2019 C100-107. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class LocationServices {
    
    
    //MARK:- Get Location Data
    static func getLocationData(latitude : CLLocationDegrees, longitude : CLLocationDegrees){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Complete address as PostalAddress
           //  print(placeMark.postalAddress as Any)  //  Import Contacts
            
            // Location name
            if placeMark != nil
            {
                if let locationName = placeMark.name  {
                print(locationName)
                }

                // Street address
                if let street = placeMark.thoroughfare {
                    print(street)
                }
                if let town = placeMark.locality {
//                    print(town)
//                    CITY = town
//                    UserDefaults.standard.set(CITY, forKey: "City")
                }
                if let state = placeMark.administrativeArea {
//                    print(state)
//                    STATE = state
//                    UserDefaults.standard.set(STATE, forKey: "State")

                }
                if let country = placeMark.country {
//                    print(country)
//                    COUNTRY = country
//                    UserDefaults.standard.set(COUNTRY, forKey: "Country")
                }
            }
        })
        
    }
    
    //MARK:- Get Address from Lat Long
    static func getAddressFromLatLong(latitude : CLLocationDegrees, longitude : CLLocationDegrees){

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            UserDefaults.standard.set("\(latitude)", forKey: "USER_LATITUDE")
            UserDefaults.standard.set("\(longitude)", forKey: "USER_LONGITUDE")
            UserDefaults.standard.synchronize()
           
            // Complete address as PostalAddress
           //  print(placeMark.postalAddress as Any)  //  Import Contacts
            
            // Location name
            if placeMark != nil
            
         
            {
                var NAME = ""
                var CURRENTSTREET = ""
                
                var CURRENTCITY = ""
                var getAddress = ""
                var CURRENTSTATE = ""
                var CURRENTCOUNTRY = ""
                if let locationName = placeMark.name  {
                    NAME = locationName + ", "
                }
            
//                 Street address
                if let street = placeMark.thoroughfare {
                    CURRENTSTREET = street + ", "
                    UserDefaults.standard.set("\(street)", forKey: "Street")
                }
                if let town = placeMark.locality {
                    print(town)
                   CURRENTCITY = town + ", "
                    UserDefaults.standard.set(CURRENTCITY, forKey: "CurrentCity")
                     UserDefaults.standard.synchronize()
                }
                if let state = placeMark.administrativeArea {
                    print(state)
                  CURRENTSTATE = state + ", "
                    UserDefaults.standard.set(CURRENTSTATE, forKey: "CurrentState")
                     UserDefaults.standard.synchronize()

                }
                if let country = placeMark.country {
                    print(country)
                    CURRENTCOUNTRY = country
                    UserDefaults.standard.set(CURRENTCOUNTRY, forKey: "CurrentCountry")
                     UserDefaults.standard.synchronize()
                }

                getAddress = NAME  + CURRENTSTREET  + CURRENTCITY  +  CURRENTSTATE  +  CURRENTCOUNTRY
                UserDefaults.standard.set(getAddress, forKey: "ADDRESS")
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateLatLong"), object: nil, userInfo: nil)
            }
           
            
        })
        
    }
   
}
