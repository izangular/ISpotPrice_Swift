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
import Alamofire

class CapturePropertyViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var propertyData = PropertyData()
    
    //
    @IBOutlet weak var labelStreetZipTown: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelPropertyType: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    //
    @IBOutlet weak var labelSurfaceLiving: UILabel!
    @IBOutlet weak var sliderSurfaceLiving: UISlider!
    @IBOutlet weak var labelRoomNumber: UILabel!
    @IBOutlet weak var sliderRoomNumber: UISlider!
    @IBOutlet weak var labelBathNumber: UILabel!
    @IBOutlet weak var sliderBathNumber: UISlider!
    @IBOutlet weak var labelBuildYear: UILabel!
    @IBOutlet weak var sliderBuildYear: UISlider!
    
    
    @IBAction func sliderBuildYearChanged(_ sender: Any) {
        
        setSliderStepAndLabel(slider: sliderBuildYear, label: labelBuildYear, step: 1)
    }
    @IBAction func sliderBathNumberChanged(_ sender: Any) {
        
        setSliderStepAndLabel(slider: sliderBathNumber, label: labelBathNumber, step: 1)
    }
    @IBAction func sliderRoomNumberChanged(_ sender: Any) {
        
        setSliderStepAndLabel(slider: sliderRoomNumber, label: labelRoomNumber, step: 0.5)
    }
    @IBAction func sliderSurfaceLivingChanged(_ sender: Any) {
        
        setSliderStepAndLabel(slider: sliderSurfaceLiving, label: labelSurfaceLiving, step: 0.5)
    }
    
    func setSliderStepAndLabel(slider : UISlider, label: UILabel, step: Float) {
        
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        
        label.text = "(\(slider.value))"
    }
    
    //
    @IBAction func appraisePressed(_ sender: Any) {
        
        
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
    
    func decodeBase64ToImage(base64: String) -> UIImage{
        
        
        let dataDecoded: NSData = NSData(base64Encoded: base64, options:.ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedImage
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageView.layer.cornerRadius = self.imageView.frame.width/30
        self.imageView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData()
    {
        let image = decodeBase64ToImage(base64: propertyData.image!)
//
        if let jpgData = UIImageJPEGRepresentation(image, 1.0){
            if let imageSet =  UIImage(data: jpgData) {
                imageView.image = imageSet
            }
        }
        else {
            imageView.image = image
        }
        
//        callService()
        setPropertyData()
    }
    
    func setPropertyData()
    {
        labelStreetZipTown.text = "\(String(describing: String(propertyData.street!))), \(String(describing: String(propertyData.zip!))) \(String(describing: propertyData.town!)) "
//
        labelPrice.text = String(propertyData.price!)
        labelRating.text = String(propertyData.microRating!)
        labelPropertyType.text = String(propertyData.propertyType!)
        
        sliderRoomNumber.value = propertyData.roomNb!
        setSliderStepAndLabel(slider: sliderRoomNumber, label: labelRoomNumber, step: 0.5)
        
        sliderBathNumber.value = Float(propertyData.bathNb!)
        setSliderStepAndLabel(slider: sliderBathNumber, label: labelBathNumber, step: 1)
        
        sliderSurfaceLiving.value = propertyData.surfaceLiving!
        setSliderStepAndLabel(slider: sliderSurfaceLiving, label: labelSurfaceLiving, step: 0.5)
        
        sliderBuildYear.value = Float(propertyData.buildYear!)
        setSliderStepAndLabel(slider: sliderBuildYear, label: labelBuildYear, step: 1)
        
    }
}

