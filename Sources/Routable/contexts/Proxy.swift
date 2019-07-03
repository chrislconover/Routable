//
//  Proxy.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


extension Context {
    class Proxy: Context {
        override init(route: RouteType) {
            let controller = route.viewController
            super.init(route: route, containerController: RouteProxyController(controller))
        }

        override init(container: Context) {
            let controller = container.viewController
            super.init(container: container, proxyController: RouteProxyController(controller))
        }
    }
}


class RouteProxyController: UIViewController {

    init(_ nestedController: UIViewController) {
        self.nestedController = nestedController
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError("nope") }

    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
    }

    override var canResignFirstResponder: Bool {
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return resignFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }

    override func viewDidLoad() {
        view.backgroundColor = .cyan
        addChild(nestedController)
        guard let nestedView = nestedController.view else { return }
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[child]|", options: [],
            metrics: nil, views: ["child": nestedView]))
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[child]|", options: [],
            metrics: nil, views: ["child": nestedView]))
    }

    var nestedController: UIViewController
}
