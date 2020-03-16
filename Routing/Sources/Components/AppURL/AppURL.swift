//
//  AppURL.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public struct AppURL: CustomStringConvertible {

    public let identifier: String
    public let parameters: [String: Any]

    public var description: String { return identifier }

    public init(identifier: String, parameters: [String: Any] = [:]) {
        self.identifier = identifier
        self.parameters = parameters
    }

    public init?(
        from url: URL,
        appSceme: String?,
        transformQueryItems: Bool = true,
        resolvingAgainstBaseURL: Bool = false) {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL) else {
            return nil
        }

        guard appSceme != nil, components.scheme == appSceme else {
            if let univesal = AppURL.make(univesalURLComponents: components, transformQueryItems: transformQueryItems, resolvingAgainstBaseURL: resolvingAgainstBaseURL) {
                self = univesal
                return
            } else {
                return nil
            }
        }

        if let deeplink = AppURL.make(deeplinkURLComponents: components, transformQueryItems: transformQueryItems) {
            self = deeplink
        } else { return nil }
    }

    private static func make(
        univesalURLComponents: URLComponents,
        transformQueryItems: Bool,
        resolvingAgainstBaseURL: Bool) -> AppURL? {

        guard !univesalURLComponents.path.isEmpty else { return nil }

        var parameters: [String: Any] = [:]
        if let queryItems = univesalURLComponents.queryItems {
            parameters = queryItems.reduce(parameters) {
                guard let value = $1.value else { return $0 }
                var dictionary = $0
                dictionary[$1.name] = value
                return dictionary
            }
        }

        return AppURL(identifier: univesalURLComponents.path, parameters: parameters)
    }

    private static func make(
        deeplinkURLComponents: URLComponents,
        transformQueryItems: Bool) -> AppURL?{

        guard let host = deeplinkURLComponents.host, !host.isEmpty else { return nil }

        var parameters: [String: Any] = [:]
        if let queryItems = deeplinkURLComponents.queryItems {
            parameters = queryItems.reduce(parameters) {
                guard let value = $1.value else { return $0 }
                var dictionary = $0
                dictionary[$1.name] = value
                return dictionary
            }
        }

        return AppURL(identifier: host, parameters: parameters)
    }
}
