//
//  Router.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

public class Router {

    deinit {
        print("Router.deinit")
    }

    public init(window: UIWindow!) {
        self.window = window
    }

    public var displayedViewController: UIViewController? {
        return window.rootViewController?.displayedViewController
    }

    internal var window: UIWindow!
    internal var routes = Stack<Context>()
    internal var rootController: UIViewController? {
        return window?.rootViewController }

    public func present(_ context: Context, animated: Bool, completion: ((UIViewController) -> Void)? = nil) {
        Logger.route("before: \(routes)")
        let from = displayedViewController
        context.present(with: self, from: from, animated: animated, completion: completion)
        Logger.route("after: \(routes)")
    }

    @discardableResult
    public func present(_ contexts: Context..., animated: Bool, completion: ((UIViewController) -> Void)? = nil) -> Router {

        let remaining = contexts.dropFirst()
        guard let first = contexts.first
            else {
                assert(false, "must have at least one context!")
                return self
        }

        present(first, animated: animated) { [unowned self] controller in
            for context in remaining.dropLast() {
                self.present(context, animated: false)
            }

            guard let last = remaining.last else { completion?(controller); return }
            self.present(last, animated: false, completion: completion)
        }

        return self
    }

    public func pop(animated: Bool = true, completion: (() -> Void)? = nil) {
        Logger.route("\(#function).\(#line) before: \(routes)")
        defer { Logger.route("\(#function).\(#line) after: \(routes)") }

        guard let top = routes.top,
            let _ = top.viewController.navigationController
            else {
                Logger.error("Attempting to pop from nav controller but there is no immediately accessibly nav controller: \(String(describing: routes.top?.viewController))")
                assert(false)
                return
        }

        Logger.route("\(#function).\(#line) top is: \(top)")
        top.dismiss(with: self, animated: animated, completion: completion)
    }

    /**
     Dismisses zero ore more modal view controllers. If there are no modals on the stack, this does nothing.  If `unwindTo` (view controller) is specified, then it keeps unwinding until the same instasnce is found it finds that view controller.  If `unwindTo` is specified but not found, this does nothing.

     - Parameter unwindTo:    Opitonal view modal controller to unwind to
     - Parameter animated:    Optional flag to specify whether or not the operation is animated
     - Parameter completion:  Optional handler to be called when the operation is complete
     */
    public func dismissModal(toPresenting controller: UIViewController? = nil,
                             animated: Bool = true, completion: (() -> Void)? = nil) {
        Logger.route("\(#function).\(#line) before: \(routes.map { $0.routeName })")

        let poppedToModal = routes.popped(until: { route in
            guard let route = route as? Context.Modal else { return false }
            guard let controller = controller else { return true }
            return route.viewController.presentingViewController === controller
        })
        guard let modalRoute = poppedToModal.top else { return }
        routes = poppedToModal
        modalRoute.dismiss(with: self, animated: animated, completion: completion)
        Logger.route("\(#function).\(#line) after: \(routes.map { $0.routeName })")
    }

    /**
     Dismisses zero ore more modal view controllers.  If `unwindTo` is  not found, this does nothing.

     - Parameter unwindTo:    Route to unwind to
     - Parameter animated:    Optional flag to specify whether or not the operation is animated
     - Parameter completion:  Optional handler to be called when the operation is complete
     */
    public func dismissModal(toPresenting route: Route, animated: Bool = true,
                             completion: (() -> Void)? = nil) {
        defer { Logger.route("\(#function).\(#line) after: \(routes.map { $0.routeName })") }
        Logger.route("\(#function).\(#line) before: \(routes.map { $0.routeName })")

        Logger.route("\(#function).\(#line) looking for route: \(route.routeName)")
        let poppedToModal = routes.popped(until: { route in
            guard let route = route as? Context.Modal else { return false }
            return route.viewController.presentingViewController?.routeName == route.routeName
        })
        guard let modalRoute = poppedToModal.top else {
            return
        }
        routes = poppedToModal
        modalRoute.dismiss(with: self, animated: animated, completion: completion)
    }
}

