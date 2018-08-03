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

class IgnoreTouchView : UIImageView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            return nil
        }
        return hitView
    }
}
