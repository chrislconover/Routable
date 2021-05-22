//
//  Page.swift
//  Routable
//
//  Created by Chris Conover on 9/13/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

extension Context {

    public static func pages(
        _ routes: Route...,
        transitionStyle style: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey : Any]? = nil) -> Context {

        return Context.pages(PagesModel(routes: routes)!,
                             transitionStyle: style,
                             navigationOrientation: navigationOrientation,
                             options: options)
    }

    public static func pages(
        _ pages: RouteType...,
        transitionStyle style: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey : Any]? = nil) -> Context {

        return Context.pages(PagesModel(routes: pages)!,
                             transitionStyle: style,
                             navigationOrientation: navigationOrientation,
                             options: options)
    }

    public static func pages(
        _ pages: [PageBuilder],
        transitionStyle style: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey : Any]? = nil) -> Context {

        return Context.pages(PagesModel(pages)!,
                     transitionStyle: style,
                     navigationOrientation: navigationOrientation,
                     options: options)
    }

    public static func pages(_ model: PagesModel,
        transitionStyle style: UIPageViewController.TransitionStyle = .scroll,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        options: [UIPageViewController.OptionsKey : Any]? = nil) -> Context {

        return PagesContext(model: model,
                              transitionStyle: style,
                              navigationOrientation: navigationOrientation,
                              options: options)
    }

    class PagesContext: Context {
        init(model: PagesModel,
             transitionStyle style: UIPageViewController.TransitionStyle,
             navigationOrientation: UIPageViewController.NavigationOrientation,
             options: [UIPageViewController.OptionsKey : Any]? = nil) {
            super.init(
                route: model.current,
                containerController: PageViewController(
                    model: model,
                    transitionStyle: style,
                    navigationOrientation: navigationOrientation,
                    options: options))
        }
    }
}
