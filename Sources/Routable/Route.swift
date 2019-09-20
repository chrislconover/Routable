//
//  Route.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//


import UIKit



public protocol RouteType {
    var routeName: String { get }
    var viewController: UIViewController { get }
}

extension RouteType where Self: UIViewController {
    public var routeName: String {
        return String(describing: type(of: self))
    }
}

public class Route: RouteType {
    public var routeName: String { fatalError("abstract base") }
    public var viewController: UIViewController { fatalError("abstract base") }
}

extension UIViewController: RouteType {
    public var viewController: UIViewController { return self }
}


public class AnyRoute: Route {

    public init(name: String,
                buildWith: @escaping () -> UIViewController) {
        self.name = name
        self.buildWith = buildWith
    }

    public override var routeName: String {
        return name ?? viewController.routeName
    }

    public override var viewController: UIViewController {
        return lazyInstance
    }

    private var buildWith: () -> UIViewController
    private lazy var lazyInstance: UIViewController = buildWith()
    private var name: String?
}


