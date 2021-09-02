//
//  AutoCompleteVC.swift
//  GooglePlaces
//
//  Created by Mac-Vishal on 07/07/17.
//  Copyright © 2017 Vishal. All rights reserved.
//

import UIKit
import GooglePlacePicker
class AutoCompleteVC: UIViewController {
    @IBOutlet var indicatorView:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAutocompletePicker()
        self.navigationController?.navigationBar.isHidden = true
    }
    func getAutocompletePicker()
    {
        let gmsAutoCompleteViewController = GMSAutocompleteViewController()
        gmsAutoCompleteViewController.delegate = self
        present(gmsAutoCompleteViewController, animated: true)
        {
          if let searchBar = (gmsAutoCompleteViewController.view.subviews
            .flatMap { $0.subviews }
            .flatMap { $0.subviews }
            .flatMap { $0.subviews }
            .filter { $0 == $0 as? UISearchBar}).first as? UISearchBar
             {
                searchBar.placeholder = "Enter new address."
                searchBar.delegate?.searchBar?(searchBar, textDidChange: "Enter new address.") // to get the autoComplete Response
             }
        }
    }
    @IBAction func refresh(sender: UIButton)
    {
        self.getAutocompletePicker()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension AutoCompleteVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace){
    PostAddress = (place.formattedAddress?.components(separatedBy: ", ")
        .joined(separator: ","))!
    UserDefaults.standard.set(PostAddress, forKey: "ADDRESS")
    Postlatitude =  place.coordinate.latitude
    Postlongitude =  place.coordinate.longitude
    UserDefaults.standard.set("\(Postlatitude)", forKey: "USER_LATITUDE")
    UserDefaults.standard.set("\( Postlongitude)", forKey: "USER_LONGITUDE")
    UserDefaults.standard.synchronize()
    dismiss(animated: true, completion: nil)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateLatLong"), object: nil, userInfo: nil)
    popBack(2)
    }
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        self.popBack(2)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
