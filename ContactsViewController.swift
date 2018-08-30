//
//  ContactsViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/14/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
class ContactsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //---------------------------------View Controller Global Variables-------------------------------------------------------
    
    var contactStoreMod: ContactStoreMod!
    var personStore: PersonStore!
    var imageStore: ImageStore!
    var currentContacts: [CNContact]!
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    //---------------------------------General viewController Functions-------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        contactStoreMod.getPermission()
        contactStoreMod.fetchContacts(store: personStore, imageStore: imageStore)
        currentContacts = contactStoreMod.contacts
        sortContacts()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        setNavBar()
        sortContacts()
    }
    
   
     //---------------------------------Search Bar Functions-------------------------------------------------------
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currentContacts = contactStoreMod.contacts
        sortContacts()
        searchbar.resignFirstResponder()
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
         searchbar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            currentContacts = contactStoreMod.contacts
        }else{
            currentContacts = contactStoreMod.contacts.filter{ $0.givenName.lowercased().contains(searchText.lowercased()) ||
                $0.familyName.lowercased().contains(searchText.lowercased())}
        }
        sortContacts()
        tableView.reloadData()
        if(!currentContacts.isEmpty){
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .middle, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  //---------------------------------Table View Functions-------------------------------------------------------

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentContacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120.0;//Choose your custom row height
    }
    

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "contacts", for: indexPath) as! ContactViewCell
        cell.selectionStyle = .none
        let person  = currentContacts[indexPath.row]
        let personObject = personStore.people[person.identifier]
        cell.name?.text = currentContacts[indexPath.row].givenName + " " + currentContacts[indexPath.row].familyName
        if(person.imageDataAvailable){
            if let profile = person.thumbnailImageData{
                cell.picture.image = UIImage.init(data: profile)
            }
        }else{
            cell.picture.image = nil
        }
        cell.picture.setRounded()
        cell.frequency.text = personObject?.frequency.uppercased()
        
        if let nextdate = personObject?.getNextDate(encounters: personStore.encounters){
            let formatter: DateFormatter = {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.locale  = Locale.current
                return dateFormatter
            }()
            formatter.timeStyle = .none
            cell.nextMeetingDate.text = formatter.string(from: nextdate as Date)
        }else {
             cell.nextMeetingDate.text = "update Frequency"
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let current = currentContacts[indexPath.row]
            currentContacts.remove(at: indexPath.row)
            let mut = current.mutableCopy() as! CNMutableContact
            personStore.people.removeValue(forKey: current.identifier)
            let req = CNSaveRequest.init()
            req.delete(mut);
            try! contactStoreMod.contactStore?.execute(req)
            contactStoreMod.fetchContacts(store: personStore, imageStore: imageStore)
            tableView.deleteRows(at: [indexPath], with: .fade)
           //needed because when deleterrow is called show edit is called or nav is reset
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let identifier = currentContacts[indexPath.row].identifier
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let contactController = showContact(selectedIndex: indexPath.row)
        
        let encountersController = storyboard.instantiateViewController(withIdentifier: "PersonalEncounters") as! EncountersViewController
        encountersController.person = personStore.people[identifier]
        encountersController.imageStore = imageStore
        encountersController.personStore = personStore
        
        let freqController = storyboard.instantiateViewController(withIdentifier: "frequencyViewController") as! frequencyViewController
        freqController.person = personStore.people[identifier]
        freqController.imageStore = imageStore
        
        let personTabBarController = PersonTabBarController()
        personTabBarController.contactbar = freqController.navigationItem.rightBarButtonItem
        personTabBarController.person = personStore.people[identifier]
        personTabBarController.imageStore = imageStore
        personTabBarController.encounterStore = personStore.encounters
        personTabBarController.personStore = personStore
        
        personTabBarController.setViewControllers([encountersController, contactController, freqController], animated: true)
        (personTabBarController.tabBar.items![0] as UITabBarItem).title = "ENCOUNTERS"
        (personTabBarController.tabBar.items![1] as UITabBarItem).title = "INFO"
         (personTabBarController.tabBar.items![2] as UITabBarItem).title = "FREQUENCY"
        personTabBarController.selectedIndex = 1
        
        self.navigationController?.pushViewController(personTabBarController, animated: true)
       
    }

    //---------------------------------Helper Functions-----------------------------------------------------------------------------
    func showContact(selectedIndex: Int) -> CNContactViewController {
        let contact = currentContacts[selectedIndex]
        let predicate = CNContact.predicateForContacts(withIdentifiers: [contact.identifier])
        let keysToFetch = [ CNContactViewController.descriptorForRequiredKeys()]
        
        var contacts : [CNContact]? = nil
        do{
            contacts = try contactStoreMod.contactStore?.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        } catch let error{
            print("error while fetching for view: \(error)")
        }
        
        if let firstContact = contacts?.first {
            let viewController = CNContactViewController.init(for: firstContact)
            viewController.contactStore = self.contactStoreMod.contactStore
            viewController.allowsEditing = true
         
            return viewController
        }
        return CNContactViewController.init()
    }
    
    func setNavBar(){
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
        self.navigationItem.title = "UKAMA"
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func showEditing(sender: UIBarButtonItem){
        
        if(self.tableView.isEditing == true){
            self.tableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else{
            self.tableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
    }
    
    func sortContacts(){
        currentContacts.sort { (c1, c2) -> Bool in
            if let d1 = personStore.people[c1.identifier]?.getNextDate(encounters: personStore.encounters){
                if let d2 = personStore.people[c2.identifier]?.getNextDate(encounters: personStore.encounters){
                    return d2 as Date > d1 as Date
                }
                return true
            }
            return false
        }
    }
    
    
    
}
