import UIKit

protocol Routable {
    var viewController: UIViewController { get }
    func present(with: Router, from: UIViewController?, animated: Bool, completion: ((UIViewController) -> Void)?)
    func dismiss(with: Router, animated: Bool, completion: (() -> Void)?)
}
