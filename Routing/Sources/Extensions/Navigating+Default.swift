//
//  Navigating+Default.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public extension Navigating {

    var isWindow: Bool { self is UIWindow }
    var isTabBarController: Bool { self is UITabBarController }
    var isNavigationController: Bool { self is UINavigationController }
    var isViewController: Bool { self is UIViewController }

    var navigator_window: UIWindow? { self as? UIWindow }
    var navigator_tabBarController: UITabBarController? { self as? UITabBarController }
    var navigator_navigationController: UINavigationController? { self as? UINavigationController }
    var navigator_viewController: UIViewController? { self as? UIViewController }

    var selectedIndex: Int {
        get { -1 }
        set { assertionFailure("That should never get called") }
    }

    var presentedViewController: UIViewController? {
        navigator_window?.navigator?.presentedViewController
    }

    // MARK: - Methods

    func navigator_transition(completion: CompletionBlock?) {

        if isWindow {
            navigator_window?.navigator?.navigator_transition(completion: completion)
        } else {
            guard let completion = completion else { return }

            guard let transitionCoordinator = navigator_viewController?.transitionCoordinator else {
                completion()
                return
            }

            transitionCoordinator.animate(alongsideTransition: nil, completion: { _ in completion() })
        }
    }

    // MARK: Push & Pop

    func navigator_push(viewController: UIViewController, animated: Bool, completion: CompletionBlock?) {
        if isWindow { navigator_window?.navigator?.navigator_push(viewController: viewController, animated: animated, completion: completion) }
        else if isNavigationController {
            navigator_navigationController?.pushViewController(viewController, animated: animated)
            navigator_transition(completion: completion)
        } else { assertionFailure() }
    }

    func navigator_pop(animated: Bool, completion: CompletionBlock?) {
        if isWindow { navigator_window?.navigator?.navigator_pop(animated: animated, completion: completion) }
        else if isNavigationController {
            navigator_navigationController?.popViewController(animated: animated)
            navigator_transition(completion: completion)
        } else { assertionFailure() }
    }

    func navigator_popToRoot(animated: Bool, completion: CompletionBlock?) {
        if isWindow { navigator_window?.navigator?.navigator_popToRoot(animated: animated, completion: completion) }
        else if let navigationController = navigator_navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: animated)
            navigator_transition(completion: completion)
        }
    }

    // MARK: Preent & Dismiss

    func navigator_present(viewController: UIViewController, animated: Bool, completion: CompletionBlock?) {

        if isWindow { navigator_window?.navigator?.navigator_present(viewController: viewController, animated: animated, completion: completion) }
        else {
            guard let me = navigator_viewController,
                viewController != presentedViewController else {
                    completion?()
                    return
            }

            me.present(viewController, animated: animated, completion: completion)
        }
    }

    func navigator_dismiss(animated: Bool, completion: CompletionBlock?) {
        if isWindow { navigator_window?.navigator?.navigator_dismiss(animated: animated, completion: completion) }
        else if navigator_viewController?.presentedViewController != nil { navigator_viewController?.dismiss(animated: animated, completion: completion) }
        else { completion?() }
    }

    // MARK: Combinations

    func navigator_popOrDismissToRoot(animated: Bool, completion: CompletionBlock?) {
        if isWindow { navigator_window?.navigator?.navigator_popOrDismissToRoot(animated: animated, completion: completion) }
        else if isNavigationController {
            navigator_dismiss(animated: animated) { [weak self] in
                self?.navigator_popToRoot(animated: animated, completion: completion)
            }
        } else { assertionFailure() }
    }
}
