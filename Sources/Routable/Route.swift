//
//  Route.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//


import UIKit



public protocol RouteType {
    var viewController: UIViewController { get }
}

public class Route: RouteType {
    public var viewController: UIViewController { fatalError("abstract base") }
}

extension UIViewController: RouteType {
    public var viewController: UIViewController { return self }
}


public class AnyRoute: Route {
    public init(buildWith: @escaping () -> UIViewController) { self.buildWith = buildWith }
    var buildWith: () -> UIViewController
    private lazy var lazyInstance: UIViewController = buildWith()
    public override var viewController: UIViewController { return lazyInstance }
}


