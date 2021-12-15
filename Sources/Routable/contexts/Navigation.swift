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
    public func withLeftButton(_ button: UIBarButtonItem) -> Self {
        navigationItem.leftBarButtonItem = button
        return self
    }
    
    @discardableResult
    public func withRightButton(_ button: UIBarButtonItem) -> Self {
        navigationItem.rightBarButtonItem = button
        return self
    }

}


extension UINavigationController {
    @discardableResult
    public func withCustomNavBar(background: UIColor? = nil,
                                 tint: UIColor? = nil,
                                 titleColor: UIColor? = nil,
                                 font: UIFont? = nil,
                                 backImage: UIImage? = nil) -> Self {
        
        // configure nav controller bar
        if #available(iOS 13, *) {
            if let background = background {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = background
                var attributes = appearance.titleTextAttributes ?? [:]
                if let titleColor = titleColor { attributes[.foregroundColor] = titleColor }
                if let font = font { attributes[.font] = font }
                appearance.titleTextAttributes = attributes
                navigationBar.standardAppearance = appearance;
                navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            }
            
            else {
                navigationBar.barTintColor = background ?? view.backgroundColor
                if let tint = tint { navigationBar.tintColor = tint }
                if let titleColor = titleColor {
                    navigationBar.titleTextAttributes = [.foregroundColor: titleColor]
                }
            }
        }

        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        if let backImage = backImage {
            navigationBar.backIndicatorImage = backImage
            navigationBar.backIndicatorTransitionMaskImage = backImage
        }
        return self
    }
}
