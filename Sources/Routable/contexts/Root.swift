//
//  Root.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


extension Context {

    public static func root(_ route: RouteType, animation: TransitionStrategy? = nil) -> Root {
        return Root(route: route, animation: animation) }
    public static func root(_ route: Route, animation: TransitionStrategy? = nil) -> Root {
        return Root(route: route, animation: animation) }
    public static func root(_ container: Context, animation: TransitionStrategy? = nil) -> Root {
        return Context.Root(container: container, animation: animation) }


    public class Root: Context {

        init(route: RouteType, animation: TransitionStrategy? = nil) {
            super.init(route: route)
            self.animation = animation
        }

        /**
         Create a routing context that hosts a nested container context

         - Parameter route: concrete route nested in container
         - Parameter container: container context ultimately containing the concrete route
         - Parameter animation: optional animation method to perform animations within specified view
         */

        init(container: Context, animation: TransitionStrategy? = nil) {
            super.init(container: container)
            self.animation = animation
        }

        public override func present(with router: Router, from: UIViewController?, animated: Bool,
                              completion: ((UIViewController) -> Void)?) {

            let transition: () -> Void = { [unowned self] in
                router.window.rootViewController = self.viewController }

            if let animation = animation {
                animation(router.window, transition, { [weak self] _ in
                    guard let viewController = self?.viewController else { return }
                    completion?(viewController) })
            }

            else {
                transition()
            }

            router.routes.clear()
            router.routes.push(self)

            super.present(with: router, from: from, animated: false, completion: nil)
            completion?(viewController)
        }

        public override func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            assert(false, "can't dismiss root controller")
        }

        var animation: TransitionStrategy?
    }

}
