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
        return try! model.before(page: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return try! model.after(page: viewController)
    }
}

// MARK: - UIPageViewController delegate methods
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
        //        let currentViewController = self.pageViewController.viewControllers![0]
        //        let viewControllers = [currentViewController]
        //        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
        //
        //        self.pageViewController.isDoubleSided = false
        return .min
    }
}
