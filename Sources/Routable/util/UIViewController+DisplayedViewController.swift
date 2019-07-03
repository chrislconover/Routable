//
//  UIViewController+DisplayedViewController.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


extension UIViewController {
    @objc var displayedViewController: UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.displayedViewController
        }
        return self
    }
}

extension UITabBarController {
    override var displayedViewController: UIViewController {
        return self.selectedViewController!.displayedViewController
    }
}

extension UINavigationController {
    override var displayedViewController: UIViewController {
        return self.visibleViewController!.displayedViewController
    }
}
