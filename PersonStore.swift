//
//  personStore.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/21/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import SwiftyJSON
import FacebookCore
class PersonStore: NSObject {
    //--------------------------------- variables -----------------------------------------------------------------------------
    
    var people = [String: Person]()
    var encounters = [Communication]()
    
    //--------------------------------- General Functions-----------------------------------------------------------------------------
    
    override init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: encountersArchiveURL.path!) as? [Communication]{
            encounters = archivedItems
        }
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: peopleArchiveURL.path!) as? [String:Person]{
            people.merge(archivedItems, uniquingKeysWith: {
                (a, b) -> Person in
                return b
            })
        }
    }
    
    //--------------------------------- Saving and Downloading Functions-----------------------------------------------------------------------------
    
    let peopleArchiveURL: NSURL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("people.archive") as NSURL
    }()
    
    let encountersArchiveURL: NSURL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("encounters.archive") as NSURL
    }()
    
    func saveChanges() -> Void {
         NSKeyedArchiver.archiveRootObject(encounters, toFile: encountersArchiveURL.path!)
         NSKeyedArchiver.archiveRootObject(people, toFile: peopleArchiveURL.path!)
    }
    
    func peopleToJSON () -> [[String:Any] ]{
        var result: [[String: Any]] = []
        for (id, person) in people {
            result.append(person.toJSON())
        }
        return result
    }
    
    func encountersToJSON () -> [[String: Any]]{
        let result = encounters.map { encounter in encounter.toJSON()}
        return result
    }
    
    func updateAllEncounters(){
        let encounters = encountersToJSON()
        let body: [String: Any] = ["userId": AccessToken.current?.userId,
                          "encounters": encounters]
        API.updateAllEncounters(encounters: body)
    }
    
    func updateAllPeople(){
        let people = peopleToJSON()
        let body: [String: Any] = ["userId": AccessToken.current?.userId,
                          "people": people]
    
        API.updateAllPeople(people: body)
    }
    
    func updateAllInfo(){
        updateAllEncounters()
        updateAllPeople()
    }
    
    
    /**
     func saveOnline() -> Void {
     do{
     let encodedPeople = NSKeyedArchiver.archivedData(withRootObject: people)
     let encodedEncounters = NSKeyedArchiver.archivedData(withRootObject: encounters)
     
     //   let peopleJSON  =  try  JSONSerialization.data(withJSONObject: people, options: .prettyPrinted)
     // let encountersJSON = try JSONSerialization.data(withJSONObject: encounters, options: .prettyPrinted)
     
     let peopleString = encodedPeople.base64EncodedString()
     let encountersString = encodedEncounters.base64EncodedString()
     let parameters = ["people": peopleString, "encounters": encountersString]
     dyanmoAPI.putData(parameters: parameters)
     }
     }
     func decodeOnlineData(data: Data ) -> Void {
     do{
     let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
     let innerObject = (jsonObject["stayInTouch"] as! [Any])[0] as! [String: String]
     let encodedPeople = innerObject["people"] as! String
     let encodedEncounters = innerObject["encounters"] as! String
     let peopleData = Data.init(base64Encoded: encodedPeople)
     let encountersData = Data.init(base64Encoded: encodedEncounters)
     if let archivedPeople = NSKeyedUnarchiver.unarchiveObject(with: peopleData!) as? [String: Person]{
     self.people = archivedPeople
     }
     if let archivedEncounters = NSKeyedUnarchiver.unarchiveObject(with: encountersData!) as? [Communication]{
     self.encounters = archivedEncounters
     print(archivedEncounters)
     }
     }catch{
     print("failed online retrieval")
     }
     }
     */
}
