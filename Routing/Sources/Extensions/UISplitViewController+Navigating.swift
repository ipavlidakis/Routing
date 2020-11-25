//
//  UISplitViewController+Navigating.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 15/11/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public final class RoutingSplitViewController: UISplitViewController, Navigating {

    private var routerViewControllers: [UIViewController] = []

    public var topViewController: UIViewController? {
        if #available(iOS 14.0, *) {
            return self.viewController(for: .secondary)
        } else {
            return viewControllers.last
        }
    }

    public func addRouter(
        _ viewController: UIViewController
    ) {
        let newRouterViewControllers = routerViewControllers + [viewController]

        routerViewControllers = newRouterViewControllers
    }

    public func router(
        at index: Int
    ) -> UIViewController? {
        guard
            !routerViewControllers.isEmpty,
            index < routerViewControllers.endIndex
        else {
            return nil
        }

        return routerViewControllers[index]
    }
}
