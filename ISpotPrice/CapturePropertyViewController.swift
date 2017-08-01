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
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelBuildYear: UILabel!
    @IBOutlet weak var labelSurfaceLiving: UILabel!
    
    @IBOutlet weak var sliderBuildYear: UISlider!
    @IBOutlet weak var sliderSurfaceLiving: UISlider!
    
    // Events
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getLocation()
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
            propertyData.image = encodeImageToBase64(image: image)
            propertyData.latitude = locationManager.location?.coordinate.latitude
            propertyData.longitude = locationManager.location?.coordinate.longitude
            setDataParameters()
            callService()
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
    
    func setDataParameters(){
        propertyData.street = "Tramstrasse 10"
        propertyData.zip = "8050"
        propertyData.town = "Zurich"
        
        propertyData.microRating = 2.0
        propertyData.propertyType = "House"
        propertyData.price = 2000300
        propertyData.bathNb = 2
        propertyData.buildYear = 1990
        propertyData.microRating = 5
        propertyData.renovationYear = 0
        propertyData.roomNb = 2.5
        propertyData.surfaceLiving = 120
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
    
    func callService(){
        let url = "https://devweb.iazi.ch/Service.Report_2407/api/Image/ImageProcessing"
        
        let parameters: Parameters = ["imageBase64": propertyData.image!, "latitude": propertyData.latitude!, "longitude": propertyData.longitude!]
        
//        print(parameters)
//        return
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ response in
            print (response.request!)
            print(response.response!)
            print(response.result)
            
            if let jsonData = response.result.value{
                print(jsonData)
                
//                do {
//                    
//                    if let dictionary = jsonData as? [String: AnyObject]{
//                        print(dictionary)
//                        if let appraisalValue = dictionary["appraisalValue"] as? Int{
//                            self.propertyData.price = appraisalValue
//                        }
//                        
//                        if let category = dictionary["category"] as? String{
//                            self.propertyData.propertyType = category
//                        }
//                        
//                        //                            if let country = dictionary["country"] as? String{
//                        //                                self.propertyData.propertyType = category
//                        //                            }
//                        
//                        if let rating = dictionary["rating"] as? Double{
//                            self.propertyData.microRating = rating
//                        }
//                        
//                        if let street = dictionary["street"] as? String{
//                            self.propertyData.street = street
//                        }
//                        
//                        if let town = dictionary["town"] as? String{
//                            self.propertyData.town = town
//                        }
//                        
//                        if let zip = dictionary["zip"] as? String{
//                            self.propertyData.zip   = zip
//                        }
//                    }
//                    
//                    
//                } catch {
//                    print("JSON Processing Failed")
//                }
                
            }
            
        }
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

