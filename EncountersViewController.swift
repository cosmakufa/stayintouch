//
//  EncountersViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/30/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class EncountersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    //---------------------------------View Controller Global Variables-------------------------------------------------------
    
    var person: Person!
    var personStore: PersonStore!
    var imageStore: ImageStore!
    var current: [Communication]!
    var allEncounters = false
    
    @IBOutlet var tableView: UITableView!
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale  = Locale.current
        return dateFormatter
    }()

    //---------------------------------General viewController Functions-------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
        self.tableView.reloadData()
        if let index = tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: false)
        }
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //---------------------------------Table View Functions-------------------------------------------------------

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return current.count
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "encounter", for: indexPath) as! EncounterCell
        cell.selectionStyle = .none
        let com = current[indexPath.row]
        formatter.timeStyle = .short
        cell.encounterTitle.text = com.title.uppercased()
        cell.picture.image = imageStore.imageForKey(key: com.id)
        cell.nextMeetingDate.text =  formatter.string(from: com.start as Date).uppercased()
        return cell
    }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController =  storyboard.instantiateViewController(withIdentifier: "addEncounter") as! AddEncounterViewController
        viewController.com = current[indexPath.row]
        viewController.imageStore = imageStore
        viewController.personStore = personStore
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    //---------------------------------Helper Functions-----------------------------------------------------------------------------
    
    func setData(){
        if(allEncounters){
            current = personStore.encounters
            current.sort { (com1, com2) -> Bool in
                return com1.start as Date > com2.start as Date
            }
        }else{
            current = personStore.encounters.filter({ (com) -> Bool in
                return com.people.contains(person.id)
            })
            current.sort { (com1, com2) -> Bool in
                return com1.start as Date > com2.start as Date
            }
        }
    }

 
}
