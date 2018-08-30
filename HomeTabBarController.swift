//
//  HomeTabBarController.swift
//  stayInTouch
//
//  Created by cosma kufa on 11/7/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class HomeTabBarController: UITabBarController{
    //---------------------------------Variables-----------------------------------------------------------------------------
    
    var imageStore: ImageStore?
    var encounterStore: [Communication]?
    var personStore: PersonStore!
    
    //---------------------------------general Functions-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        self.navigationController?.topViewController?.navigationItem.title = "All Encounters"
        let addEncounterBar = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addEncounter))
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addEncounterBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let currentItem = tabBar.selectedItem{
            if(tabBar.items?.index(of: currentItem ) == 1){
                (self.viewControllers![1] as! EncountersViewController).viewWillAppear(true)
            }
        }
    }
    
    //---------------------------------Tab Bar Controllers Functions-----------------------------------------------------------------------------
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if (tabBar.items?.index(of: item) == 0){
            self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = nil
            self.navigationController?.topViewController?.navigationItem.title = "Untitled"
        }else if (tabBar.items?.index(of: item) == 1){
            self.navigationController?.topViewController?.navigationItem.title = "All Encounters"
        }
        let addEncounterBar = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addEncounter))
        self.navigationController?.topViewController?.navigationItem.rightBarButtonItem = addEncounterBar
        self.navigationController?.topViewController?.navigationItem.titleView?.contentMode = .center
    }
    
    //--------------------------------Helper Functions-----------------------------------------------------------------------------
    
    
    @objc func addEncounter(sender: AnyObject){
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController =  storyboard.instantiateViewController(withIdentifier: "addEncounter") as! AddEncounterViewController
        viewController.encounters = encounterStore!
        viewController.newEncounter = true
        viewController.com = Communication()
        viewController.imageStore = imageStore
        viewController.personStore = personStore
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
