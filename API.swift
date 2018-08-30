//
//  API.swift
//  stayInTouch
//
//  Created by cosma kufa on 11/13/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import Alamofire

struct API {
    
    //--------------------------------- Variables -----------------------------------------------------------------------------
    
    private static let baseURL = "https://yz3asxvqal.execute-api.us-west-2.amazonaws.com/test/stayintouch/cosmaKufa"
    private static let apiValue = "G1EUuZzzE57la0gncOJU02GaW4arLE907nWJkZYD"
    private static let apiKey = "x-api-key"
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession.init(configuration: config)
    }()
    
    class NetManager {
        
        static var manager : SessionManager = {
            
            // Create the server trust policies
           let serverTrustPolicies: [String: ServerTrustPolicy] = ["stintch.com": .disableEvaluation]
            
            // Create custom manager
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            
            let manager = Alamofire.SessionManager(
                configuration: URLSessionConfiguration.default,
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )
            
            return manager
        }()
        
    }
    //--------------------------------- API Functions-----------------------------------------------------------------------------
    
    static func registerAccount(parameter: [String: Any]){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/user"
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func deleteAccount(parameter: [String : Any], encounter : String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/encounters/" + encounter
            NetManager.manager.request(baseURL, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func getPeople(parameter: [String : Any]){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/getPeople"
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func getPerson(parameter: [String : Any], person: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/getperson/" + person
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
  
    
    static func updatePerson(parameter: [String : Any], person: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/person/" + person
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func deletePerson(parameter: [String : Any], person: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/person/" + person
            NetManager.manager.request(baseURL, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    
    static func getEncounters(parameter: [String : Any]){
        
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/encounters"
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func getEncounter(parameter: [String : Any], encounter: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/getEncounter/" + encounter
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
        
    }
    
    static func addEncounter(parameter: [String : Any]){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/addEncounters"
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    static func updateEncounter(parameter: [String : Any], encounter: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/encounters/" + encounter
            NetManager.manager.request(baseURL, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
  
    
    static func deleteEncounter(parameter: [String : Any], encounter: String){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/encounters/" + encounter
            NetManager.manager.request(baseURL, method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    
    static func updateAllPeople(people: [String: Any]){
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/updatePeople"
            NetManager.manager.request(baseURL, method: .post, parameters: people, encoding: JSONEncoding.default, headers: headers).responseJSON{
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
    }
    

    static func updateAllEncounters(encounters: [String: Any]){
        let headers: HTTPHeaders = [apiKey: apiValue, "Content-Type": "application/json"]
        do{
            let baseURL = "https://www.stintch.com/addEncounters"
            NetManager.manager.request(baseURL, method: .post, parameters: encounters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
        
    }
    
    //add all encounters online
    static func addAllEncounters(parameters: [String: Any]){
        let headers: HTTPHeaders = [apiKey: apiValue, "Content-Type": "application/json"]
        do{
            let baseURL = "https://stintch.com/addEncounters"
            NetManager.manager.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                (response) in
                if let json = response.result.value{
                    print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
    }
    //get_user info
    //update people
    
    /**
    static func getData(personStore: PersonStore){
        let headers: HTTPHeaders = [apiKey: apiValue, "Content-Type": "application/json"]
        
        Alamofire.request(baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { (response) in
            if let json = response.data{
               // print("JSON: \(json)")
      
                personStore.decodeOnlineData(data: json)
            }else if let error  = response.error {
                print("error: \(error)")
            }
        }
    }
    
    static func putData(parameters: [String: Any]){
        let headers: HTTPHeaders = [apiKey: apiValue, "Content-Type": "application/json"]
        do{
            Alamofire.request(baseURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
                (response) in
                if let json = response.result.value{
                     print("JSON: \(json)")
                }else if let error = response.error{
                    print("error \(error)")
                }
            }
        }
    }
 */
}





