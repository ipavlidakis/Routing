//
//  AppURL.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation

public struct AppURL {

    public let identifier: String
    public let parameters: [String: Any]

    public init(identifier: String, parameters: [String: Any] = [:]) {
        self.identifier = identifier
        self.parameters = parameters
    }

    public init?(
        from url: URL,
        transformQueryItems: Bool = true,
        resolvingAgainstBaseURL: Bool = false) {

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL) else {
            return nil
        }

        let path = components.path
        var parameters: [String: Any] = [:]
        if let queryItems = components.queryItems {
            parameters = queryItems.reduce(parameters) {
                guard let value = $1.value else { return $0 }
                var dictionary = $0
                dictionary[$1.name] = value
                return dictionary
            }
        }

        self.identifier = path
        self.parameters = transformQueryItems ? parameters : [:]
    }

}
