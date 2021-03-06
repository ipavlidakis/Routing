//
//  AppURL.swift
//  Routing
//
//  Created by Ilias Pavlidakis on 16/03/2020.
//  Copyright © 2020 Ilias Pavlidakis. All rights reserved.
//

import Foundation
import UIKit

public struct AppURL: CustomStringConvertible, Hashable {

    public static func == (lhs: AppURL, rhs: AppURL) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

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

extension AppURL {
    
    public static let templateParameterKey = "appURLErrorTemplateParameter"
    public static let alertIdentifier = "appAlert"
    
    public static func makeAlert(
        title: String? = nil,
        message: String? = nil,
        actions: [ActionTemplate] = []
    ) -> AppURL {
        AppURL(
            identifier: alertIdentifier,
            parameters: [
                AppURL.templateParameterKey: AppURL.AlertTemplate(
                    title: title,
                    message: message,
                    actions: actions
                )
        ])
    }

    public static func makeActionSheet(
        title: String? = nil,
        message: String? = nil,
        actions: [ActionTemplate] = [],
        sourceView: UIView
    ) -> AppURL {
        AppURL(
            identifier: alertIdentifier,
            parameters: [
                AppURL.templateParameterKey: AppURL.AlertTemplate(
                    style: .actionSheet,
                    title: title,
                    message: message,
                    actions: actions,
                    sourceView: sourceView
                )
        ])
    }
    
    public struct ActionTemplate {
        public let name: String
        public let isCancel: Bool
        public let isDestructive: Bool
        public let action: (() -> Void)?
        
        public init(
            name: String,
            isCancel: Bool,
            isDestructive: Bool,
            action: (() -> Void)?) {
            self.name = name
            self.isCancel = isCancel
            self.isDestructive = isDestructive
            self.action = action
        }
    }
    
    public struct AlertTemplate {
        public let style: UIAlertController.Style
        public let title: String?
        public let message: String?
        public let actions: [ActionTemplate]
        public let sourceView: UIView?
        
        public init(
            style: UIAlertController.Style = .alert,
            title: String?,
            message: String?,
            actions: [ActionTemplate],
            sourceView: UIView? = nil
        ) {
            self.style = style
            self.title = title
            self.message = message
            self.actions = actions
            self.sourceView = sourceView
        }
    }
}

extension AppURL {

    public static let showDetailsInSplitViewControllerIdentifier = "split.details.at.index"

    public static func showDetailsInSplitViewController(
        for index: Int
    ) -> AppURL {
        AppURL(
            identifier: AppURL.showDetailsInSplitViewControllerIdentifier,
            parameters: ["index": index]
        )
    }
}
