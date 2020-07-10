//
//  Push.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    public static func push(_ route: RouteType, configure: ((UIViewController) -> Void)? = nil) -> Push {
        Push(route: route, configure: configure) }
    
    public static func push(_ route: Route, configure: ((UIViewController) -> Void)? = nil) -> Push {
        Push(route: route, configure: configure) }
    
    public static func push(_ nav: Navigation, configure: ((UIViewController) -> Void)? = nil) -> Push {
        Push(container: nav, configure: configure) }

    public class Push: Context {
        
        init(route: RouteType, configure: ((UIViewController) -> Void)?) {
            self.configure = configure
            super.init(route: route)
        }
        
        init(container: Context, configure: ((UIViewController) -> Void)?) {
            self.configure = configure
            super.init(container: container)
        }
        
        override public func present(with router: Router, from: UIViewController?,
                                     animated: Bool, completion: ((UIViewController) -> Void)?) {
            guard let from = from,
                let nav = from as? UINavigationController ?? from.navigationController
                else { return router.present(.modal(.navigation(route)), animated: false) }
            
            nav.pushViewController(viewController, animated: animated)
            configure?(viewController)
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

        var configure: ((UIViewController) -> Void)?
    }
}
