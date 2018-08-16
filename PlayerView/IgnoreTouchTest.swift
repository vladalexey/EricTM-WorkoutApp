//
//  IgnoreTouchTest.swift
//  EricTM
//
//  Created by Phan Quân on 8/2/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class IgnoreTouchView : UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

//        for gesture: UIGestureRecognizer in self.gestureRecognizers! {
//
//            if gesture.numberOfTouches == 2 && gesture.state == .ended {
//               return false
//            }
//        }
//        return true
    
        for view: UIView in self.subviews {

            let point: CGPoint = view.convert(point, from: self)
            if view.point(inside: point, with: event) {
                return true
            }
        }
        
        
        return false
    }
}
