//
//  AddCustomizeWorkoutTableViewCell.swift
//  EricTM
//
//  Created by Phan Quân on 9/6/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit

class AddCustomizeWorkoutTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var Vignette: UIImageView!
    @IBOutlet weak var downloadCheck: UIImageView!
    @IBOutlet weak var smallThumbnail: UIImageView!
    @IBOutlet weak var nameVideoExercise: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.downloadCheck.isHidden = true
        } else {
            self.downloadCheck.isHidden = false
        }
    }
}
