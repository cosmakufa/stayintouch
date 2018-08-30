//
//  frequencyViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/14/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class frequencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //---------------------------------view controller variables-----------------------------------------------------------------------------
    
    var person: Person!
    var encounters: [Communication]!
    let frequencies = ["Unknown","Daily", "Weekly", "Bi-Weekly", "Monthly", "Quarterly", "semi-annually", "annually"]
    var imageStore: ImageStore!
    @IBOutlet var picker: UIPickerView!
    
    //---------------------------------general Functions-----------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        picker.selectRow(frequencies.index(of: person.frequency)!, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        person.frequency = frequencies[picker.selectedRow(inComponent: 0)]
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //---------------------------------Picker View  Functions-----------------------------------------------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencies.count
    }
    
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencies[row]
    }
    
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(frequencies[row])
    }

}
