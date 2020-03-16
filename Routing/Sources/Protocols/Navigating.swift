//
//  Navigating.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public protocol Navigating: AnyObject {

    typealias CompletionBlock = () -> Void

    var isWindow: Bool { get }
    var isTabBarController: Bool { get }
    var isNavigationController: Bool { get }
    var isViewController: Bool { get }

    var navigator_window: UIWindow? { get }
    var navigator_tabBarController: UITabBarController? { get }
    var navigator_navigationController: UINavigationController? { get }
    var navigator_viewController: UIViewController? { get }

    var selectedIndex: Int { get set }

    var presentedViewController: UIViewController? { get }

    func navigator_transition(completion: CompletionBlock?)

    func navigator_push(viewController: UIViewController, animated: Bool, completion: CompletionBlock?)

    func navigator_pop(animated: Bool, completion: CompletionBlock?)

    func navigator_present(viewController: UIViewController, animated: Bool, completion: CompletionBlock?)

    func navigator_dismiss(animated: Bool, completion: CompletionBlock?)

    func navigator_popToRoot(animated: Bool, completion: CompletionBlock?)

    func navigator_popOrDismissToRoot(animated: Bool, completion: CompletionBlock?)
}
