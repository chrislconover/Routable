//
//  Navigation.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    public static func navigation(_ route: RouteType) -> Navigation {
        return Navigation(route: route) }
    public static func navigation(_ route: Route) -> Navigation {
        return Navigation(route: route) }


    public class Navigation: Context {
        override init(route: RouteType) {
            super.init(route: route, containerController:
                UINavigationController(rootViewController: route.viewController))
        }
    }
}
