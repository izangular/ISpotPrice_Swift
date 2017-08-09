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

    
    func callServiceRegister(user: User, completion: @escaping (_ status: Int, _ statusMessage: String) -> ())
    {
        var statStatusCode = -1
        var statStatusMessage = "Error: Unknown"
        
        let url = URL(string: intUrl + "/apps/v1/register")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["firstName": user.firstName.value!,
                                  "lastName": user.lastName.value!,
                                  "email": user.email.value!,
                                  "phone": user.phone.value!,
                                  "deviceId": user.deviceId]
        
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
                    statStatusCode = 0
                    statStatusMessage = "Success"
                case .failure( _):
                    statStatusCode = 0
                    statStatusMessage = "Registration Error"
                }
                completion(statStatusCode, statStatusMessage)
        }
    }
    
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
    
    func callImageService(propertyData: PropertyData, completion: @escaping (_ status: Int) -> ()){
        var statStatus: Int = -1
        
        let url = URL(string: intUrl + appSubImageProcessingUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["imageBase64": "base ",
                                  "latitude": propertyData.vLatitude,
                                  "longitude": propertyData.vLongitude]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
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
                                    propertyData.zip.next(jZip)
                                }
                                if let jTown = dictionary["town"] as? String{
                                    propertyData.town.next(jTown)
                                }
                                if let jStreet = dictionary["street"] as? String{
                                    propertyData.street.next(jStreet)
                                }
                                if let jCountry = dictionary["country"] as? String{
                                    propertyData.country.next(jCountry)
                                }
                                if let jCategory = dictionary["category"] as? String{
                                    propertyData.category.next(jCategory)
                                }
                                if let jAppraisalValue = dictionary["appraisalValue"] as? Float{
                                    propertyData.appraisalValue.next(jAppraisalValue)
                                }
                                if let jRating = dictionary["rating"] as? Float{
                                    propertyData.rating.next(jRating)
                                }
                                if let jCatCode = dictionary["catCode"] as? Int{
                                    propertyData.catCode.next(jCatCode)
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
                
                completion(statStatus)
        }
    }
    
    func callAppraiseService(propertyData: PropertyData, completion: @escaping (_ status: Int) -> ()){
        
        var statStatus: Int = -1
        
        let url = URL(string: intUrl + appSubAppraisePropertyUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["surfaceLiving": Int(propertyData.vSurfaceLiving),
                                  "landSurface": Int(propertyData.vLandSurface),
                                  "roomNb": propertyData.vRoomNb,
                                  "bathNb": Int(propertyData.vBathNb),
                                  "buildYear": Int(propertyData.vBuildYear),
                                  "microRating": propertyData.vRating,
                                  "catCode": Int(propertyData.vCatCode),
                                  "zip": Int(propertyData.vZip),
                                  "town": propertyData.vTown,
                                  "street": propertyData.vStreet,
                                  "country": propertyData.vCountry]
//        debugPrint(params)
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
//                print (response.request!)
                //                print(response.response!)
                //                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
                        print (jsonData)
                        do {
                            
                            if let dictionary = jsonData as? [String: AnyObject]{
                                
                                if let jZip = dictionary["zip"] as? String{
                                    propertyData.zip.next(jZip)
                                }
                                if let jTown = dictionary["town"] as? String{
                                    propertyData.town.next(jTown)
                                }
                                if let jStreet = dictionary["street"] as? String{
                                    propertyData.street.next(jStreet)
                                }
                                if let jCountry = dictionary["country"] as? String{
                                    propertyData.country.next(jCountry)
                                }
                                if let jCategory = dictionary["category"] as? String{
                                    propertyData.category.next(jCategory)
                                }
                                if let jAppraisalValue = dictionary["appraisalValue"] as? Float{
                                    propertyData.appraisalValue.next(jAppraisalValue)
                                }
                                if let jRating = dictionary["rating"] as? Float{
                                    propertyData.rating.next(jRating)
                                }
                                if let jCatCode = dictionary["catCode"] as? Int{
                                    propertyData.catCode.next(jCatCode)
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
                
                completion(statStatus)
        }
    }
}
