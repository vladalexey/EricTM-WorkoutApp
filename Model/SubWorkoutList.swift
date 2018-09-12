//
//  SubWorkoutList.swift
//  EricTM
//
//  Created by Phan Quân on 9/3/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class SubWorkoutList: NSObject, NSCoding {
    
    var name = [String]()
    var contain = [VideoExercise]()
    
    init(name: Array<String>, contain: Array<VideoExercise>) {
        self.name = name
        self.contain = contain
    }
    
    var r:Int = 0;
    var g:Int = 0;
    var b:Int = 0;
    var a:Int = 0;
    
    override var hashValue: Int {
        get {
            return "\(r)\(g)\(b)\(a)".hashValue;
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let userDefaults = UserDefaults.standard
        
//        if userDefaults.object(forKey: "nameSubworkout") != nil {
            let name = aDecoder.decodeObject(forKey: "nameSubworkout") as! [String]
//        }
        
//        if userDefaults.object(forKey: "contain") != nil {
            let contain = aDecoder.decodeObject(forKey: "contain") as! [VideoExercise]
//        }
        
        self.init(name: name, contain: contain)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "nameSubworkout")
        aCoder.encode(self.contain, forKey: "contain")
    }
}

func ==(lhs: SubWorkoutList, rhs: SubWorkoutList) -> Bool{
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
