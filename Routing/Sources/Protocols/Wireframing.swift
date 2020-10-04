//
//  Wireframe.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public protocol Wireframing {

    func canHandle(
        _ url: AppURL
    ) -> Bool

    func navigation(
        for url: AppURL
    ) -> NavigationType

    func initialViewController() -> UIViewController

    func canProvideViewController(
        for url: AppURL
    ) -> Bool

    func viewController(
        for url: AppURL,
        router: Routing
    ) -> UIViewController?
}

public extension Wireframing {

    func canProvideViewController(
        for url: AppURL
    ) -> Bool {
        return false
    }

    func viewController(
        for url: AppURL,
        router: Routing
    ) -> UIViewController? {
        return nil
    }
}
