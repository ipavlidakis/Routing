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

    func canHandle(_ url: AppURL) -> Bool
    func navigation(for url: AppURL) -> NavigationType
    func initialViewController() -> UIViewController
}
