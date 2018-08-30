//
//  notifications.swift
//  stayInTouch
//
//  Created by cosma kufa on 11/15/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import UserNotifications
class Notifications: NSObject, UNUserNotificationCenterDelegate{
    
    //--------------------------------- Variables-----------------------------------------------------------------------------
    static var center = UNUserNotificationCenter.current()
   
    
    //--------------------------------- Notifications Delegate Functions-----------------------------------------------------------------------------
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        
        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            completionHandler()
        default:
            completionHandler()
        }
    }
    
    
    //--------------------------------- helper functions-----------------------------------------------------------------------------
    
    static func setDelegate(){
        center.delegate = Notifications()
    }
    
    static func addReminder(name: String, identifier: String, nextDate: Date){
        let timeTrigger: UNNotificationTrigger!
        if(nextDate.timeIntervalSinceNow < 0){
            var date = DateComponents.init()
            date.second = 5
            timeTrigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
        }else{
              timeTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: nextDate.timeIntervalSinceNow, repeats: false)
        }
        let content = UNMutableNotificationContent.init()
        content.title = "Reach out to \(name)"
        content.body = "It's time for you two to catch up"
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: timeTrigger)
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }else {
            }
        }
    }
    
    static func removeReminder(identifier: String){
         center.removePendingNotificationRequests(withIdentifiers: [identifier])
         center.removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    static func setNextReminder(personStore: PersonStore){
        var delivered: [String]!
        center.getDeliveredNotifications { (result) in
            delivered = result.map({ (note) -> String in
                return note.request.identifier
            })
        }
        let people = personStore.people
        for (key,value) in people{
            if let nextDate = value.getNextDate(encounters: personStore.encounters){
                if(!delivered.contains(key)){
                    removeReminder(identifier: key)
                    var name = ""
                    name += value.firstName
                    if(!name.isEmpty){
                        name += " "
                    }
                    name += value.lastName
                    if !name.isEmpty{
                        addReminder(name: name, identifier: key, nextDate: nextDate as Date)
                    }
                }
            }
        }
    }
    
    
}
