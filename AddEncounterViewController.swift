//
//  AddEncounterViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/27/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit



class AddEncounterViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    //---------------------------------View Controller Variables-----------------------------------------------------------------------------
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var encounterTitle: UITextField!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var encounterDescription: UITextView!
    @IBOutlet var startDate: UIButton!
    @IBOutlet var endDate: UIButton!
    @IBOutlet var typeOfCom: UISegmentedControl!
    @IBOutlet var collectionOfPeople: UICollectionView!
    
    var com: Communication!
    var encounters: [Communication]!
    var imageStore: ImageStore!
    var personStore: PersonStore!
    var newEncounter = false
    var listOfPeople: [String]!
    var choice = 0
    
    //---------------------------------General View Controller Functions-----------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startDate"{
            let next = segue.destination as! SelectingDateViewController
            next.button = startDate
            next.isStart = true
            next.com = com
        }else if segue.identifier == "endDate"{
            let next = segue.destination as! SelectingDateViewController
            next.button = endDate
            next.isStart = false
            next.com = com
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageSelected))
        tap.numberOfTapsRequired = 2
        let clearBoard = UITapGestureRecognizer.init(target: self, action: #selector(clearKeyBoard))
        let peopleTap = UITapGestureRecognizer.init(target: self, action: #selector(selectPeople))
        peopleTap.numberOfTapsRequired = 2
        collectionOfPeople.addGestureRecognizer(peopleTap)
        view.addGestureRecognizer(clearBoard)
        picture.addGestureRecognizer(tap)
        picture.isUserInteractionEnabled = true
        listOfPeople = com.people
        collectionOfPeople.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let temp = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveCom(sender:)))
        self.navigationItem.rightBarButtonItems = [temp]
        self.navigationController?.topViewController?.navigationItem.title = "Encounter"
        let formatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale  = Locale.current
            return dateFormatter
        }()
        formatter.timeStyle = .short
        endDate.setTitle(formatter.string(from: com.end as Date), for: .normal)
        startDate.setTitle(formatter.string(from: com.start as Date), for: .normal)
        encounterTitle.text = com.title
        encounterDescription.text = com.encounterDescription
        if let index = com.typeofCommunication?.rawValue{
            typeOfCom.selectedSegmentIndex = index
        }
        if let ids = (com.id), let imageFromStore = imageStore.imageForKey(key: ids) {
            self.picture.image = imageFromStore as UIImage
        }else{
            self.picture.image = nil
        }
        listOfPeople = com.people
        collectionOfPeople.reloadData()
    }
    

    
    //---------------------------------Collection View Functions-----------------------------------------------------------------------------
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPeople.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionOfPeople.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as! ThumbnailCell
        var name = ""
       
        let id = listOfPeople[indexPath.row]
        if let givenName = personStore.people[id]?.firstName {
            name += givenName
        }
        if let givenName = personStore.people[id]?.lastName{
            name +=  " " + givenName.prefix(1).uppercased() + "."
        }
        
        cell.name.text = name
        if let image = imageStore.imageForKey(key: id){
            cell.thumbnail.image = image
        }else{
            cell.thumbnail.image = #imageLiteral(resourceName: "person-icon")
        }
        return cell
    }

    func seePeople(){
        
    }
    
    
    //---------------------------------TextView Functions-----------------------------------------------------------------------------
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.frame.origin.y -= 250;
       
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame.origin.y += 250;
    }
 
    
    //---------------------------------Image View Functions-----------------------------------------------------------------------------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picture.image = imageSelected
            imageStore.setImage(image: imageSelected, forKey:(com?.id)!)
            print(imageSelected)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    //---------------------------------Delete Button Functions-----------------------------------------------------------------------------
    
    @IBAction func deleteEncounter(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Encounter", message: "about to delete encounter", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in
            if let index = self.personStore.encounters.index(of: self.com){
                if index != -1{
                    self.personStore.encounters.remove(at:  index)
                    self.com.deleteEncounter()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //---------------------------------Helper Functions-----------------------------------------------------------------------------
    
    @objc func selectPeople(sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedPeopleViewController = storyboard.instantiateViewController(withIdentifier: "selectingPeople") as! SelectingPeopleViewController
        selectedPeopleViewController.imageStore = imageStore
        selectedPeopleViewController.personStore = personStore
        selectedPeopleViewController.listOfPeople = listOfPeople
        selectedPeopleViewController.com = com
        self.navigationController?.pushViewController(selectedPeopleViewController, animated: true)
        print("recognizing tap")
    }
    
    @objc func clearKeyBoard(sender: AnyObject){
        self.encounterTitle.resignFirstResponder()
        self.encounterDescription.resignFirstResponder()
    }
    
    @objc func imageSelected(sender: AnyObject){
        let imagePicker = UIImagePickerController.init()
        imagePicker.delegate = self
        let alertView = UIAlertController.init(title: "Select Photo Source", message: "", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action)  -> Void in
            self.choice = 0;
            })
        let LibraryAction = UIAlertAction.init(title: "Photo Library", style: .default, handler: { (action)  -> Void in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        let CameraAction = UIAlertAction.init(title: "Camera", style: .default, handler: { (action)  -> Void in
           imagePicker.sourceType = .camera
           self.present(imagePicker, animated: true, completion: nil)
        })
        alertView.addAction(CameraAction)
        alertView.addAction(LibraryAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
    @objc func saveCom(sender: AnyObject){
        if(!com.people.isEmpty){
            com.title = encounterTitle.text
            com.encounterDescription = encounterDescription.text
            com.typeofCommunication = typeOfCommunication(rawValue: typeOfCom.selectedSegmentIndex)
            if(newEncounter && !personStore.encounters.contains(com)){
                personStore.encounters.append(com)
                
            }
            self.com.updateEncounter()
            for id in  com.people{
                Notifications.removeReminder(identifier: id)
                if let person = personStore.people[id]{
                    let name: String! = person.firstName + " " + person.lastName
                    let nextDate = person.getNextDate(encounters: encounters)! as Date
                    Notifications.addReminder(name: name, identifier: id, nextDate: nextDate)
                }
            }
        }else{
            let alertController = UIAlertController(title: "No People Selected", message: "choose people if you want to save", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
}



