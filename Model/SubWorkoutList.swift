//
//  SubWorkoutList.swift
//  EricTM
//
//  Created by Phan Quân on 9/3/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class SubWorkoutList: Hashable {
    
    var name = Array<String>()
    var contain = Array<VideoExercise>()
    
    init(name: Array<String>, contain: Array<VideoExercise>) {
        self.name = name
        self.contain = contain
    }
    
    var r:Int = 0;
    var g:Int = 0;
    var b:Int = 0;
    var a:Int = 0;
    
    var hashValue: Int {
        get {
            return "\(r)\(g)\(b)\(a)".hashValue;
        }
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
