//
//  Toolbar.swift
//  EricTM
//
//  Created by Phan Quân on 9/19/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class Toolbar: UIToolbar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = self.bounds
        frame.size.height = 45
        self.frame = frame
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 45
        return size
    }
}

