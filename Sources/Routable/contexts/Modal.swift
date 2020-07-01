//
//  Modal.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {


    public static func modal(_ route: RouteType, customTransition: Modal.CustomTransition? = nil) -> Context {
        Modal(route: route, customTransition: customTransition)
    }

    public static func modal(_ route: RouteType,
                             presentation: UIModalPresentationStyle,
                             transition: UIModalTransitionStyle = .coverVertical) -> Context {
        Modal(route: route, configure: { from, to in
                to.modalPresentationStyle = presentation
                to.modalTransitionStyle = transition })
    }


    public static func modal(_ route: Route, customTransition: Modal.CustomTransition? = nil) -> Context {
        Modal(route: route, customTransition: customTransition)
    }

    public static func modal(_ route: Route,
                             presentation: UIModalPresentationStyle,
                             transition: UIModalTransitionStyle = .coverVertical) -> Context {
        Modal(route: route, configure: { from, to in
                to.modalPresentationStyle = presentation
                to.modalTransitionStyle = transition })
    }


    public static func modal(_ nav: Navigation, customTransition: Modal.CustomTransition? = nil) -> Context {
        Modal(container: nav, customTransition: customTransition)
    }

    public static func modal(_ nav: Navigation,
                             presentation: UIModalPresentationStyle,
                             transition: UIModalTransitionStyle = .coverVertical) -> Context {
        Modal(container: nav, configure: { from, to in
                to.modalPresentationStyle = presentation
                to.modalTransitionStyle = transition })
    }

    public class Modal: Context {

        public typealias CustomTransition = (UIViewController, UIViewController) -> UIViewControllerTransitioningDelegate

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

        init(route: RouteType, configure: @escaping (UIViewController, UIViewController) -> Void) {
            self.configure = configure
            super.init(route: route)
        }

        init(container: Context, customTransition: CustomTransition? = nil) {
            self.customTransition = customTransition
            super.init(container: container)
        }

        init(container: Context, configure: @escaping (UIViewController, UIViewController) -> Void) {
            self.configure = configure
            super.init(container: container)
        }

        public override func present(with router: Router, from: UIViewController?, animated: Bool,
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

            else if let configure = configure {
                configure(from, viewController)
            }

            from.present(viewController, animated: animated, completion: { [weak self] in
                customDelegate = nil
                guard let viewController = self?.viewController else { return }
                completion?(viewController) })
        }

        public override func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            guard let presenting = viewController.presentingViewController else {
                return assert(false, "Modal context should always have presenting controller!") }
            presenting.dismiss(animated: animated, completion: completion)
            super.dismiss(with: router, animated: animated, completion: completion)
        }

        var customTransition: CustomTransition? = nil
        var configure: ((UIViewController, UIViewController) -> Void)? = nil
    }
}

