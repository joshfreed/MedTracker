import Foundation
import Combine

protocol CoreDataNotifier {
    func postCoreDataDidChange()
    func coreDataDidChange() -> AnyPublisher<Void, Never>
}
