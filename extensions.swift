//
//  extensions.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/25/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func setRounded(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}
