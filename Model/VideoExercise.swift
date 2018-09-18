//
//  VideoExercise.swift
//  EricTM
//
//  Created by Phan Quân on 8/30/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class VideoExercise: NSObject, NSCoding {
    
    var localURL: URL?
    var serverURL: URL?
    var name: String
//    var containIn = Dictionary<String,Bool>()
    
    init(name: String) {
        self.name = name
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
        
        let name = aDecoder.decodeObject(forKey: "nameVideoExercise") as! String
        self.init(name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "nameVideoExercise")
    }
    
    func setLocalURL(localURL: URL) {
        self.localURL = localURL
    }
}

func ==(lhs: VideoExercise, rhs: VideoExercise) -> Bool{
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

