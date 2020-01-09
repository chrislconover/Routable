import UIKit


public protocol RouteType {
    var routeName: String { get }
    var viewController: UIViewController { get }
}

extension RouteType where Self: Context {
    public var routeName: String { route.routeName }
}

public protocol RoutableType: RouteType {

    func present(with: Router, from: UIViewController?, animated: Bool, completion: ((UIViewController) -> Void)?)
    func dismiss(with: Router, animated: Bool, completion: (() -> Void)?)
}
