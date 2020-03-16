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

    func canHandle(_ url: URL) -> Bool
    func navigation(for url: URL) -> NavigationType
    func initialViewController() -> UIViewController
}
