//
//  Routing.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public protocol Routing {

    var wireframe: Wireframing? { get }
    var identifier: String { get }
    var isActive: Bool { get }
    var navigator: Navigating { get }

    func invalidate()
    func add(_ router: Routing) 
    func canHandle(_ url: AppURL) -> Bool
    func handle(_ url: AppURL)
    func router(for rootViewController: UIViewController) -> Routing?
    func didBecomeActiveAfterInvalidation()
}