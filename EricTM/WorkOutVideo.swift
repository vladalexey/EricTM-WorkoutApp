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
    var path: URL

    init?(name: String, path: URL) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || !(path.isFileURL)  {
            return nil
        }
        
        self.name = name
        self.path = path
    }
}

