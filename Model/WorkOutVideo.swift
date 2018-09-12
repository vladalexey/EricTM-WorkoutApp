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

class WorkOutVideo: NSObject, NSCoding 
{
    

    //MARK: Properties

    var listThumbnails = [UIImage]()
    
    var name: String
    var length: String
    var image: UIImage?
    var workoutLabel: String
    var background: UIImage? = UIImage(named: "Vignette")
    
    var isDefault: Bool
    var containSubworkout = [SubWorkoutList]()
//    var videoExercise = VideoExercise()
    
    var r:Int = 0;
    var g:Int = 0;
    var b:Int = 0;
    var a:Int = 0;
    
    override var hashValue: Int {
        get {
            return "\(r)\(g)\(b)\(a)".hashValue;
        }
    }

    init?(name: String, length: String, workoutLabel: String, isDefault: Bool, containSubworkout: Array<SubWorkoutList>) {
        
        // Inilization should fail if there is no name or if the rating is negative.
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
        self.containSubworkout = containSubworkout
    }
    
//    func setUserDefaults() {
//
//        let userDefaults = UserDefaults.standard
//
//        userDefaults.set(name, forKey: "nameWorkout")
//    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let userDefaults = UserDefaults.standard
        
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let length = aDecoder.decodeObject(forKey: "length") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! UIImage
        let workoutLabel = aDecoder.decodeObject(forKey: "workoutLabel") as! String
        let background = aDecoder.decodeObject(forKey: "background") as! UIImage
        let isDefault = aDecoder.decodeBool(forKey: "isDefault")
        let containSubworkout = aDecoder.decodeObject(forKey: "containSubworkout") as! [SubWorkoutList]
        self.init(name: name, length: length, workoutLabel: workoutLabel, isDefault: isDefault, containSubworkout: containSubworkout)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.length, forKey: "length")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.workoutLabel, forKey: "workoutLabel")
        aCoder.encode(self.background, forKey: "background")
        aCoder.encode(self.isDefault, forKey: "isDefault")
        aCoder.encode(self.containSubworkout, forKey: "containSubworkout")
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

