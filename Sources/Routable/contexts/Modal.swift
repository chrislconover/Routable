//
//  Modal.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {


    static func modal(_ route: RouteType, customTransition: Modal.CustomTransition? = nil)
        -> Context {
            return Modal(route: route, customTransition: customTransition)
    }

    static func modal(_ route: Route, customTransition: Modal.CustomTransition? = nil)
        -> Context {
            return Modal(route: route, customTransition: customTransition)
    }

    static func modal(_ nav: Navigation, customTransition: Modal.CustomTransition? = nil)
        -> Context {
        return Modal(container: nav, customTransition: customTransition)
    }


    class Modal: Context {

        typealias CustomTransition = (UIViewController, UIViewController) -> UIViewControllerTransitioningDelegate

        //        init(route: Route, customTransition: CustomTransition? = nil) {
        //            self.customTransition = customTransition
        //            let proxy = Context.Proxy(route: route)
        //            super.init(container: proxy)
        //        }
        //
        //        init(container: Context, customTransition: CustomTransition? = nil) {
        //            self.customTransition = customTransition
        //            let proxy = Context.Proxy(container: container)
        //            super.init(container: proxy)
        //        }


        init(route: RouteType, customTransition: CustomTransition? = nil) {
            self.customTransition = customTransition
            super.init(route: route)
        }

        init(container: Context, customTransition: CustomTransition? = nil) {
            self.customTransition = customTransition
            super.init(container: container)
        }

        override func present(with router: Router, from: UIViewController?, animated: Bool,
                              completion: ((UIViewController) -> Void)?) {
            guard let from = from else {
                assert(false, "Are you sure you want to convert a modal into a root controller?")
                if let container = container { return router.present(.root(container), animated: false) }
                else { return router.present(.root(route), animated: false) }
            }

            // present as modal
            super.present(with: router, from: from, animated: false, completion: nil)
            var customDelegate: UIViewControllerTransitioningDelegate? = nil
            if let customTransition = customTransition {
                viewController.modalPresentationStyle = .custom
                customDelegate = customTransition(from, viewController)
                viewController.transitioningDelegate = customDelegate
            }

            from.present(viewController, animated: animated, completion: { [weak self] in
                customDelegate = nil
                guard let viewController = self?.viewController else { return }
                completion?(viewController) })
        }

        override func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            viewController.dismiss(animated: animated, completion: completion)
            super.dismiss(with: router, animated: animated, completion: completion)
        }

        var customTransition: CustomTransition?
    }
}

