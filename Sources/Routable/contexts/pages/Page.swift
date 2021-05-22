//
//  Page.swift
//  Routable
//
//  Created by Chris Conover on 9/13/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


extension Context {

    public static func page(_ route: RouteType) -> Context {
        return PageContext(route: route)
    }

    public static func page(_ model: PageBuilder) -> Context {
        return PageContext(model: model)
    }

    class PageContext: Context {

        override init(route: RouteType) {
            self.pageBuilder = PageBuilder(route)
            super.init(route: route)
        }

        init(model: PageBuilder) {
            self.pageBuilder = model
            super.init(route: model)
        }

        override public func present(with router: Router, from: UIViewController?, animated: Bool,
                                     completion: ((UIViewController) -> Void)?) {

            // make sure we are already in a page view control model
            guard let from = from,
                let pageController = from as? PageViewController ?? from.parent as? PageViewController,
                let displayedController = pageController.model.current.existing

                // otherwise, create and push a page controller with this route
                else { return router.present(.pages(PagesModel([pageBuilder])!),
                                             animated: false)
            }

            // check for relative position for forward / back animations
            let pagesModel = pageController.model
            let displayedIndex = try! pagesModel.index(of: displayedController)
            let toIndex = try? pagesModel.index(of: pageBuilder)
            let direction: UIPageViewController.NavigationDirection = toIndex == nil
                ? .forward
                : toIndex! > displayedIndex ? .forward : .reverse

            // update base state
            super.present(
                with: router, from: from, animated: false,
                completion: nil)

            // animate to next page
            pageController.setViewControllers(
                [route.viewController],
                direction: direction,
                animated: true,
                completion: { [weak self] done in
                    guard let self = self else { return }
                    pagesModel.current = self.pageBuilder
                    completion?(self.viewController) })
        }

        override public func dismiss(with router: Router, animated: Bool, completion: (() -> Void)?) {
            viewController.navigationController?.popViewController(animated: animated)
            super.dismiss(with: router, animated: false, completion: nil)
        }

        private var pageBuilder: PageBuilder
    }

}


