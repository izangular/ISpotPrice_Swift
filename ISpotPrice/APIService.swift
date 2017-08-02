//
//  API.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 01/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//


import Alamofire


class APIService {
    
    let authUser: String = "appservice@iazi.ch"
    let authPassword: String = "LetsT3st"
    let intUrl: String = "https://intservices.iazi.ch/api"
    let authSubUrl: String = "/auth/v2/login"
    let appSubImageProcessingUrl: String = "/apps/ImageProcessing"
    let appSubAppraisePropertyUrl: String = "/apps/AppraiseProperty"
    
    func callServiceAuth(completion: @escaping (_ status: Int, _ statusMessage: String, _ token: String) -> ())
    {
        var statStatusCode = -1
        var statStatusMessage = "Error: Unknown"
        var statToken = ""
        
        let url = URL(string: intUrl + authSubUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["userEmail": authUser, "userPwd": authPassword, "app": "appService,address,macro,micro,modelr", "culture": "en"]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                
//                print (response.request!)
//                print(response.response!)
//                print(response.result)
                
                switch response.result{
                    case .success:
                        if let jsonData = response.result.value{
//                            print (jsonData)
                            do {
                                
                                if let dictionary = jsonData as? [String: AnyObject]{
//                                    print(dictionary)
                                    if let tokenType = dictionary["token_type"] as? String{
                                        statStatusCode = 0
                                        statStatusMessage = "Success"
                                        statToken = "\(tokenType)"
                                    }
                                    if let token = dictionary["token"] as? String{
                                        statStatusCode = 0
                                        statStatusMessage = "Success"
                                        statToken = "\(statToken) \(token)"
                                    }
                                }
                            } catch {
                                statStatusCode = 0
                                statStatusMessage = "Error JSON"
                            }
                    }
                    case .failure( _):
                        
                        statStatusCode = 0
                        statStatusMessage = "Auth Error"
                }
                completion(statStatusCode, statStatusMessage, statToken)
            }
    }
    
    func callImageService(base64Image: String, latitude: Double, longitude: Double, authToken: String,
                          completion: @escaping (_ status: Int, _ zip: String, _ town: String, _ street: String, _ country: String, _ category: String
                                                , _ appraisalValue: Double, _ rating: Double, _ catCode: Int) -> ()){
        var statStatus: Int = -1
        var statZip: String = ""
        var statTown: String = ""
        var statStreet: String = ""
        var statCountry: String = ""
        var statCategory: String = ""
        var statAppraisalValue: Double = 0
        var statRating: Double = 0
        var statCatCode: Int = 0
        
        let url = URL(string: intUrl + appSubImageProcessingUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["imageBase64": " base", "latitude": latitude, "longitude": longitude]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                print (response.request!)
//                print(response.response!)
//                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
                        print (jsonData)
                        do {
                            
                            if let dictionary = jsonData as? [String: AnyObject]{
                                
                                if let jZip = dictionary["zip"] as? String{
                                    statZip = jZip
                                }
                                if let jTown = dictionary["town"] as? String{
                                    statTown = jTown
                                }
                                if let jStreet = dictionary["street"] as? String{
                                    statStreet = jStreet
                                }
                                if let jCountry = dictionary["country"] as? String{
                                    statCountry = jCountry
                                }
                                if let jCategory = dictionary["category"] as? String{
                                    statCategory = jCategory
                                }
                                if let jAppraisalValue = dictionary["appraisalValue"] as? Double{
                                    statAppraisalValue = jAppraisalValue
                                }
                                if let jRating = dictionary["rating"] as? Double{
                                    statRating = jRating
                                }
                                if let jCatCode = dictionary["catCode"] as? Int{
                                    statCatCode = jCatCode
                                }
                            }
                        } catch {
                        }
                    }
                case .failure( _):
                    debugPrint(response)
                    
                    statStatus = -1
                    print("error")
                }
                
                completion(statStatus, statZip, statTown, statStreet, statCountry, statCategory, statAppraisalValue, statRating, statCatCode)
        }
    }
    
    func callAppraiseService(surfaceLiving: Double, landSurface: Double, roomNb: Double, bathNb: Double, buildYear: Int, microRating: Double, catCode: Int, zip: String, town: String, street: String, country: String, authToken: String,
                          completion: @escaping (_ status: Int, _ zip: String, _ town: String, _ street: String, _ country: String, _ category: String
        , _ appraisalValue: Double, _ rating: Double, _ catCode: Int) -> ()){
        var statStatus: Int = -1
        var statZip: String = ""
        var statTown: String = ""
        var statStreet: String = ""
        var statCountry: String = ""
        var statCategory: String = ""
        var statAppraisalValue: Double = 0
        var statRating: Double = 0
        var statCatCode: Int = 0
        
        let url = URL(string: intUrl + appSubAppraisePropertyUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["surfaceLiving": surfaceLiving, "landSurface": landSurface, "roomNb": roomNb, "bathNb": bathNb, "buildYear": buildYear, "microRating": microRating, "catCode": catCode, "zip": zip, "town": town, "street": street, "country": country]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                print (response.request!)
                //                print(response.response!)
                //                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
                        print (jsonData)
                        do {
                            
                            if let dictionary = jsonData as? [String: AnyObject]{
                                
                                if let jZip = dictionary["zip"] as? String{
                                    statZip = jZip
                                }
                                if let jTown = dictionary["town"] as? String{
                                    statTown = jTown
                                }
                                if let jStreet = dictionary["street"] as? String{
                                    statStreet = jStreet
                                }
                                if let jCountry = dictionary["country"] as? String{
                                    statCountry = jCountry
                                }
                                if let jCategory = dictionary["category"] as? String{
                                    statCategory = jCategory
                                }
                                if let jAppraisalValue = dictionary["appraisalValue"] as? Double{
                                    statAppraisalValue = jAppraisalValue
                                }
                                if let jRating = dictionary["rating"] as? Double{
                                    statRating = jRating
                                }
                                if let jCatCode = dictionary["catCode"] as? Int{
                                    statCatCode = jCatCode
                                }
                            }
                        } catch {
                        }
                    }
                case .failure( _):
                    debugPrint(response)
                    
                    statStatus = -1
                    print("error")
                }
                
                completion(statStatus, statZip, statTown, statStreet, statCountry, statCategory, statAppraisalValue, statRating, statCatCode)
        }
    }
}
