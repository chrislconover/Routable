//
//  Window.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    static func window(_ context: Context) -> Context {
        return Window(container: context) }

    class Window: Root {

        override fileprivate init(container: Context, animation: TransitionStrategy? = nil) {
            overlay = UIWindow(frame: UIScreen.main.bounds)
            super.init(container: container)
            self.animation = animation
        }

        override func present(with router: Router, from: UIViewController?, animated: Bool,
                              completion: ((UIViewController) -> Void)?) {


            let transition: () -> Void = { [unowned self] in
                self.overlay.makeKeyAndVisible()
                self.overlay.rootViewController = self.viewController }

            if let animation = animation {
                animation(overlay, transition, { [weak self] _ in
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

        var overlay: UIWindow
    }
}

