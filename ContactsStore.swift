//
//  ContactsStore.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/23/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI
class ContactStoreMod: NSObject{
    
    //---------------------------------Variables -----------------------------------------------------------------------------
    
    var contactStore: CNContactStore?
    var contacts: [CNContact] = [CNContact]()
    var people = [String: Person]()
  
    
    //--------------------------------- Functions -----------------------------------------------------------------------------
    
    func getPermission(){
        contactStore = CNContactStore()
        contactStore?.requestAccess(for: .contacts, completionHandler: {
            (Bool, error) -> Void in
        })
    }
    
    func fetchContacts(store: PersonStore, imageStore: ImageStore) -> Void {
        if let contactStore = self.contactStore {
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            results.sort(by: {if($0.familyName != $1.familyName){return $0.familyName < $1.familyName}else{
                return $0.givenName < $1.givenName
                }})
            contacts = results
            for each in contacts{
                let newPerson = Person()
                newPerson.id = each.identifier
                newPerson.frequency = "Unknown"
                newPerson.firstName = each.givenName
                newPerson.lastName = each.familyName
                if(store.people[newPerson.id] == nil){
                    store.people[newPerson.id] = newPerson
                }
                store.people[each.identifier]?.firstName = each.givenName
                store.people[each.identifier]?.lastName = each.familyName
                if each.imageDataAvailable{
                    let image = UIImage.init(data: each.thumbnailImageData!)
                    imageStore.setImage(image: image!, forKey: each.identifier)
                }
            }
        }  
    }
  
}
