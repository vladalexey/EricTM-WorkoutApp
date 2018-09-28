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
    @IBOutlet weak var minuteWorkout: UILabel!
    @IBOutlet weak var Vignette: UIImageView!
    @IBOutlet weak var workoutDescriptionTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.layoutIfNeeded()
        
        self.Vignette.alpha = 0.6
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            minuteWorkout.isHidden = editing
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.minuteWorkout.isHidden = editing
            }
        }
    }
}
