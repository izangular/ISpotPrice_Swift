//
//  ViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 23/07/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

import AVFoundation
import MobileCoreServices
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var locationManager = CLLocationManager()
    
    var imagePicker: UIImagePickerController?
    var propertyData : PropertyData!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
//        propertyData.latitude = locValue.latitude
//        propertyData.longitude = locValue.longitude
        
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: Error){
        print("Error: \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "capturePropertyView"{
            
            let capturePropertyViewController = segue.destination as! CapturePropertyViewController
            
            capturePropertyViewController.propertyData = propertyData
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        
        if (mediaType.isEqual(to: kUTTypeImage as String)){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            propertyData = PropertyData()
            propertyData.image = encodeImageToBase64(image: image)
            propertyData.latitude = locationManager.location?.coordinate.latitude
            propertyData.longitude = locationManager.location?.coordinate.longitude
            setDataParameters()
            
            self.performSegue(withIdentifier: "capturePropertyView", sender: self)
        }
    }
    
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
    
    func encodeImageToBase64(image: UIImage) -> String{
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    func decodeBase64ToImage(base64: String) -> UIImage{
        
        let dataDecoded: NSData = NSData(base64Encoded: base64, options:.ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedImage
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

