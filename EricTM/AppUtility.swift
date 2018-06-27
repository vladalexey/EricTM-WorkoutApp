//
//  AppUtility.swift
//  EricTM
//
//  Created by Phan Quân on 6/27/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//
//
//import Foundation
//import UIKit
//
//struct AppUtility {
//
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
//        
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orienta = orientation
//        }
//    }
//
//    /// Added method to adjust lock and rotate to the desired orientation
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
//
//        self.lockOrientation(orientation)
//
//        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
//    }
//
//}

