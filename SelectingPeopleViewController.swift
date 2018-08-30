//
//  SelectingPeopleViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 11/8/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit


class SelectingPeopleViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //---------------------------------View Controller Variables-----------------------------------------------------------------------------
    
    var imageStore: ImageStore!
    var personStore: PersonStore!
    var com: Communication!
    var listOfPeople: [String]!
    var currentPeople: [String]!
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet var tableView: UITableView!
   
    
    //---------------------------------General View Controller Functions-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        currentPeople = listOfPeople
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPeople = listOfPeople
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        com.people = listOfPeople
    }
    
    
    //---------------------------------SearchBar  Functions-----------------------------------------------------------------------------
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchbar.resignFirstResponder()
        searchBar.showsCancelButton = false
        currentPeople = listOfPeople
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        currentPeople = listOfPeople
        searchbar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            currentPeople = listOfPeople
        }else{
            currentPeople = Array(personStore.people.map{$0.key})
            currentPeople = currentPeople.filter({ (id) -> Bool in
                let searchlow = searchText.lowercased()
                if let firstname = personStore.people[id]?.firstName,
                    firstname.lowercased().contains(searchlow){
                    return true
                }
                if let lastname = personStore.people[id]?.lastName,
                    lastname.lowercased().contains(searchlow){
                    return true
                }
                return false
            })
        }
        
        tableView.reloadData()
        if(!currentPeople.isEmpty){
            tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .middle, animated: false)
        }
    }
    
    //---------------------------------Table View Controllers Functions-----------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personInEncounter", for: indexPath) as! SelectingPeopleCell
        cell.selectionStyle = .none
        let person = personStore.people[currentPeople[indexPath.row]]
        var name = ""
        if let givenName = person?.firstName {
            name += givenName
            if let givenName = person?.lastName{
                name +=  " " + givenName
            }
        }
        cell.name.text = name
        cell.personID = person?.id
         let id = person?.id
        if listOfPeople.contains(id!){
            cell.backgroundColor = UIColor.clear
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = currentPeople[indexPath.row]
        let cell =  tableView.cellForRow(at: indexPath) as! SelectingPeopleCell
        if listOfPeople.contains(id){
            if(!searchbar.showsCancelButton){
                currentPeople.remove(at: currentPeople.index(of: id)!)
            }
            listOfPeople.remove(at: listOfPeople.index(of: id)!)
            cell.backgroundColor = UIColor.red
        }else{
            listOfPeople.append(id)
            cell.backgroundColor = UIColor.green
        }
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadData()
    }
 
}

