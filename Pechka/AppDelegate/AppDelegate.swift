//
//  AppDelegate.swift
//  Pechka
//
//  Created by Neha Saini on 05/05/21.
//

import UIKit
import LGSideMenuController
import GoogleSignIn
import FacebookCore
import FacebookLogin
import FacebookShare
import IQKeyboardManagerSwift
import CoreLocation
import GoogleMaps
import GooglePlaces
import CoreLocation
import MapKit
import Firebase
import FirebaseMessaging
import UserNotifications
import CoreData
import FirebaseCore
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    var gcmMessageIDKey = "gcm.message_id"
internal let kMapsAPIKey = "AIzaSyBq16ekrXE3LHeDIwu3KDk0O9s-rMjZpqc"
 var sideMenuViewController = UserSideMenuVC()
 var window: UIWindow?
 var locationManager = CLLocationManager()
 var LocationFunc =  false
 var isLocationFetched = false
 var getAddUserModel:AddUserModel!
 var getAddUserRatingDetail:AddUserRatingDetail!
 var getCategory = NSMutableArray()
 var getRecentItemCategory = NSMutableArray()
 var getPopularItemCategory = NSMutableArray()
 var getPendingList = NSMutableArray()
 var getSellerList = NSMutableArray()
 var getCity = NSMutableArray()
 var getImages = NSMutableArray()
 var getAboutUs = NSMutableArray()
 var getFavtems = NSMutableArray()
 var getAllRecentItems = NSMutableArray()
 var getAllPopularItems = NSMutableArray()
 var getAllHistryItems = NSMutableArray()
 var getFollowersItems = NSMutableArray()
 var getBannersItems = NSMutableArray()
 var getFollowersList = NSMutableArray()
 var getFollowingList = NSMutableArray()
 var getOfferList = NSMutableArray()
 var getRejectedList = NSMutableArray()
 var getPaidAdList = NSMutableArray()
 var getDisabledList = NSMutableArray()
 var getApproveList = NSMutableArray()
 var getPopularLatestList = NSMutableArray()
 var getOfferDetailList = NSMutableArray()
 var ArrChat = NSMutableArray()
 var MessageList = NSMutableArray()
 var getNotificationList = NSMutableArray()
 var getAllListItemForPopLat = NSMutableArray()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 3.0)
        let targetLang = UserDefaults.standard.object(forKey: "language") as? String
               
        if targetLang == nil {
           UserDefaults.standard.set("en", forKey: "language")
        }
       
         Bundle.setLanguage((targetLang != nil) ? targetLang : "en")
        fetchCurrentLocation(application)
        setKeyboard()
        configureSideMenu()
        FirebaseApp.configure()
     
        GMSServices.provideAPIKey(kMapsAPIKey)
        GMSPlacesClient.provideAPIKey(kMapsAPIKey)
        GIDSignIn.sharedInstance().clientID = "695349102594-vp9f75vbfnidfiig9hpp3cbef700a5tv.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
      
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)

        }
      
            
      
      application.registerForRemoteNotifications()
        return true
    }
    @objc func languageWillChange(notification:NSNotification)
    {
        let targetLang = notification.object as! String
        UserDefaults.standard.set(targetLang, forKey: "selectedLanguage")
        Bundle.setLanguage(targetLang)
        NotificationCenter.default.post(name: Notification.Name("LANGUAGE_DID_CHANGE"), object: targetLang)
    }
    func application(_app: UIApplication,open url:URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool{

       return GIDSignIn.sharedInstance().handle(url)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID sunil kumar: \(messageID)")
           }
         
           print(userInfo)
        
        if application.applicationState == .background
        {
            print("Davender Your app in background")
        }
        else if application.applicationState == .active
        {
           print("Davender Your app in forground")
        }
        else if application.applicationState == .inactive
       {
           print("Davender Your app in passive mode")
       }
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
    }
    
    
    
   

    func setKeyboard()
    {
        IQKeyboardManager.shared.enable = true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        let facebookDidHandle = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        ApplicationDelegate.shared.application(
                          application,
                          open: url,
                          sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                          annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
       
        let googleDidHandle = GIDSignIn.sharedInstance()!.handle(url as URL?)

        // Add any custom logic here.
           return googleDidHandle || facebookDidHandle
       }

    func userTabbar(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "MyTabbarViewController") as! MyTabbarViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        delegate?.window?.rootViewController = nav
        vc.selectedIndex = 0
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func userTabbarCheck(value:Int){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "MyTabbarViewController") as! MyTabbarViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        delegate?.window?.rootViewController = nav
        vc.selectedIndex = value
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
   
}
extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        
        print("Firebase SAVED token: \(fcmToken ?? "")")
        defaultValues.set(fcmToken, forKey: "DeviceID")
        defaultValues.synchronize()
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    
    }

}
extension AppDelegate {
    // MARK: Methods
    func configureSideMenu(){
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let SelcetCityIdName = "\(defaultValues.value(forKey: "selectCityName") ?? "")"
        if SelcetCityIdName != ""
        {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "MyTabbarViewController") as! MyTabbarViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            delegate?.window?.rootViewController = nav
            vc.selectedIndex = 0
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        else {
                 
            let delegate = UIApplication.shared.delegate as? AppDelegate
            let vc = KMainStoryBoard.instantiateViewController(withIdentifier: "SelectCityVC") as! SelectCityVC
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: true)
            delegate?.window?.rootViewController = nav
         
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        
             }
       
      }
}


extension AppDelegate{
    
    func determineMyCurrentLocation()
    {
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self as CLLocationManagerDelegate
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if  #available(iOS 14.0, *)
            {
              // self.locationManager.allowsBackgroundLocationUpdates = true
                 self.locationManager.pausesLocationUpdatesAutomatically = false
            }
            
            self.locationManager.requestAlwaysAuthorization()
            
            
            if CLLocationManager.locationServicesEnabled()
            {
                self.locationManager.startUpdatingLocation()
            }
            if #available(iOS 14.0, *) {
                if self.locationManager.authorizationStatus == .notDetermined {
                    self.locationManager.requestWhenInUseAuthorization()
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func fetchCurrentLocation(_ application: UIApplication)
    {
        
        if CLLocationManager.locationServicesEnabled() {
       switch CLLocationManager.authorizationStatus() {
       case .notDetermined:
           print("NotDetermined")
           self.determineMyCurrentLocation()
           break
       
       case .restricted, .denied:
           print("No access")
           let alert = UIAlertController(title: "Pachka", message: "We needs access to your location to check your shift location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
           
           alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
               guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                   return
               }
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                       print("Settings opened: \(success)")
                   })
               }
           }))
           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
           let vc = UIViewController()
           LocationFunc = true
           vc.present(alert, animated: true, completion: nil)
           
           break
       case .authorizedAlways, .authorizedWhenInUse:
           print("Access")
           
          // locationManager.startUpdatingLocation()
           
           break
       }
    }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        print(userLocation.coordinate)
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        manager.stopUpdatingLocation()
        DispatchQueue.main.async {
            if(!self.isLocationFetched) {
                // getCityStateUsingGeocoode(userLocation: userLocation)
                self.isLocationFetched = true
                UserDefaults.standard.set("\(userLocation.coordinate.latitude)", forKey: "USER_LATITUDE")
                UserDefaults.standard.set("\(userLocation.coordinate.longitude)", forKey: "USER_LONGITUDE")
                UserDefaults.standard.set("0", forKey: "EVENTSELECTIONTYPE")
                
                LocationServices.getAddressFromLatLong(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                UserDefaults.standard.synchronize()
                //            showTabbarVC()
            }
        }
        
    }
    
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager)
    {
        let accuracyAuthorization = manager.accuracyAuthorization
        switch accuracyAuthorization {
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "ForDelivery")
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}








