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

import Darwin

class WorkOutVideo {
    

    //MARK: Properties

    var listThumbnails = [UIImage]()
    var name: String
    var length: String
//    var path: String
    var image: UIImage?
    var background: UIImage? = UIImage(named: "Vignette")

//    var path = String(conBundle.main.path(forResource: "Teaser1Final", ofType: "mp4")

    init?(name: String, length: String) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        for i in 1...15 {
            
            listThumbnails.append(UIImage(named: String(i))!)
        }
        
        let random = Int(arc4random_uniform(UInt32(listThumbnails.count)))
        
        image = listThumbnails[random]
        
        self.name = name
//        self.path = path
        self.length = length

    }
}

