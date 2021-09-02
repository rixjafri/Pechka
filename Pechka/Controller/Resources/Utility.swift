//
//  PiratesCabinVC.swift
//  MedConnex
//
//  Created by PBS9 on 16/07/19.
//  Copyright © 2019 Dinesh Raja. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class Utility
{
    
    static func showAlertMessage(vc: UIViewController?, titleStr:String, messageStr:String) -> Void
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
        let action = UIAlertAction.init(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        if (vc == nil)
        {
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            vc?.present(alert, animated: true, completion: nil)
        }
    }
}
class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [String]!
    var years: [Int]!
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0)+1
        let year = years[self.selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }
        self.month = month
        self.year = year
    }
    
}

//For the RoundedButton with border color and cornerradius also for UIButton.
@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

//For the Roundedview with border color and cornerradius also for UIView.
@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var rightSideCorner: CGFloat = 0{
        didSet{
            self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        }
    }
}
extension UIButton
{
   
        func setCornerRadiusOfButton(value:CGFloat)
        {
            self.layer.shadowOffset = CGSize(width: 0.2, height: 0.1)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 1
            self.layer.cornerRadius = value
            self.layer.masksToBounds =  false
        }
  
}
extension UIView
{
    func setMaxCornerRadius(value:CGFloat,color:CGColor)
    {
//        self.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 1
        self.layer.cornerRadius = value
        self.layer.shadowColor = color
        self.layer.masksToBounds =  false
    }
    func setBordersAndradius(color: UIColor , radius : Float )  {
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = CGFloat(radius)
    }
      
    func setShadowForView()
    {
      self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
      self.layer.shadowOpacity = 0.3
      self.layer.shadowRadius = 1
      self.layer.cornerRadius = self.frame.height/2
      self.layer.masksToBounds =  false
    }
    
    func setCornerRadius(value:CGFloat)
    {
      self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
      self.layer.shadowOpacity = 0.3
      self.layer.shadowRadius = 1
      self.layer.cornerRadius = value
      self.layer.masksToBounds =  false
    }
}

extension UIViewController
{
    //Mark:- Validations
    // Verifying valid Email or Not
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // vrify Valid PhoneNumber or Not
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{10}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    // Show AlertMessage
    func showAlert(_ title: String, _ message:String,_ buttonTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { (action: UIAlertAction) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addsubView(subView:UIView , superView:UIView){
        let topConstraint = NSLayoutConstraint(item: superView, attribute: .top, relatedBy: .equal, toItem: subView , attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: superView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: superView, attribute: .leading, relatedBy: .equal, toItem: subView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: superView, attribute: .trailing, relatedBy: .equal, toItem: subView, attribute: .trailing, multiplier: 1, constant: 0)
        
        subView.addSubview(superView)
        subView.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
        subView.layoutIfNeeded()
    }
    func changedateFormat(date: Date?, format: String) -> String {
        
        let inputFormatter = DateFormatter()
      
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        
        let showDate = inputFormatter.string(from: date ?? Date())
        inputFormatter.dateFormat = format
        let date = inputFormatter.date(from: showDate)
        let resultString = inputFormatter.string(from: Date())
       return resultString
    }
    
    
    func formatDate(date: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateObj: Date? = dateFormatterGet.date(from: date)
        return dateFormatter.string(from: dateObj!)
    }
    
    func currencyFormat(_ value: String?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "$\(doubleValue)"
    }
    
    func numbFormat(_ someString: String?) -> NSNumber {
        guard someString != nil else { return 0000 }
        let doubleValue = Double(someString!) ?? 0000
        let myInteger = Int(doubleValue)
        let myNumber = NSNumber(value:myInteger)
        return myNumber
    }
    
    
}
//Maximum length of characters for text field

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
            get {
                return self.placeHolderColor
            }
            set {
                self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
            }
        }
   
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    var numberValue: NSNumber? {
        if let value = Int(self) {
            return NSNumber(value: value)
        }
        return nil
    }
}

//MARK:- Button Text UnderLine
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
//MARK:- Label Text UnderLine
extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension UIView {
    func setOnSideCorner(outlet:UIView){
        //Corner radius for view.
        outlet.clipsToBounds = true
        outlet.layer.cornerRadius = 15
        outlet.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        
    }
    func setOnbottomCorner(outlet:UIView){
           //Corner radius for view.
           outlet.clipsToBounds = true
           outlet.layer.cornerRadius = 25
           outlet.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
           
       }
    func dropShadow(view: UIView, opacity: Float){
        view.layer.shadowColor = UIColor.brown.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
    }
}
extension UIApplication {
    var statusBarView: UIView?{
        return value(forKey: "statusBar") as? UIView
    }
}
//MARK:- Convert NSSTRING TO Dictionary

extension NSString {
    
    func convertToDictionary() -> [String: Any]? {
        
        if let data = self.data(using: String.Encoding.utf8.rawValue) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
extension String {
    
    func fromBase64() -> String? {
        
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    func toBase64() -> String? {
        
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
extension UserDefaults {
    
    public func optionalInt(forKey defaultName: String) -> Int? {
        let defaults = self
        if let value = defaults.value(forKey: defaultName) {
            return value as? Int
        }
        return nil
    }
}
extension UILabel {
    
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
}
extension CLLocation {
    /// Returns a distance in meters from a starting location to a destination location.
    func calculateDrivingDistance(to destination: CLLocation, completion: @escaping(CLLocationDistance?) -> Void) {
        let request = MKDirections.Request()
        let startingPoint = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.coordinate.latitude, self.coordinate.longitude)))
        let endingPoint = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(destination.coordinate.latitude, destination.coordinate.longitude)))
        request.source = startingPoint
        request.destination = endingPoint
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error != nil {
                assertionFailure("Failed to calculate driving distance. \(String(describing: error))")
            }
            guard let data = response else { return }
            let meterDistance = data.routes.first?.distance
            completion(meterDistance)
        }
    }
}
extension UIView{
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
extension UIScrollView {
       func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y-100,width: 1,height: self.frame.height), animated: animated)
        }
    }
}
extension UISegmentedControl {
    func font(name:String?, size:CGFloat?) {
        let attributedSegmentFont = NSDictionary(object: UIFont(name: name!, size: size!)!, forKey: NSAttributedString.Key.font as NSCopying)
        setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: .normal)
    }
}
