//
//  Transition.swift
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import UIKit

typealias TransitionStrategy = (UIView, @escaping (() -> Void), ((Bool) -> Void)?) -> Void

class Transition {

    static var flipIn: TransitionStrategy {
        return viewTransitionWith(option: .transitionFlipFromRight)
    }

    static var flipOut: TransitionStrategy {
        return viewTransitionWith(option: .transitionFlipFromLeft)
    }

    static func viewTransitionWith(option: UIView.AnimationOptions) -> TransitionStrategy {
        return { container, animation, completion in
            UIView.transition(
                with: container,
                duration: 1.0,
                options: option,
                animations: animation,
                completion: completion)
        }
    }
}
