//
//  Tab.swift
//  Differ
//
//  Created by Chris Conover on 9/19/19.
//

import UIKit

extension Context {

    public static func tabBar(_ first: RouteType,
                              _ second: RouteType,
                              _ third: RouteType? = nil,
                              _ fourth: RouteType? = nil,
                              _ fifth: RouteType? = nil) -> TabBar {
        return TabBar(tabs: [first, second, third, fourth, fifth]
            .compactMap {
                guard let route = $0 else { return nil }
                print(route.routeName)
                route.viewController.tabBarItem.title = route.routeName
                return route.viewController
        })
    }

    public static func tabBar(_ first: Route,
                              _ second: Route,
                              _ third: Route? = nil,
                              _ fourth: Route? = nil,
                              _ fifth: Route? = nil) -> TabBar {
        return TabBar(tabs: [first, second, third, fourth, fifth]
            .compactMap {
                guard let route = $0 else { return nil }
                print(route.routeName)
                route.viewController.tabBarItem.title = route.routeName
                return route.viewController
        })
    }

    public static func tabBar2(_ first: Route,
                              _ second: Route,
                              _ third: Route? = nil,
                              _ fourth: Route? = nil,
                              _ fifth: Route? = nil) -> TabBar {
        return TabBar(tabs: [first, second, third, fourth, fifth]
            .compactMap {
                guard let route = $0 else { return nil }
                print(route.routeName)
                route.viewController.tabBarItem.title = route.routeName
                return route.viewController
        })
    }

    public class TabBar: Context {
        init(tabs: [UIViewController]) {
            let tabBar = UITabBarController()
            tabBar.viewControllers = tabs
            super.init(route: tabs.first!, containerController: tabBar)
        }
    }
}

