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

class CapturePropertyViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    var propertyData = PropertyData()
    
    @IBOutlet weak var labelStreetZipTown: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    //
//    @IBOutlet weak var labelRating: UILabel!
//    @IBOutlet weak var labelPrice: UILabel!
//    @IBOutlet weak var labelHouseType: UILabel!
    
    
    @IBAction func appraisePressed(_ sender: Any) {
        
        
    }
    
    func decodeBase64ToImage(base64: String) -> UIImage{
        
        
        let dataDecoded: NSData = NSData(base64Encoded: base64, options:.ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedImage
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        
        let image = decodeBase64ToImage(base64: propertyData.image!)
        
        if let jpgData = UIImageJPEGRepresentation(image, 1.0){
            imageView.image =  UIImage(data: jpgData)
//            imageView.image?.withHorizontallyFlippedOrientation()
        }
        else {
            imageView.image = image
        }
        
        setPropertyData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPropertyData()
    {
        labelStreetZipTown.text = "\(String(describing: String(propertyData.street!))), \(String(describing: String(propertyData.zip!))) \(String(describing: propertyData.town!)) "//( lat: \(String(propertyData.latitude!)), lon: \(String(propertyData.longitude!)) )"
//
//        labelPrice.text = String(propertyData.price!)
//        labelRating.text = String(propertyData.microRating!)
//        labelHouseType.text = String(propertyData.propertyType!)
    }
}

