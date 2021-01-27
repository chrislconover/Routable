//
//  Transition.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

public typealias TransitionStrategy = (UIView, @escaping (() -> Void), ((Bool) -> Void)?) -> Void

public class Transition {
    
    public init(transition: @escaping TransitionStrategy) {
        self.transform = transition
    }

    public static func flipIn(duration: TimeInterval) -> Transition {
        viewTransition(with: .transitionFlipFromRight, duration: duration)
    }

    public static func flipOut(duration: TimeInterval) -> Transition {
        viewTransition(with: .transitionFlipFromLeft, duration: duration)
    }

    public static func viewTransition(with option: UIView.AnimationOptions,
                                      duration: TimeInterval) -> Transition {
        .init() { container, animation, completion in
            UIView.transition(
                with: container,
                duration: duration,
                options: option,
                animations: animation,
                completion: completion) }
    }
    
    public private(set) var transform: TransitionStrategy
}
