//
//  person.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/21/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import SwiftyJSON
import FacebookCore
class Person: NSObject,NSCoding {
    
    
    //---------------------------------Variables-----------------------------------------------------------------------------
    let frequencies = ["Unknown","Daily", "Weekly", "Bi-Weekly", "Monthly", "Quarterly", "semi-annually", "annually"]
    var id : String!
    var frequency: String!
    var firstName: String = ""
    var lastName: String = ""
    
    
    func toJSON() -> [String: Any]{
        let result: [String: Any] = [
            "personId": id,
            "frequency": frequencies.index(of: frequency),
            "firstName": firstName,
            "lastName": lastName,
            "userId": AccessToken.current?.userId?.description
        ]
        return result
    }
    
    func fromJSON(data:JSON){
        id = data["personId"].stringValue
        frequency = frequencies[data["frequency"].intValue]
        firstName = data["firstName"].stringValue
        lastName = data["lastName"].stringValue
    }
    
    //---------------------------------Saving and downloading Functions-----------------------------------------------------------------------------
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(frequency, forKey: "freq")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        frequency = aDecoder.decodeObject(forKey: "freq") as! String
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    //--------------------------------- Person Functions-----------------------------------------------------------------------------
    
    func getNextDate(encounters: [Communication]) -> NSDate?{
        let current = Calendar.init(identifier: .gregorian)
        var prev = Date();
        var nextDate: NSDate?
        var filteredEncounters = encounters.filter {
            (com) -> Bool in
            com.people.contains(self.id)
        }.sorted {
            (com1, com2) -> Bool in
            return com1.start as Date > com2.start as Date
        }
        
        if (filteredEncounters.count > 0){
            prev = filteredEncounters[0].start as Date
        }else if(frequency !=  "Unknown" ){
            return prev as NSDate;
        }else if (frequency ==  "Unknown"){
            return nil
        }
        
        var component = DateComponents.init()

        switch self.frequency {
        case frequencies[0]: // unknown
            nextDate = nil
        case frequencies[1]: //daily
            component.day = 1
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[2]: //weekly
            component.day = 7
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[3]: // bi weekly
            component.day = 14
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[4]: //monthly
            component.month = 1
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[5]: //quarterly
            component.month = 3
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[6]: //semi-annually
            component.month = 6
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        case frequencies[7]: // annually
            component.year = 1
            nextDate = current.date(byAdding: component, to: prev)! as NSDate
        default:
            nextDate = nil
        }
        
        return nextDate
    }
    
    
    
}
