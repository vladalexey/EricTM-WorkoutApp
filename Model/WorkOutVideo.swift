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

class WorkOutVideo: Hashable
{
    

    //MARK: Properties

    var listThumbnails = [UIImage]()
    
    var name: String
    var length: String
    var image: UIImage?
    var workoutLabel: String
    var background: UIImage? = UIImage(named: "Vignette")
    
    var isDefault: Bool
    var isDownloaded = [VideoExercise:Bool]()
//    var videoExercise = VideoExercise()
    
    var r:Int = 0;
    var g:Int = 0;
    var b:Int = 0;
    var a:Int = 0;
    
    var hashValue: Int {
        get {
            return "\(r)\(g)\(b)\(a)".hashValue;
        }
    }


    init?(name: String, length: String, workoutLabel: String, isDefault: Bool, isDownloaded: Dictionary<VideoExercise,Bool>) {
        
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
        self.workoutLabel = workoutLabel
        self.length = length
        self.isDefault = isDefault
        self.isDownloaded = isDownloaded
    }
}

func ==(lhs: WorkOutVideo, rhs: WorkOutVideo) -> Bool{
    if lhs.r != rhs.r{
        return false;
    }
    if lhs.g != rhs.g{
        return false;
    }
    if lhs.b != rhs.b{
        return false;
    }
    if lhs.a != rhs.a{
        return false;
    }
    return true;
}

