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
    @IBOutlet weak var downloadVideoButton: LoadingButton!
    @IBOutlet weak var videoDuration: UILabel!
    @IBOutlet weak var progressVideoDownload: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.downloadVideoButton.contentEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.downloadVideoButton.isHidden = true
        } else {
            self.downloadVideoButton.isHidden = false
        }
    }
}
