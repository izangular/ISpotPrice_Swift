//
//  PropertyViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 04/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import MapKit
import ReactiveKit
import Bond

class PropertyViewController: UIViewController, MKMapViewDelegate {
    
    // Properties
    var propertyInfo = PropertyInfo()
    var image: UIImage!
    
    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var labelSurfaceLiving: UILabel!
    @IBOutlet weak var labelRoomNumber: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    
    @IBOutlet weak var sliderSurfaceLiving: UISlider!
    @IBOutlet weak var sliderRoomNumber: UISlider!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindData()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func buttonSettingsPressed(_ sender: Any) {
        let settingsView = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.present(settingsView, animated: false, completion: nil)
    }
    
    func bindData()
    {
        propertyInfo = PropertyInfo()
        
        propertyInfo.imageBase64.next(encodeImageToBase64(image: image!))
        imageView.image = image
        
        //        sliderValuebidirectionalBind(to: sliderSurfaceLiving.reactive.value)
        //Surface living
        propertyInfo.surfaceLiving.map{ round($0/1)/1}.bind(to: sliderSurfaceLiving)
        sliderSurfaceLiving.reactive.value.map{round($0/1)/1}.bind(to: propertyInfo.surfaceLiving)
        propertyInfo.surfaceLiving.map{ $0.roundedValueToString }.bind(to: labelSurfaceLiving)
        
        // Room number
        propertyInfo.roomNb.map{ round($0/0.5)*0.5}.bind(to: sliderRoomNumber)
        sliderRoomNumber.reactive.value.map{ round($0/0.5)*0.5}.bind(to: propertyInfo.roomNb)
        propertyInfo.roomNb.map{ "\($0)" }.bind(to: labelRoomNumber)
        
        // Build year
        propertyInfo.buildYear.map{ "\($0)" }.bind(to: labelYear)
        
    }

    
    @IBAction func buttonShowYearPickerPressed(_ sender: Any) {
        
        let myYearPickerView = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController

        myYearPickerView.modalTransitionStyle = .coverVertical
        myYearPickerView.modalPresentationStyle = .overCurrentContext
        
        let completionHandler : ()->Void = {
            if let selectedYear = myYearPickerView.selectedYear
            {
                self.propertyInfo.buildYear.next(selectedYear)
            }
        }
        
        myYearPickerView.completionHandler = completionHandler
        
        present(myYearPickerView, animated: true, completion: nil)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}

extension Float{
    var roundedValueToString: String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
