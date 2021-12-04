import Foundation
import Combine
import OSLog

extension Publisher {
    /// Handles errors from an upstream publisher by logging it and then replacing it with the provided element.
    ///
    /// If the upstream publisher fails with an error this publisher logs the error, emits the provided element, and then continues publishing events.
    ///
    /// - returns: A publisher that handles errors from an upstream publisher by replacing the failed publisher with another publisher.
    func logError<T>(to logger: Logger, andReplaceWith value: T) -> AnyPublisher<T, Never> where T == Output {
        `catch` { error -> AnyPublisher<T, Never> in
            logger.error(error)
            return Just(value).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
}
