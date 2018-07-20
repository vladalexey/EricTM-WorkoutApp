//
//  DownloadWorkoutVideo.swift
//  EricTM
//
//  Created by Phan Quân on 7/18/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class DownloadedWorkoutVideo {
    
    
    //MARK: Properties
    
    var name: String
    var path: URL
    
    
    //    var path = String(conBundle.main.path(forResource: "Teaser1Final", ofType: "mp4")
    
    init?(name: String, path: URL) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        //        self.path = path
        self.path = path
        
    }
}
