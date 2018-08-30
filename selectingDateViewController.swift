//
//  selectingDateViewController.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/27/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class SelectingDateViewController: UIViewController{
    
    //---------------------------------View Controller Variables-----------------------------------------------------------------------------
    
    @IBOutlet var picker: UIDatePicker!
    var button: UIButton?
    var com: Communication!
    var isStart: Bool!
    
    //---------------------------------General View Controller Functions-----------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(isStart){
            picker.setDate(com.start as Date, animated: true)
        }else{
            picker.setDate(com.end as Date, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(isStart){
            com.start = (picker.date as NSDate)
        }else{
            com.end = (picker.date as NSDate)
        }
    }
    
    
}
