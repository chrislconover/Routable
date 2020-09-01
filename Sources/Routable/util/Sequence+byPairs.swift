//
//  Swift.swift
//  Curious Applications
//
//  Created by Chris Conover on 2/6/18.
//
//  Based on original work from:
//      https://gist.github.com/khanlou/f27b34f28b21b4834a758913e06a5f3b

import Foundation


extension Sequence {

    var withPrevious: AnySequence<(Element, Element)> {
        var iterator = self.makeIterator()
        guard var previous = iterator.next() else { return AnySequence([]) }
        return AnySequence({ () -> AnyIterator<(Element, Element)> in
            return AnyIterator({
                guard let next = iterator.next() else { return nil }
                defer { previous = next }
                return (previous, next)
            })
        })
    }
}


extension ClosedRange {
    func clamp(_ value: Bound) -> Bound {
        return (value ... value).clamped(to: self).lowerBound
    }
}


extension Range {
    func clamp(_ value: Bound) -> Bound {
        return (value ..< value).clamped(to: self).lowerBound
    }
}

extension Int {
    func clamped( to: Range<Int>) -> Int {
        return to.clamp(self)
    }

    func clamped(to: ClosedRange<Int>) -> Int {
        return to.clamp(self)
    }
}
