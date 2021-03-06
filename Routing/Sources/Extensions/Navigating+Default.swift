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
    var isSplitViewController: Bool { self is RoutingSplitViewController }
    var isViewController: Bool { self is UIViewController }

    var navigator_window: UIWindow? { self as? UIWindow }
    var navigator_tabBarController: UITabBarController? { self as? UITabBarController }
    var navigator_navigationController: UINavigationController? { self as? UINavigationController }
    var navigator_splitViewController: RoutingSplitViewController? { self as? RoutingSplitViewController }
    var navigator_viewController: UIViewController? { self as? UIViewController }

    var selectedIndex: Int {
        get { -1 }
        set { assertionFailure("That should never get called") }
    }

    var presentedViewController: UIViewController? {
        navigator_window?.navigator?.presentedViewController
    }

    // MARK: - Methods

    func navigator_transition(
        completion: CompletionBlock?
    ) {
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

    func navigator_push(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow {
            navigator_window?.navigator?.navigator_push(
                viewController: viewController,
                animated: animated,
                completion: completion
            )
        } else if isNavigationController {
            navigator_navigationController?.pushViewController(viewController, animated: animated)
            navigator_transition(completion: completion)
        } else {
            assertionFailure()
        }
    }

    func navigator_pushFromTop(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow {
            let topNavigationController = (navigator_window?.navigator?.topViewController as? UINavigationController) ?? navigator_window?.navigator?.topViewController?.navigationController
            topNavigationController?.pushViewController(viewController, animated: animated)
        } else if var target = topViewController {
            while let _target = target.presentedViewController {
                target = _target
            }
            if let navigationController = target as? UINavigationController {
                navigationController.pushViewController(viewController, animated: animated)
            }
        } else {
            navigator_push(viewController: viewController, animated: animated, completion: nil)
        }
    }

    func navigator_pop(
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow { navigator_window?.navigator?.navigator_pop(animated: animated, completion: completion) }
        else if isNavigationController {
            navigator_navigationController?.popViewController(animated: animated)
            navigator_transition(completion: completion)
        } else { assertionFailure() }
    }

    func navigator_popToRoot(
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow { navigator_window?.navigator?.navigator_popToRoot(animated: animated, completion: completion) }
        else if let navigationController = navigator_navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: animated)
            navigator_transition(completion: completion)
        } else {
            completion?()
        }
    }

    // MARK: Present & Dismiss

    func navigator_presentFromTop(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow {
            navigator_window?.navigator?.topViewController?.present(viewController, animated: animated, completion: completion)
        } else if var target = topViewController {
            while let _target = target.presentedViewController {
                target = _target
            }
            target.present(viewController, animated: animated, completion: completion)
        } else {
            navigator_viewController?.present(viewController, animated: animated, completion: completion)
        }
    }

    func navigator_present(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
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

    func navigator_dismiss(
        animated: Bool,
        completion: CompletionBlock?
    ) {
    if isWindow { navigator_window?.navigator?.navigator_dismiss(animated: animated, completion: completion) }
    else if navigator_viewController?.presentedViewController != nil { navigator_viewController?.dismiss(animated: animated, completion: completion) }
    else { completion?() }
}

    func navigation_dismissTop(
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow {
            navigator_window?.navigator?.topViewController?.dismiss(animated: animated, completion: completion)
        } else if var target = topViewController {
            while let _target = target.presentedViewController {
                target = _target
            }
            target.dismiss(animated: animated, completion: completion)
        }
    }

    // MARK: SplitViewController

    func navigator_updateSplitRoot(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow { navigator_window?.navigator?.navigator_updateDetail(viewController: viewController, animated: animated, completion: completion) }
        else {
            guard let me = navigator_splitViewController else {
                completion?()
                return
            }

            #if os(tvOS)
            if #available(tvOS 14.0, *) {
                me.setViewController(viewController, for: .primary)
            } else {
                me.viewControllers = [viewController]
            }
            #else
            if #available(iOS 14.0, *) {
                me.setViewController(viewController, for: .primary)
            } else {
                me.viewControllers = [viewController]
            }
            #endif
        }
    }

    func navigator_updateDetail(
        viewController: UIViewController,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if isWindow { navigator_window?.navigator?.navigator_updateDetail(viewController: viewController, animated: animated, completion: completion) }
        else {
            guard let me = navigator_splitViewController else {
                completion?()
                return
            }

            #if os(tvOS)
            if #available(tvOS 14.0, *) {
                me.setViewController(viewController, for: .secondary)
            } else {
                me.showDetailViewController(viewController, sender: self)
            }
            #else
            if #available(iOS 14.0, *) {
                me.setViewController(viewController, for: .secondary)
            } else {
                me.showDetailViewController(viewController, sender: self)
            }
            #endif
        }
    }

    // MARK: Combinations

    func navigator_popOrDismissToRoot(
        animated: Bool,
        completion: CompletionBlock?
    ) {
    if isWindow { navigator_window?.navigator?.navigator_popOrDismissToRoot(animated: animated, completion: completion) }
    else if isNavigationController {
        navigator_dismiss(animated: animated) { [weak self] in
            self?.navigator_popToRoot(animated: animated, completion: completion)
        }
    } else { assertionFailure() }
}
}
