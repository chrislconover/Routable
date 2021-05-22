//
//  Tab.swift
//  Routable
//
//  Created by Chris Conover on 9/19/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

public struct RouteTab {

    public static func tab(_ route: RouteType,
                    tab: ((UITabBarItem) -> Void)! = nil) -> RouteTab {
        RouteTab(route, tab: tab)
    }

    public static func tab(_ route: Route, tab: ((UITabBarItem) -> Void)! = nil) -> RouteTab {
        RouteTab(route, tab: tab)
    }

    public static func tab(_ route: Context, tab: ((UITabBarItem) -> Void)! = nil) -> RouteTab {
        RouteTab(route, tab: tab)
    }

    private init(_ route: RouteType, tab: ((UITabBarItem) -> Void)! = nil) {
        self.route = route
        self.configureTabItem = tab
    }

    public private(set) var route: RouteType
    public private(set) var configureTabItem: ((UITabBarItem) -> Void)!
}

extension Context {

    public static func tabBar(_ first: RouteTab,
                              _ second: RouteTab,
                              _ third: RouteTab? = nil,
                              _ fourth: RouteTab? = nil,
                              _ fifth: RouteTab? = nil) -> TabBar {
        let controllers: [UIViewController] = [first, second, third, fourth, fifth].compactMap {
            guard let tab = $0 else { return nil }
            tab.configureTabItem?(tab.route.viewController.tabBarItem)
            return tab.route.viewController }
        return TabBar(tabs: controllers)
    }

    public class TabBar: Context {
        init(tabs: [UIViewController]) {
            let tabBar = UITabBarController()
            tabBar.viewControllers = tabs
            super.init(route: tabs.first!, containerController: tabBar)
        }
    }
}

