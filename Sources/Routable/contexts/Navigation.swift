//
//  Navigation.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {
    
    public static func navigation<T: UINavigationController>(
        _ route: RouteType,
        with controller: T.Type = T.self,
        configure: ((UIViewController) -> Void)? = nil) -> Navigation {
        let nav = T(rootViewController: route.viewController)
        configure?(route.viewController)
        return Navigation(route: route, with: nav) }
    
    public static func navigation<T: UINavigationController>(
        _ route: Route,
        with controller: T.Type = T.self,
        configure: ((UIViewController) -> Void)? = nil) -> Navigation {
        let nav = T(rootViewController: route.viewController)
        configure?(route.viewController)
        return Navigation(route: route, with: nav) }


    public class Navigation: Context {
        
        init(route: RouteType, with controller: UINavigationController) {
            super.init(route: route, containerController: controller)
        }

        override init(route: RouteType) {
            super.init(route: route, containerController:
                UINavigationController(rootViewController: route.viewController))
        }
    }
}

class FullScreenNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers.first {
            self.setNavigationBarHidden(true, animated: animated)
        } else {
            self.setNavigationBarHidden(false, animated: animated)
        }
    }
}

extension Context {
    public static func navigationHideFirstBar(_ route: RouteType) -> Navigation {
        let nav = FullScreenNavigationController(rootViewController: route.viewController)
        return Navigation(route: route, with: nav) }
    
    public static func navigationHideFirstBar(_ route: Route) -> Navigation {
        let nav = FullScreenNavigationController(rootViewController: route.viewController)
        return Navigation(route: route, with: nav) }
}


extension UIViewController {
    @discardableResult
    public func withCustomNavBar(background: UIColor? = nil,
                                 tint: UIColor? = nil,
                                 titleColor: UIColor? = nil,
                                 backImage: UIImage? = nil,
                                 firstLeftButton: UIBarButtonItem? = nil) -> Self {
        assert(navigationController != nil)
        guard let navigationController = navigationController else { return self }
        if let firstLeftButton = firstLeftButton {
            navigationItem.leftBarButtonItem = firstLeftButton
        }

        // configure nav controller bar
        let navBar = navigationController.navigationBar
        navBar.barTintColor = background ?? view.backgroundColor
        if let tint = tint { navBar.tintColor = tint }
        if let titleColor = titleColor {
            navBar.titleTextAttributes = [.foregroundColor: titleColor]
        }

        navBar.isTranslucent = false
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        if let backImage = backImage {
            navBar.backIndicatorImage = backImage
            navBar.backIndicatorTransitionMaskImage = backImage
        }
        return self
    }
    
    @discardableResult
    public func withLeftButton(_ leftButton: UIBarButtonItem) -> Self {
        guard let navigationController = navigationController
            else { assert(false); return self }
        navigationItem.leftBarButtonItem = leftButton
        return self
    }
}
