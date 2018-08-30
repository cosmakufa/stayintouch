//
//  SingleContactView.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/24/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class PersonTabBarController: UITabBarController{
    //--------------------------------- Variables -----------------------------------------------------------------------------
    
    var contactbar: UIBarButtonItem?
    var addEncounterBar: UIBarButtonItem?
    var person: Person!
    var imageStore: ImageStore?
    var encounterStore: [Communication]?
    var personStore: PersonStore!
   
    //---------------------------------General View Controllers Functions-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        addEncounterBar = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addEncounter))
    }
    
    //---------------------------------Tab bar Controllers Functions-----------------------------------------------------------------------------
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if(contactbar == nil){
            contactbar = self.navigationController?.topViewController?.navigationItem.rightBarButtonItem
            print(contactbar.debugDescription)
        }
        if (tabBar.items?.index(of: item) == 1){
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = contactbar
             self.navigationController?.topViewController?.navigationItem.title = ""
             self.navigationController?.navigationBar.barTintColor = UIColor.clear
        }else if (tabBar.items?.index(of: item) == 0){
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addEncounterBar
               self.navigationController?.topViewController?.navigationItem.title = "Encounters"
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }else if (tabBar.items?.index(of: item) == 2){
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addEncounterBar
               self.navigationController?.topViewController?.navigationItem.title = "Frequency"
            self.navigationController?.navigationBar.barTintColor = UIColor.clear
        }
        self.navigationController?.topViewController?.navigationItem.titleView?.contentMode = .center
    }
    
    //---------------------------------Helper Functions-----------------------------------------------------------------------------
    
    @objc func addEncounter(sender: AnyObject){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController =  storyboard.instantiateViewController(withIdentifier: "addEncounter") as! AddEncounterViewController
        viewController.encounters = encounterStore!
        viewController.newEncounter = true
        viewController.com = Communication()
        viewController.com.people = [ person.id]
        viewController.imageStore = imageStore
        viewController.personStore = personStore
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
    
}
