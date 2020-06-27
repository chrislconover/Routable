//
//  Push.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    public static func push(_ route: RouteType) -> Push {
        return Push(route: route) }
    public static func push(_ route: Route) -> Push {
        return Push(route: route) }
    public static func push(_ nav: Navigation) -> Push {
        return Push(container: nav) }

    public class Push: Context {
        override public func present(with router: Router, from: UIViewController?,
                                     animated: Bool, completion: ((UIViewController) -> Void)?) {
            guard let from = from,
                let nav = from as? UINavigationController ?? from.navigationController
                else { return router.present(.modal(.navigation(self.route)), animated: false) }
            
            nav.pushViewController(self.viewController, animated: animated)
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
    }
}
