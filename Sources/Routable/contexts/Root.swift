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
    public static func root(_ route: RouteType, animation: Transition) -> Root {
        return Root(route: route, animation: animation.transform) }
    public static func root(_ route: RouteType,
                            option: UIView.AnimationOptions,
                            duration: TimeInterval) -> Root {
        root(route, animation: .viewTransition(with: option, duration: duration))
    }

    public static func root(_ route: Route, animation: TransitionStrategy? = nil) -> Root {
        return Root(route: route, animation: animation) }
    public static func root(_ route: Route, animation: Transition) -> Root {
        return Root(route: route, animation: animation.transform) }
    public static func root(_ route: Route,
                            option: UIView.AnimationOptions,
                            duration: TimeInterval) -> Root {
        root(route, animation: .viewTransition(with: option, duration: duration))
    }

    public static func root(_ container: Context, animation: TransitionStrategy? = nil) -> Root {
        return Context.Root(container: container, animation: animation) }
    public static func root(_ container: Context, animation: Transition) -> Root {
        return Context.Root(container: container, animation: animation.transform) }
    public static func root(_ container: Context,
                            option: UIView.AnimationOptions,
                            duration: TimeInterval) -> Root {
        root(container, animation: .viewTransition(with: option, duration: duration))
    }

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

            // reaet router stack, prepare any nested containers
            router.routes.clear()
            router.routes.push(self)
            container?.present(with: router, from: from, animated: animated, completion: completion)

            let transition: () -> Void = { [unowned self] in
                router.window.rootViewController = self.viewController
            }

            if animated, let animation = animation {
                animation(
                    router.window,
                    transition,
                    { [weak self] _ in
                        guard let viewController = self?.viewController else { return }
                        completion?(viewController) })
            }

            else {
                transition()
                completion?(viewController)
            }
        }

        public override func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            assert(false, "can't dismiss root controller")
        }

        var animation: TransitionStrategy?
    }

}
