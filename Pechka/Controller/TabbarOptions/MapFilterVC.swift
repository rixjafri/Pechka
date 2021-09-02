//
//  MapFilterVC.swift
//  Pechka
//
//  Created by Neha Saini on 12/05/21.
//

import UIKit
import MapKit
import MultiSlider
import GoogleMaps
import CoreLocation
import GooglePlaces
import GooglePlacePicker

class MapFilterVC: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{

    //MARK:- IBOutlets
    @IBOutlet weak var lblValueFinalKm: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var btnTen: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnFifth: UIButton!
    @IBOutlet weak var btnFourth: UIButton!
    @IBOutlet weak var btnThird: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnElevenValueKm: UIButton!
    @IBOutlet weak var lblTenValueKm: UILabel!
    @IBOutlet weak var btnTenValueKm: UIButton!
    @IBOutlet weak var lblNineValueKm: UILabel!
    @IBOutlet weak var btnNineValueKm: UIButton!
    @IBOutlet weak var lblEightValueKm: UILabel!
    @IBOutlet weak var btnEightValueKm: UIButton!
    @IBOutlet weak var lblSevenValueKm: UILabel!
    @IBOutlet weak var btnSevenValueKm: UIButton!
    @IBOutlet weak var lblSixValueKm: UILabel!
    @IBOutlet weak var btnSixValueKm: UIButton!
    @IBOutlet weak var lblFifthValueKm: UILabel!
    @IBOutlet weak var btnFifthValueKm: UIButton!
    @IBOutlet weak var btnFourthValueKm: UIButton!
    @IBOutlet weak var lblFourthValueKm: UILabel!
    @IBOutlet weak var lblThirdValueKm: UILabel!
    @IBOutlet weak var btnThirdValueKm: UIButton!
    @IBOutlet weak var lblSecValueKm: UILabel!
    @IBOutlet weak var btnSecValueKm: UIButton!
    @IBOutlet weak var lblValueKm: UILabel!
    @IBOutlet weak var btnValueKm: UIButton!
    @IBOutlet weak var btnAreaRange: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var lblLocAddress: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewBgSlider: UIView!
    
    //MARK:- Variable Declaration
    var cirlce: GMSCircle!
    let ageslider = MultiSlider()
    let distanceSlider = MultiSlider()
    var checklatitude = 0.0
    var checklongitude = 0.0
    let loc = CLLocationManager()
    var valueInKm = Double()
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        setInitials()
        lblLocAddress.text = "\(UserDefaults.standard.value(forKey: "ADDRESS") ?? "")"
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateLatLong), name: NSNotification.Name(rawValue: "UpdateLatLong"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        let userLatitude = "\(UserDefaults.standard.value(forKey: "USER_LATITUDE") ?? "")"
        if userLatitude == ""
        {
            if CLLocationManager.locationServicesEnabled() {
                   switch CLLocationManager.authorizationStatus() {
                   case .notDetermined, .restricted, .denied:
                    let alert = UIAlertController(title: "Pachka", message: NSLocalizedString("To re-enable, please go to Settings and turn on Location Service for this app.", comment: ""), preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default, handler: { action in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                   case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                      // locationManager.startUpdatingLocation()
                   }
               } else {

                APPDELEGATE.determineMyCurrentLocation()
               }
        }
          
       
        
        
        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
            checklatitude = doubleLat
        }
        
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
            checklongitude = doubleLng
        }
       
       
        if let userAddress = UserDefaults.standard.value(forKey: "ADDRESS")
        {
            lblLocAddress.text = "\(userAddress)"
        }
        mapView.delegate = self
     
        loc.delegate = self
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.requestAlwaysAuthorization()
               
               if CLLocationManager.locationServicesEnabled() {
                   //locationManager.startUpdatingHeading()
                loc.startUpdatingLocation()
               }
        setupData()
    }
    func addRadiusCircle(location: CLLocation){
       
            self.mapView.delegate = self
            let circle = MKCircle(center: location.coordinate, radius: 1000)
            self.mapView.addOverlay(circle)
        
       
    }
    @objc func UpdateLatLong(_ notification: Notification)
    {
        if (notification.name.rawValue == "UpdateLatLong")
        {
            var doubleLat = 0.0
            var doubleLng = 0.0
            if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
                 
                doubleLat = Double(userLatitude as! String)!
                
               
            }
            
            if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
                doubleLng = Double(userLongitude as! String)!
             
            }
            if let userAddress = UserDefaults.standard.value(forKey: "ADDRESS")
            {
               lblLocAddress.text = "\(userAddress)"
            }
           
            checklatitude = doubleLat
            checklongitude = doubleLng
            mapView.delegate = self
          
         
            centerMapOnLocation()
            loc.delegate = self
            loc.desiredAccuracy = kCLLocationAccuracyBest
            loc.requestAlwaysAuthorization()
                   
                   if CLLocationManager.locationServicesEnabled() {
                       //locationManager.startUpdatingHeading()
                    loc.startUpdatingLocation()
                   }
            setupData()
        }
    }
    
  

    //MARK:- Custom Methods
    func setInitials()
    {
        distanceSliderRangeSetUp()
        centerMapOnLocation()
        btnValueKm.tag = 101
        btnSecValueKm.tag = 102
        btnThirdValueKm.tag = 103
        btnFourthValueKm.tag = 104
        btnFifthValueKm.tag = 105
        btnSixValueKm.tag = 106
        btnSevenValueKm.tag = 107
        btnEightValueKm.tag = 108
        btnNineValueKm.tag = 109
        btnTenValueKm.tag = 110
        btnElevenValueKm.tag = 111
        btnFirst.tag = 121
        btnSecond.tag = 122
        btnThird.tag = 123
        btnFourth.tag = 124
        btnFifth.tag = 125
        btnSix.tag = 126
        btnSeven.tag = 127
        btnEight.tag = 128
        btnNine.tag = 129
        btnTen.tag = 130
        
        btnValueKm.layer.cornerRadius = btnValueKm.frame.height/2
        btnSecValueKm.layer.cornerRadius = btnSecValueKm.frame.height/2
        btnThirdValueKm.layer.cornerRadius = btnThirdValueKm.frame.height/2
        btnFourthValueKm.layer.cornerRadius = btnFourthValueKm.frame.height/2
        btnFifthValueKm.layer.cornerRadius = btnFifthValueKm.frame.height/2
        btnSixValueKm.layer.cornerRadius = btnSixValueKm.frame.height/2
        btnSevenValueKm.layer.cornerRadius = btnSevenValueKm.frame.height/2
        btnEightValueKm.layer.cornerRadius = btnEightValueKm.frame.height/2
        btnNineValueKm.layer.cornerRadius = btnNineValueKm.frame.height/2
        btnTenValueKm.layer.cornerRadius = btnTenValueKm.frame.height/2
        btnElevenValueKm.layer.cornerRadius = btnElevenValueKm.frame.height/2
        btnValueKm.backgroundColor = BaseViewController.appColor
        btnSecValueKm.backgroundColor = UIColor.darkGray
        btnThirdValueKm.backgroundColor = UIColor.darkGray
        btnFourthValueKm.backgroundColor = UIColor.darkGray
        btnFifthValueKm.backgroundColor = UIColor.darkGray
        btnSixValueKm.backgroundColor = UIColor.darkGray
        btnSevenValueKm.backgroundColor = UIColor.darkGray
        btnEightValueKm.backgroundColor = UIColor.darkGray
        btnNineValueKm.backgroundColor = UIColor.darkGray
        btnTenValueKm.backgroundColor = UIColor.darkGray
        btnElevenValueKm.backgroundColor = UIColor.darkGray
    }
    
    func centerMapOnLocation(){

        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
        }
        
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
        }

           let centerRegionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLng)

           let spanRegion:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
           let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: centerRegionCoordinate, span: spanRegion)
       
           mapView.setRegion(mapRegion, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
        }
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
        }
        checklatitude = doubleLat
        checklongitude = doubleLng
           let center = CLLocationCoordinate2D(latitude: checklatitude, longitude: checklongitude)
           let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
           
           mapView.setRegion(region, animated: true)
           
           // Drop a pin at user's Current Location
//           let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//           myAnnotation.coordinate = CLLocationCoordinate2DMake(checkInEventlatitude, checkInEventlongitude);
////           myAnnotation.title = "Current location"
//           mapView.addAnnotation(myAnnotation)
       }
       
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
       {
           print("Error \(error)")
       }
    
    func setupData()
    {
        mapView.delegate = self
        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
        }
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
        }
        checklatitude = doubleLat
        checklongitude = doubleLng
        let coordinate = CLLocationCoordinate2DMake(checklatitude, checklongitude)
           mapView.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: valueInKm, longitudinalMeters: valueInKm)

         //  let title = "Marina Bar Hop"
           let restaurantAnnotation = MKPointAnnotation()
           restaurantAnnotation.coordinate = coordinate
        //   restaurantAnnotation.title = title
           mapView.addAnnotation(restaurantAnnotation)
        // Above line throws runtime exception
        let removeOverlays = self.mapView.overlays
           self.mapView.removeOverlays(removeOverlays)
           let regionRadius = valueInKm
           let circle = MKCircle(center: coordinate, radius: regionRadius)
           mapView.addOverlay(circle)
    }

    // 6. draw circle
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.1)
            circleRenderer.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
    @objc func sliderChanged(slider: MultiSlider) {
        let data  = slider.value
        let first =  Int(data[0])
        let second =  Int(data[1])
//        let  rangeStr = String(first) + " - " +  String(second)
//        lblAgerange.text = rangeStr
        
    }
    
    func distanceSliderRangeSetUp( )  {
        
       
        
        btnApply.layer.backgroundColor = BaseViewController.appColor.cgColor
        btnApply.layer.cornerRadius = 15
        btnApply.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner]
        distanceSlider.frame =  CGRect(x: 8, y:20, width: UIScreen.main.bounds.size.width - 76 , height: 15 )
       // viewBgSlider.addSubview(distanceSlider)
        distanceSlider.minimumValue = 0    // default is 0.0
        distanceSlider.maximumValue = 500   // default is 1.0
        distanceSlider.outerTrackColor = BaseViewController.appColor // outside of first and last thumbs
        distanceSlider.value = [0, 500]
        distanceSlider.orientation = .horizontal // default is .vertical
        distanceSlider.isVertical = false
        distanceSlider.tintColor = BaseViewController.appColor // color of track
        distanceSlider.trackWidth = 5
        distanceSlider.valueLabelPosition = .bottom
        distanceSlider.valueLabelColor = BaseViewController.appColor
    
        
       
       
//        ageslider.thumbImage = #imageLiteral(resourceName: "thumbImage")
      
        distanceSlider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        
        
    }
    @objc func distanceSliderChanged(slider: MultiSlider)
    {
        let data  = slider.value
        let first =  Int(data[0])
        let second =  Int(data[1])
        let  rangeStr = String(first) + " - " +  String(second)
//        lblAgerange.text = rangeStr
    }
    //MARK:- IBActions
    @IBAction func action_valueKmTypeBtnTapped(_ sender: UIButton)
    {
      
        if sender.tag == 101
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = UIColor.darkGray
            btnThirdValueKm.backgroundColor = UIColor.darkGray
            btnFourthValueKm.backgroundColor = UIColor.darkGray
            btnFifthValueKm.backgroundColor = UIColor.darkGray
            btnSixValueKm.backgroundColor = UIColor.darkGray
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = UIColor.lightGray
            lblSecValueKm.backgroundColor = UIColor.lightGray
            lblThirdValueKm.backgroundColor = UIColor.lightGray
            lblFourthValueKm.backgroundColor = UIColor.lightGray
            lblFifthValueKm.backgroundColor = UIColor.lightGray
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 0.5
        }
        else if sender.tag == 102 || sender.tag == 121
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = UIColor.darkGray
            btnFourthValueKm.backgroundColor = UIColor.darkGray
            btnFifthValueKm.backgroundColor = UIColor.darkGray
            btnSixValueKm.backgroundColor = UIColor.darkGray
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = UIColor.lightGray
            lblThirdValueKm.backgroundColor = UIColor.lightGray
            lblFourthValueKm.backgroundColor = UIColor.lightGray
            lblFifthValueKm.backgroundColor = UIColor.lightGray
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 1.0
        }
        else if sender.tag == 103 || sender.tag == 122
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = UIColor.darkGray
            btnFifthValueKm.backgroundColor = UIColor.darkGray
            btnSixValueKm.backgroundColor = UIColor.darkGray
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = UIColor.lightGray
            lblFourthValueKm.backgroundColor = UIColor.lightGray
            lblFifthValueKm.backgroundColor = UIColor.lightGray
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 2.5
        }
        else if sender.tag == 104 || sender.tag == 123
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = UIColor.darkGray
            btnSixValueKm.backgroundColor = UIColor.darkGray
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = UIColor.lightGray
            lblFifthValueKm.backgroundColor = UIColor.lightGray
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 5.0
        }
        else if sender.tag == 105 || sender.tag == 124
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = UIColor.darkGray
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = UIColor.lightGray
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 10.0
        }
        else if sender.tag == 106 || sender.tag == 125
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = UIColor.darkGray
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = UIColor.lightGray
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 25.0
        }
        else if sender.tag == 107 || sender.tag == 126
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = BaseViewController.appColor
            btnEightValueKm.backgroundColor = UIColor.darkGray
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = BaseViewController.appColor
            lblSevenValueKm.backgroundColor = UIColor.lightGray
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 50.0
        }
        else if sender.tag == 108 || sender.tag == 127
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = BaseViewController.appColor
            btnEightValueKm.backgroundColor = BaseViewController.appColor
            btnNineValueKm.backgroundColor = UIColor.darkGray
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = BaseViewController.appColor
            lblSevenValueKm.backgroundColor = BaseViewController.appColor
            lblEightValueKm.backgroundColor = UIColor.lightGray
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 100.0
           
        }
        else if sender.tag == 109 || sender.tag == 128
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = BaseViewController.appColor
            btnEightValueKm.backgroundColor = BaseViewController.appColor
            btnNineValueKm.backgroundColor = BaseViewController.appColor
            btnTenValueKm.backgroundColor = UIColor.darkGray
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = BaseViewController.appColor
            lblSevenValueKm.backgroundColor = BaseViewController.appColor
            lblEightValueKm.backgroundColor = BaseViewController.appColor
            lblNineValueKm.backgroundColor = UIColor.lightGray
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 200.0
        }
        else if sender.tag == 110 || sender.tag == 129
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = BaseViewController.appColor
            btnEightValueKm.backgroundColor = BaseViewController.appColor
            btnNineValueKm.backgroundColor = BaseViewController.appColor
            btnTenValueKm.backgroundColor = BaseViewController.appColor
            btnElevenValueKm.backgroundColor = UIColor.darkGray
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = BaseViewController.appColor
            lblSevenValueKm.backgroundColor = BaseViewController.appColor
            lblEightValueKm.backgroundColor = BaseViewController.appColor
            lblNineValueKm.backgroundColor = BaseViewController.appColor
            lblTenValueKm.backgroundColor = UIColor.lightGray
            valueInKm = 500.0
        }
        else if sender.tag == 111 || sender.tag == 130
        {
            btnValueKm.backgroundColor = BaseViewController.appColor
            btnSecValueKm.backgroundColor = BaseViewController.appColor
            btnThirdValueKm.backgroundColor = BaseViewController.appColor
            btnFourthValueKm.backgroundColor = BaseViewController.appColor
            btnFifthValueKm.backgroundColor = BaseViewController.appColor
            btnSixValueKm.backgroundColor = BaseViewController.appColor
            btnSevenValueKm.backgroundColor = BaseViewController.appColor
            btnEightValueKm.backgroundColor = BaseViewController.appColor
            btnNineValueKm.backgroundColor = BaseViewController.appColor
            btnTenValueKm.backgroundColor = BaseViewController.appColor
            btnElevenValueKm.backgroundColor = BaseViewController.appColor
            lblValueKm.backgroundColor = BaseViewController.appColor
            lblSecValueKm.backgroundColor = BaseViewController.appColor
            lblThirdValueKm.backgroundColor = BaseViewController.appColor
            lblFourthValueKm.backgroundColor = BaseViewController.appColor
            lblFifthValueKm.backgroundColor = BaseViewController.appColor
            lblSixValueKm.backgroundColor = BaseViewController.appColor
            lblSevenValueKm.backgroundColor = BaseViewController.appColor
            lblEightValueKm.backgroundColor = BaseViewController.appColor
            lblNineValueKm.backgroundColor = BaseViewController.appColor
            lblTenValueKm.backgroundColor = BaseViewController.appColor
        }
        lblValueFinalKm.text = "\(valueInKm)"
        setupData()
    }
    
    @IBAction func action_resetBtnTapped(_ sender: UIButton)
    {
        
    }
    
    @IBAction func action_backBtnTapeped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_areaRangeBtnTapped(_ sender: UIButton)
    {
        
            if CLLocationManager.locationServicesEnabled() {
                   switch CLLocationManager.authorizationStatus() {
                   case .notDetermined, .restricted, .denied:
                    let alert = UIAlertController(title: "Pachka", message: "To re-enable, please go to Settings and turn on Location Service for this app.", preferredStyle: UIAlertController.Style.alert)
                    
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
                    self.present(alert, animated: true, completion: nil)
                    
                   case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    APPDELEGATE.determineMyCurrentLocation()
                      // locationManager.startUpdatingLocation()
                   }
               } else {

                APPDELEGATE.determineMyCurrentLocation()
               }
        
          
       
    }
    
    @IBAction func action_applyBtnTapped(_ sender: UIButton)
    {
        var doubleLat = 0.0
        var doubleLng = 0.0
        if let userLatitude = UserDefaults.standard.value(forKey: "USER_LATITUDE") {
             
            doubleLat = Double(userLatitude as! String)!
            
           
        }
        
        if let userLongitude = UserDefaults.standard.value(forKey: "USER_LONGITUDE") {
            doubleLng = Double(userLongitude as! String)!
         
        }
        let objRef:RecentProductsItemsVC = self.storyboard?.instantiateViewController(withIdentifier: "RecentProductsItemsVC") as! RecentProductsItemsVC
            objRef.screenCheck = "search"
        objRef.searchDict = ["searchterm":"" ,"cat_id":"","sub_cat_id":"","order_type":"","order_by":"","item_type_id":"","item_price_type_id":"","condition_of_item_id":"","deal_option_id":"","max_price":"" ,"min_price": "","login_user_id":defaultValues.value(forKey: "UserID") as? String ?? "","lat":doubleLat,"lng":doubleLng,"miles":valueInKm]
        print(objRef.searchDict)
        self.navigationController?.pushViewController(objRef, animated: true)
    }
    
}
