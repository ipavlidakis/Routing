//
//  NavigationType.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public enum NavigationType {
    case none
    case push(UIViewController, Bool)
    case present(UIViewController, Bool)
    case presentFromTop(UIViewController, Bool)
    case popToRoot(Bool)
    case popOrDismissToRoot(Bool)
    case dismiss(Bool)
    case dismissTop(Bool)
    case dismissAndPresent(UIViewController, Bool)
    case dismissAndPush(UIViewController, Bool)
    case popAndPresent(UIViewController, Bool)
    case popAndPush(UIViewController, Bool)
    case pushFromTop(UIViewController, Bool)
    #if targetEnvironment(macCatalyst)
    case newWindow(String, [AnyHashable: Any])
    #endif
}
