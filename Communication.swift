//
//  Communication.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/26/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import SwiftyJSON
import FacebookCore

enum typeOfCommunication: Int {
    case text = 0
    case videoCall
    case voice
    case inPerson
}

enum numberOfPeople: Int {
    case group = 0
    case solo
}


class Communication: NSObject, NSCoding {
   
    
    //--------------------------------- Variables-----------------------------------------------------------------------------
    
    var typeofCommunication: typeOfCommunication?
    var numOfPeople: numberOfPeople?
    var start: NSDate = NSDate()
    var end: NSDate = NSDate()
    var title: String!
    var encounterDescription: String!
    var id: String!
    var people: [String]!
    
    
    func toJSON() -> [String: Any]{
        let result: [String: Any] = [
            "typeofCommunication": typeofCommunication?.rawValue,
            "encounterId": id,
            "start": start,
            "end": end,
            "title": title,
            "encounterDescription": encounterDescription,
            "people": JSON(people),
             "userId": AccessToken.current?.userId
        ]
        return result
    }
    
    func fromJSON(data:JSON){
        typeofCommunication = typeOfCommunication.init(rawValue: data["typeofCommunication"].intValue)
        start = DateFormatter().date(from: data["start"].stringValue) as! NSDate
        end = DateFormatter().date(from: data["end"].stringValue) as! NSDate
        title = data["title"].stringValue
        encounterDescription = data["encounterDescription"].stringValue
        id = data["encounterId"].stringValue
        people = data["people"].arrayObject as! [String]
    }
    
    func updateEncounter(){
        let body: [String: Any] = ["userId": AccessToken.current?.userId,
                                   "encounter": toJSON()]
        API.updateEncounter(parameter: body, encounter: id)
    }
    
    func deleteEncounter(){
        let body: [String: Any] = ["userId": AccessToken.current?.userId]
        API.updateEncounter(parameter: body, encounter: id)
    }
    
    //--------------------------------- General Functions-----------------------------------------------------------------------------
    
    
    override init() {
        id = NSUUID.init().uuidString
        people = []
        super.init()
    }
    
    //--------------------------------- Saving and Downloading Functions-----------------------------------------------------------------------------
    func getJson() {
        //result = JSON
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.typeofCommunication =  typeOfCommunication(rawValue: aDecoder.decodeObject(forKey: "typeOfCom") as! Int)
        numOfPeople = numberOfPeople(rawValue: aDecoder.decodeObject(forKey: "numberOfPeople") as! Int)
        //start = aDecoder.decodeObject(forKey: "start") as! NSDate
        //end = aDecoder.decodeObject(forKey: "end") as! NSDate
        title = aDecoder.decodeObject(forKey: "title") as! String
        encounterDescription = aDecoder.decodeObject(forKey: "description") as! String
        id = aDecoder.decodeObject(forKey: "id") as? String
        people = aDecoder.decodeObject(forKey: "people") as? [String]
        super.init()
        
    }
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(typeofCommunication?.rawValue, forKey: "typeOfCom")
         aCoder.encode(numOfPeople?.rawValue, forKey: "numberOfPeople")
         aCoder.encode(start, forKey: "start")
         aCoder.encode(end, forKey: "end")
         aCoder.encode(title, forKey: "title")
         aCoder.encode(encounterDescription, forKey: "description")
         aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.people, forKey: "people")
    }
    
    
}
