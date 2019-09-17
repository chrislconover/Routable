//
//  PageController.swift
//  Routable
//
//  Created by Chris Conover on 9/13/19.
//

import UIKit

class PageViewController: UIPageViewController {

    init(model: PagesModel,
         transitionStyle style: UIPageViewController.TransitionStyle,
         navigationOrientation: UIPageViewController.NavigationOrientation,
         options: [UIPageViewController.OptionsKey : Any]? = nil) {
        self.model = model
        super.init(transitionStyle: style,
                   navigationOrientation: navigationOrientation,
                   options: options)
        delegate = self
        dataSource = self
        reset()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("nope") }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var model: PagesModel { didSet { reset() }}
    func reset() {
        let first = [model.first.viewController]
        setViewControllers(first, direction: .forward,
                           animated: false, completion: {done in })
    }
}




// MARK: - Page View Controller Data Source
extension PageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let before = try! model.before(page: viewController)
        Logger.route("PageViewController.\(#function) -> \(before.routeName)")
        return before
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let after = try! model.after(page: viewController)
        Logger.route("PageViewController.\(#function) -> \(after.routeName)")
        return after
    }
}

// MARK: - UIPageViewController delegate methods
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        return .none
    }
}
