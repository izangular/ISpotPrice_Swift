//
//  CapturePropertyViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 23/07/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

import AVFoundation
import MobileCoreServices
import CoreLocation
import Alamofire

class CapturePropertyViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    // Properties
    var locationManager = CLLocationManager()
    
    var imagePicker: UIImagePickerController?
    var propertyData : PropertyData!
    var authToken: String = ""
    var authStatus: Int = -1
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelBuildYear: UILabel!
    @IBOutlet weak var labelSurfaceLiving: UILabel!
    
    @IBOutlet weak var sliderBuildYear: UISlider!
    @IBOutlet weak var sliderSurfaceLiving: UISlider!
    
    @IBOutlet var rootView: UIView!
    // Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let overlay = UIView(frame: view.frame)
//        overlay.backgroundColor = UIColor.black
//        overlay.alpha = 0.8
        
//        let loading = showLoading(title: nil, message: "Please wait..")
        
//        view.addSubview(overlay)
        
        UIOverlay.shared.showOverlay(view: rootView)
        
        getLocation()
        
//        getAuthToken { status, statusMessage, token in
//            
//            self.authToken = token
//            self.authStatus = status
//            
//            if status == 0 {
//                
//                print("Authentication Success")
//                    
////                let apiServ = APIService()
//                
////                apiServ.callImageService(base64Image: "", latitude: 47.408934, longitude: 8.547593, authToken: self.authToken, completion: { (statusCode, zip, town, street, country, category, appraisalValue, rating, catCode) in
////                        
////                    print(street)
////                })
////                apiServ.callAppraiseService(surfaceLiving: 10, landSurface: 10, roomNb: 1, bathNb: 2, buildYear: 1900, microRating: 4.5, catCode: 5, zip: "8050", town: "Zurich", street: "Tramstrasse 10", country: "Switzerland", authToken: self.authToken, completion: { (statusCode, zip, town, street, country, category, appraisalValue, rating, catCode) in
////                    
////                    print(appraisalValue)
////                })
//            }
//            else{
//                print("Error: \(statusMessage)")
//            }
////            loading()
////            overlay.removeFromSuperview()
//            UIOverlay.shared.hideOverlayView()
//        }
        
        UIOverlay.shared.hideOverlayView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Slider - Build year
    @IBAction func sliderBuildYearChanged(_ sender: Any) {
        
        let step:Float = 1.0
        
        let roundedValue = round(sliderBuildYear.value / step) * step
        sliderBuildYear.value = roundedValue
        
        labelBuildYear.text = "Baujahr: \(Int(sliderBuildYear.value))"
    }
    
    /// Slider - SurfaceLiving
    @IBAction func sliderSurfaceLivingChanged(_ sender: Any) {
        let step:Float = 0.5
        
        let roundedValue = round(sliderSurfaceLiving.value / step) * step
        sliderSurfaceLiving.value = roundedValue
        
        labelSurfaceLiving.text = "Wohnflache: \(sliderSurfaceLiving.value)"
    }
    
    /// Camera
    @IBAction func cameraPressed(_ sender: Any) {
        if  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        
        if (mediaType.isEqual(to: kUTTypeImage as String)){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            imageView.image = image
            propertyData = PropertyData()
            let imageBase64 = encodeImageToBase64(image: image)
//            propertyData.latitude = locationManager.location?.coordinate.latitude
//            propertyData.longitude = locationManager.location?.coordinate.longitude
//            setDataParameters()
            
            processImage(imageBase64: imageBase64)
        }
    }
    
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //        image.withHorizontallyFlippedOrientation()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinsishPickingMediaWithIfo info: [String: AnyObject]) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    /// Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
        //        propertyData.latitude = locValue.latitude
        //        propertyData.longitude = locValue.longitude
        
        //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error: \(error)")
    }
    
    //Methods
    
    func showLoading(title: String!, message: String) -> ()->() {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        return {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    func getAuthToken(completion: @escaping (_ status: Int, _ statusMessage: String, _ token: String)->()){
        let apiService = APIService()
        
        apiService.callServiceAuth(completion: { status, statusMessage, token in
            completion(status, statusMessage, token)
        })
    }
    
    func getLocation(){
        //        guard CLLocationManager.locationServicesEnabled() else{
        //            print("Location service is not enabled on your device. Please enable.")
        //            return
        //        }
        //
        //        let authStatus = CLLocationManager.authorizationStatus()
        //        guard authStatus == .authorizedWhenInUse else {
        //            switch authStatus{
        //            case .denied, .restricted:
        //                print("App not authorised to use your location")
        //
        //            case .notDetermined:
        //                locationManager.requestWhenInUseAuthorization()
        //
        //            default:
        //                print("Something went wrong!!")
        //            }
        //            return
        //        }
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if  CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //        self.locationManager.delegate = self
        //        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        self.locationManager.requestWhenInUseAuthorization()
        //        self.locationManager.startUpdatingLocation()
        //        print("Location working")
    }
    
    func encodeImageToBase64(image: UIImage) -> String{
        let imageData: NSData = UIImageJPEGRepresentation(image, 1)! as NSData
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    func decodeBase64ToImage(base64: String) -> UIImage{
        
        let dataDecoded: NSData = NSData(base64Encoded: base64, options:.ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedImage
        
    }
    
//    func loadData()
//    {
//        let image = decodeBase64ToImage(base64: propertyData.image!)
////
//        if let jpgData = UIImageJPEGRepresentation(image, 1.0){
//            if let imageSet =  UIImage(data: jpgData) {
//                imageView.image = imageSet
//            }
//        }
//        else {
//            imageView.image = image
//        }
//        
////        callService()
//        setPropertyData()
//    }
    
    func processImage(imageBase64: String){
        
        UIOverlay.shared.showOverlay(view: rootView)
        
        getAuthToken { status, statusMessage, token in
            
            self.authToken = token
            self.authStatus = status
            
            if status == 0 {
                
                self.propertyData.imageBase64 = imageBase64
                self.propertyData.latitude = 47.408934
                self.propertyData.longitude = 8.547593
                self.propertyData.surfaceLiving = 100
                self.propertyData.landSurface = 500
                self.propertyData.bathNb = 2
                self.propertyData.buildYear = 1999
                self.propertyData.roomNb = 3
                
                let apiServ = APIService()
                
                apiServ.callImageService(base64Image: self.propertyData.imageBase64!, latitude: self.propertyData.latitude!, longitude: self.propertyData.longitude!, authToken: self.authToken, completion: {
                                                    (statusCode, zip, town, street, country, category, appraisalValue, rating, catCode) in
                
                    print(street)
                    
                    self.propertyData.zip = zip
                    self.propertyData.town = town
                    self.propertyData.street = street
                    self.propertyData.country = country
                    self.propertyData.category = category
                    self.propertyData.rating = rating
                    self.propertyData.appraisalValue = appraisalValue
                    self.propertyData.catCode = catCode
                    
                })
                //                apiServ.callAppraiseService(surfaceLiving: 10, landSurface: 10, roomNb: 1, bathNb: 2, buildYear: 1900, microRating: 4.5, catCode: 5, zip: "8050", town: "Zurich", street: "Tramstrasse 10", country: "Switzerland", authToken: self.authToken, completion: { (statusCode, zip, town, street, country, category, appraisalValue, rating, catCode) in
                //
                //                    print(appraisalValue)
                //                })
            }
            else{
                self.showMessageBox(title: "Error", message: "Authentication failure", preferredStyle: UIAlertControllerStyle.alert)
            }
            UIOverlay.shared.hideOverlayView()
        }
        
    }
    
    func showMessageBox(title: String, message: String, preferredStyle: UIAlertControllerStyle){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "Click", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setPropertyData()
    {
//        labelStreetZipTown.text = "\(String(describing: String(propertyData.street!))), \(String(describing: String(propertyData.zip!))) \(String(describing: propertyData.town!)) "
////
//        labelPrice.text = String(propertyData.price!)
//        labelRating.text = String(propertyData.microRating!)
//        labelPropertyType.text = String(propertyData.propertyType!)
//        
//        sliderRoomNumber.value = propertyData.roomNb!
//        setSliderStepAndLabel(slider: sliderRoomNumber, label: labelRoomNumber, step: 0.5)
//        
//        sliderBathNumber.value = Float(propertyData.bathNb!)
//        setSliderStepAndLabel(slider: sliderBathNumber, label: labelBathNumber, step: 1)
//        
//        sliderSurfaceLiving.value = propertyData.surfaceLiving!
//        setSliderStepAndLabel(slider: sliderSurfaceLiving, label: labelSurfaceLiving, step: 0.5)
//        
//        sliderBuildYear.value = Float(propertyData.buildYear!)
//        setSliderStepAndLabel(slider: sliderBuildYear, label: labelBuildYear, step: 1)
        
    }
}

