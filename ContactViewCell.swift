//
//  ContactViewCell.swift
//  stayInTouch
//
//  Created by cosma kufa on 10/14/17.
//  Copyright © 2017 three Pence. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var nextMeetingDate: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var frequency: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
