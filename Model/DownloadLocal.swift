//
//  DownloadLocal.swift
//  EricTM
//
//  Created by Phan Quân on 7/18/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

//import Foundation
//import UIKit
//
//import FirebaseStorage
//
//class DownloadLocal {
//    
//    var videoReference: StorageReference {
//        return Storage.storage().reference()
//    }
//    
//    var path: URL
//    
//    // Download to the local filesystem
//    let downloadTask = videoReference.child(global.videoName1).write(toFile: path) { url, error in
//        if let error = error {
//            
//            print("Uh-oh, an error occurred!")
//        } else {
//            
//            print("sucessfully downloaded video 1")
//        }
//    }
//    
//    func load(path: URL) {
//        
//    }
//    
//    func stop() {
//        
//    }
//}
