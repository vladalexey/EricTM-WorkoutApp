//
//  WorkOutTableViewCell.swift
//  EricTM
//
//  Created by Phan Quân on 6/22/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

class WorkOutTableViewCell: UITableViewCell {
    
    //MARK: Properties
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var minuteWorkout: UITextView!
    @IBOutlet weak var Vignette: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
