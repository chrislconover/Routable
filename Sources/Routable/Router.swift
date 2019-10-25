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
        window.makeKeyAndVisible()
    }

    var displayedViewController: UIViewController? {
        return window.rootViewController?.displayedViewController
    }

    internal var window: UIWindow!
    internal var routes = Stack<Routable>()
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
    
    public func dismissModal(`for` controller: UIViewController? = nil, animated: Bool = true,
                             completion: (() -> Void)? = nil) {
        Logger.route("\(#function).\(#line) before: \(routes)")

        let poppedToModal = routes.popped(until: { route in
            guard let route = route as? Context.Modal else { return false }
            guard let controller = controller else { return true }
            return route.viewController === controller
        })
        guard let modal = poppedToModal.top else { return }
        routes = poppedToModal
        modal.dismiss(with: self, animated: animated, completion: completion)
        Logger.route("\(#function).\(#line) after: \(routes)")
    }
}

