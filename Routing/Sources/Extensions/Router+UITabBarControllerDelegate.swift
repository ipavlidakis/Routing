//
//  Router+UITabBarControllerDelegate.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

extension Router: UITabBarControllerDelegate {

    public func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController) -> Bool {
        tabBarVieControllerDelegate?.tabBarController?(tabBarController, shouldSelect: viewController)
            ?? router(for: viewController)?.isActive ?? false
    }

    public func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController) {
        guard let newActiveRouter = router(for: viewController) else {
            assertionFailure()
            return
        }
        activeRouter = newActiveRouter
        tabBarVieControllerDelegate?.tabBarController?(tabBarController, didSelect: viewController)
    }

    #if !os(tvOS)
    public func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        tabBarVieControllerDelegate?.tabBarControllerSupportedInterfaceOrientations?(tabBarController) ?? .portrait
    }

    public func tabBarControllerPreferredInterfaceOrientationForPresentation(_ tabBarController: UITabBarController) -> UIInterfaceOrientation {
        tabBarVieControllerDelegate?.tabBarControllerPreferredInterfaceOrientationForPresentation?(tabBarController) ?? .portrait
    }
    #endif
}
