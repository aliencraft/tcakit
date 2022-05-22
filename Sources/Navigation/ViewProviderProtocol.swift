import UIKit

public protocol ViewProviderProtocol {
    associatedtype Item: Hashable
    func viewController(for navigationItem: Item) -> UIViewController
}
