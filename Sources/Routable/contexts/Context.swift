//
//  Context.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


open class Context: RoutableType {

    /**
     Create a routing context that contains concrete route view controller
     - Parameter route: concrete route to be presented
     - Parameter animation: optional animation method to perform animations within specified view
     */

    init(route: RouteType) {
        self.route = route
        self.viewController = route.viewController
    }

    /**
     Create a routing context that hosts a container view controller

     - Parameter route: concrete route nested in container
     - Parameter controller: container controller containing the concrete route, eg Nav controller
     - Parameter animation: optional animation method to perform animations within specified view
     */

    init(route: RouteType, containerController: UIViewController) {
        self.route = route
        self.viewController = containerController
    }

    /**
     Create a routing context that hosts a nested container context

     - Parameter route: concrete route nested in container
     - Parameter container: container context ultimately containing the concrete route
     - Parameter animation: optional animation method to perform animations within specified view
     */

    init(container: Context) {
        self.container = container
        self.route = container.route
        self.viewController = container.viewController
    }

    /**
     Create a routing context that hosts a nested container context, such as modally presenting a controller nested in a  navigation controller

     - Parameter route: concrete route nested in container
     - Parameter container: container context ultimately containing the concrete route
     - Parameter animation: optional animation method to perform animations within specified view
     */

    init(container: Context, proxyController: UIViewController) {
        self.container = container
        self.route = container.route
        self.viewController = proxyController
    }

    public func present(with router: Router, from: UIViewController?,
                        animated: Bool, completion: ((UIViewController) -> Void)?) {
        Logger.route("\(#function) Adding \(self) to stack")
        
        guard let root = router.window.rootViewController else {
            return router.present(.root(self), animated: false) }
        
        router.routes.push(self)
        container?.present(with: router, from: from, animated: animated, completion: completion)
    }
    
    public func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
        Logger.route("\(#function).\(#line) before popping self: \(router.routes)")
        var top = router.routes.top
        top?.parent = nil
        router.routes.pop()
        Logger.route("\(#function).\(#line) after popping self: \(router.routes)")
    }

    var unwindProxy: RouteProxyController!
    public private(set) var route: RouteType
    var parent: RouteType?
    
    /// The nested view controller which may or may not be a container controller, like UINavigation Controller
    public var viewController: UIViewController
    var container: Context?
}

extension Context: CustomStringConvertible {
    public var description: String {
        let contextName = String(describing: type(of: self))
        let controllerName = String(describing: type(of: viewController))
        let description = "\(contextName)(\(controllerName)): \(routeName)"
        return description
    }
}
