//
//  NSObject+AssociatedObjects.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 21/11/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import ObjectiveC

extension NSObject {

    func setAssociatedObject<T>(
        _ objectHandle: UInt,
        _ newValue: T?,
        associationPolicy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        var objectHandle = objectHandle
        objc_setAssociatedObject(self, &objectHandle, newValue, associationPolicy)
    }

    func removeAssociatedObject(
        _ objectHandle: UInt) {

        var objectHandle = objectHandle
        objc_setAssociatedObject(self, &objectHandle, nil, .OBJC_ASSOCIATION_ASSIGN)
    }

    func associatedObject<T>(_ objectHandle: UInt) -> T? {
        var objectHandle = objectHandle
        return objc_getAssociatedObject(self, &objectHandle) as? T
    }
}
