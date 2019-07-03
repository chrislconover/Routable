//
//  Route.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//


import UIKit



protocol RouteType {
    var viewController: UIViewController { get }
}

class Route: RouteType {
    var viewController: UIViewController { fatalError("abstract base") }
}

extension UIViewController: RouteType {
    var viewController: UIViewController { return self }
}


class AnyRoute: Route {
    init(buildWith: @escaping () -> UIViewController) { self.buildWith = buildWith }
    var buildWith: () -> UIViewController
    private lazy var lazyInstance: UIViewController = buildWith()
    override var viewController: UIViewController { return lazyInstance }
}


