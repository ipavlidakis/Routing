//
//  UITabBarController+Navigating.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController: Navigating {

    public var topViewController: UIViewController? {
        presentedViewController ?? selectedViewController
    }
}
