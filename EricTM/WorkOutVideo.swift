//
//  WorkOutVideo.swift
//  EricTM
//
//  Created by Phan Quân on 6/22/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class WorkOutVideo {
    

    //MARK: Properties

    var name: String
    var path: String
    var image: UIImage?
    var background: UIImage?

    init?(name: String, path: String, image: UIImage, background: UIImage) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || path.isEmpty  {
            return nil
        }
        
        self.name = name
        self.path = path
        self.image = image
        self.background = background
    }
}

