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
    var length: String
//    var path: String
    var image: UIImage? = UIImage(named: "full_body")
    var background: UIImage? = UIImage(named: "Vignette")
    

//    var path = String(conBundle.main.path(forResource: "Teaser1Final", ofType: "mp4")

    init?(name: String, length: String) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        self.name = name
//        self.path = path
        self.length = length

    }
}

