//
//  Push.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    public static func push(_ route: RouteType,
                            before: ((UINavigationController, UIViewController) -> Void)? = nil,
                            after: ((UINavigationController, UIViewController) -> Void)? = nil) -> Push {
        Push(route: route, before: before, after: after)
    }

    public static func push(_ route: Route,
                            before: ((UINavigationController, UIViewController) -> Void)? = nil,
                            after: ((UINavigationController, UIViewController) -> Void)? = nil) -> Push {
        Push(route: route, before: before, after: after)
    }

    public static func push(_ nav: Navigation,
                            before: ((UINavigationController, UIViewController) -> Void)? = nil,
                            after: ((UINavigationController, UIViewController) -> Void)? = nil) -> Push {
        Push(container: nav, before: before, after: after)
    }

    public class Push: Context {
        
        init(route: RouteType,
             before: ((UINavigationController, UIViewController) -> Void)?,
             after: ((UINavigationController, UIViewController) -> Void)?) {
            self.before = before
            self.after = after
            super.init(route: route)
        }
        
        init(container: Context,
             before: ((UINavigationController, UIViewController) -> Void)?,
             after: ((UINavigationController, UIViewController) -> Void)?) {
            self.before = before
            self.after = after
            super.init(container: container)
        }
        
        override public func present(with router: Router, from: UIViewController?,
                                     animated: Bool, completion: ((UIViewController) -> Void)?) {
            guard let from = from,
                let nav = from as? UINavigationController ?? from.navigationController
                else { return router.present(.modal(.navigation(route)), animated: false) }
            
            before?(nav, viewController)
            nav.pushViewController(viewController, animated: animated)
            after?(nav, viewController)
            super.present(
                with: router, from: from, animated: false,
                completion: { [weak self] _ in
                    guard let viewController = self?.viewController else { return }
                    completion?(viewController) })
        }

        override public func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            viewController.navigationController?.popViewController(animated: animated)
            super.dismiss(with: router, animated: false, completion: nil)
        }

        var before: ((UINavigationController, UIViewController) -> Void)?
        var after: ((UINavigationController, UIViewController) -> Void)?
    }
}
