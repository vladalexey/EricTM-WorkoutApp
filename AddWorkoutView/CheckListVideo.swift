//
//  CheckListVideo.swift
//  EricTM
//
//  Created by Phan Quân on 9/10/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

struct Model {
    var title: String
}

import Foundation
import UIKit

class CheckListVideos {
    private var item: Model
    
    var isSelected = false
    var title: String {
        return item.title
    }
    
    init(item: Model) {
        self.item = item
    }
}
