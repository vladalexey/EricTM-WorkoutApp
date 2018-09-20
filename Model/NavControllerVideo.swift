//
//  NavControllerVideo.swift
//  EricTM
//
//  Created by Phan Quân on 9/19/18.
//  Copyright © 2018 Phan Quân. All rights reserved.
//

import Foundation
import UIKit

class NavigationControllerVideo: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: UINavigationBar.self, toolbarClass: Toolbar.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
