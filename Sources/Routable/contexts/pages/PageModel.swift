//
//  PagesModel.swift
//  Routable
//
//  Created by Chris Conover on 9/13/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit


public class PageBuilder: RouteType {

    public init(_ route: RouteType) {
        self.key = { String(route.routeName) }
        self.builder = { route.viewController }
    }

    public init(_ route: Route) {
        self.key = { String(route.routeName) }
        self.builder = { route.viewController }
    }

    public init(key: @autoclosure @escaping () -> Key,
                builder: @escaping () -> UIViewController) {
        self.key = key
        self.builder = builder
    }

    public init(key: @autoclosure @escaping () -> Key,
                builder: @autoclosure @escaping () -> UIViewController) {
        self.key = key
        self.builder = builder
    }

    public var routeName: String { return viewController.routeName }
    public var viewController: UIViewController {
        if existing == nil { existing = createOnUse }
        return createOnUse
    }

    public typealias Key = String
    var key: () -> Key
    var builder: () -> UIViewController
    var existing: UIViewController?
    private lazy var createOnUse: UIViewController = builder()
}

extension PageBuilder: Hashable {
    public func hash(into hasher: inout Hasher) { hasher.combine(key()) }
}

public func == (lhs: PageBuilder, rhs: PageBuilder) -> Bool {
    return false
}


public class PagesModel {

    public init?(_ pages: [PageBuilder], current: PageBuilder? = nil) {
        guard !pages.isEmpty else { return nil }
        self.pages = pages
        self.current = current ?? pages.first!
    }

    public init?(routes: [RouteType], current: RouteType? = nil) {
        guard !routes.isEmpty else { return nil }
        let pages = routes.map { PageBuilder($0) }
        self.pages = pages
        self.current = current.flatMap({ PageBuilder($0) }) ?? pages.first!
    }

    var first: PageBuilder { return pages[0] }

    var next: UIViewController {
        let after = try! index(of: current.key()).clamped(to: (0 ..< pages.count))
        return pages[after].viewController
    }

    var previous: UIViewController {
        let before = try! index(of: current.key()).clamped(to: (1 ... pages.count))
        return pages[before].viewController
    }

    func before(page: PageBuilder.Key) -> UIViewController? {
        guard let index = try? index(of: page),
              pages.indices.contains(index - 1)
        else { return nil }
        return pages[index - 1].viewController
    }

    func before(page: UIViewController) -> UIViewController? {
        guard let index = try? index(of: page),
              pages.indices.contains(index - 1)
        else { return nil }
        return pages[index - 1].viewController
    }

    func after(page: PageBuilder.Key) -> UIViewController? {
        guard let index = try? index(of: page),
              pages.indices.contains(index + 1)
        else { return nil }
        return pages[index + 1].viewController
    }

    func after(page: UIViewController) -> UIViewController? {
        guard let index = try? index(of: page),
              pages.indices.contains(index + 1)
        else { return nil }
        return pages[index + 1].viewController
    }

    func index(of page: PageBuilder) throws -> Int {
        return try index(of: page.key())
    }

    func index(of key: PageBuilder.Key) throws -> Int {
        guard let current = pages.firstIndex(where: { $0.key() == key })
            else { throw "Out of range" }
        return current
    }

    func index(of controller: UIViewController) throws -> Int {
        guard let current = pages.firstIndex(where: { $0.existing === controller })
            else { throw "Out of range" }
        return current
    }

    var pages: [PageBuilder]
    var current: PageBuilder
}
