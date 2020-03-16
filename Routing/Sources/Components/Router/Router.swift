//
//  Router.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public final class Router: NSObject, Routing {

    public var isActive: Bool { isActiveClosure() }
    public let identifier: String = UUID().uuidString
    public let wireframe: Wireframing?
    public private(set) var navigator: Navigating

    private let isActiveClosure: () -> Bool
    private var routers: [Routing] = []

    var activeRouter: Routing? {
        didSet {
            guard
                let identifier = activeRouter?.identifier,
                identifier != oldValue?.identifier,
                let index = routers.enumerated().compactMap({ $0.element.identifier == identifier ? $0.offset : nil }).first
                else { return }

            activeRouter?.didBecomeActiveAfterInvalidation()

            if navigator.isWindow {
                navigator.navigator_window?.rootViewController = activeRouter?.navigator.navigator_viewController
            } else if navigator.isTabBarController {
                navigator.navigator_tabBarController?.selectedIndex = index
            }
        }
    }
    weak var tabBarVieControllerDelegate: UITabBarControllerDelegate?

    public init(
        navigator: Navigating,
        wireframe: Wireframing?,
        isActiveClosure: @escaping () -> Bool) {

        self.navigator = navigator
        self.wireframe = wireframe
        self.isActiveClosure = isActiveClosure

        super.init()

        if let wireframe = wireframe {
            if navigator.isNavigationController {
                self.navigator.navigator_navigationController?.viewControllers = [wireframe.initialViewController()]
            } else if navigator.isTabBarController {
                self.navigator.navigator_tabBarController?.viewControllers = [wireframe.initialViewController()]
            }
        }

        if let tabBarController = navigator.navigator_tabBarController {
            self.tabBarVieControllerDelegate = tabBarController.delegate
            tabBarController.delegate = self
        }
    }

    public func invalidate() {
        activeRouter = routers.first { $0.isActive }
    }

    public func add(_ router: Routing) {
        routers.append(router)

        if navigator.isWindow { invalidate() }
        else if let tabBarController = navigator.navigator_tabBarController, let root = router.navigator.navigator_viewController {
            tabBarController.viewControllers = (tabBarController.viewControllers ?? []) + [root]
        }
    }

    public func canHandle(_ url: AppURL) -> Bool {

        if wireframe?.canHandle(url) == true { return true }

        guard activeRouter?.canHandle(url) == true else {
            return routers.first { $0.canHandle(url) } != nil
        }

        return true
    }

    public func handle(_ url: AppURL) {
        if activeRouter?.canHandle(url) == true {
            activeRouter?.handle(url)
        } else if let router = routers.first(where: { $0.canHandle(url) }) {
            activeRouter = router
            self.handle(url)
        } else if let wireframe = wireframe, wireframe.canHandle(url) {
            let navigation = wireframe.navigation(for: url)

            switch navigation {
                case .popOrDismissToRoot(let animated):
                    navigator.navigator_popOrDismissToRoot(animated: animated, completion: nil)
                case .popToRoot(let animated):
                    navigator.navigator_popToRoot(animated: animated, completion: nil)
                case .push(let viewController, let animated):
                    navigator.navigator_push(viewController: viewController, animated: animated, completion: nil)
                case .present(let viewController, let animated):
                    navigator.navigator_present(viewController: viewController, animated: animated, completion: nil)
                case .dismissAndPresent(let viewController, let animated):
                    navigator.navigator_dismiss(animated: animated, completion: { [weak self] in
                        self?.navigator.navigator_present(viewController: viewController, animated: animated, completion: nil)
                    })
                case .dismissAndPush(let viewController, let animated):
                    navigator.navigator_dismiss(animated: animated, completion: { [weak self] in
                        self?.navigator.navigator_push(viewController: viewController, animated: animated, completion: nil)
                    })
                case .popAndPresent(let viewController, let animated):
                    navigator.navigator_pop(animated: animated, completion: { [weak self] in
                        self?.navigator.navigator_present(viewController: viewController, animated: animated, completion: nil)
                    })
                case .popAndPush(let viewController, let animated):
                    navigator.navigator_pop(animated: animated, completion: { [weak self] in
                        self?.navigator.navigator_push(viewController: viewController, animated: animated, completion: nil)
                    })
            }
        }
    }

    public func router(for rootViewController: UIViewController) -> Routing? {
        routers.first { $0.navigator.navigator_viewController == rootViewController }
    }

    public func didBecomeActiveAfterInvalidation() {
        if navigator.isNavigationController {
            navigator.navigator_navigationController?.navigator_dismiss(animated: false, completion: { [weak self] in
                self?.navigator.navigator_navigationController?.navigator_popToRoot(animated: false, completion: nil)
            })
        } else if navigator.isTabBarController {
            activeRouter = routers.first
        }
    }
}
