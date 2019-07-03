//
//  stack.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import Foundation


public struct Stack<T> {
    fileprivate var array = [T]()

    public var isEmpty: Bool {
        return array.isEmpty
    }

    public var count: Int {
        return array.count
    }

    public func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try array.contains(where: predicate)
    }

    mutating public func push(_ element: T) {
        array.append(element)
    }

    @discardableResult
    mutating public func pop() -> T? {
        return array.popLast()
    }

    @discardableResult
    mutating public func pop(until: (T) -> Bool) -> T? {
        var check = top
        while check != nil && !until(check!) {
            pop()
            check = top
        }

        return array.popLast()
    }

    public func popped(until: (T) -> Bool) -> Stack {
        var popped = self
        var check = popped.top
        while check != nil && !until(check!) {
            popped.pop()
            check = popped.top
        }

        return popped
    }


    mutating public func clear() {
        array.removeAll()
    }

    public var top: T? {
        return array.last
    }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = array.count - 1
        return AnyIterator {
            defer { curr = curr - 1 }
            return curr > 0 ? self.array[curr] : nil
        }
    }
}


extension Stack: CustomStringConvertible {

    public var description: String {
        return self.map({ "\n\t\($0)" }).joined(separator: " ")
    }
}
