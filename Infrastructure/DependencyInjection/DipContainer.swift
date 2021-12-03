import Foundation
import Dip
import JFLib_Services

extension Dip.DependencyContainer: JFServiceContainer {
    public func register<T>(_ factory: @escaping () -> T) {}
    public func register<T, A>(_ factory: @escaping (A) -> T) {}
    public func register<T, A, B>(_ factory: @escaping (A, B) -> T) {}
    public func register<T, A, B, C>(_ factory: @escaping (A, B, C) -> T) {}
    public func register<T, A, B, C, D>(_ factory: @escaping (A, B, C, D) -> T) {}
    public func register<T, A, B, C, D, E>(_ factory: @escaping (A, B, C, D, E) -> T) {}
    public func register<P, T>(_ protocol: P.Type, _ factory: @escaping () -> T) {}
    public func register<P, T, A>(_ protocol: P.Type, _ factory: @escaping (A) -> T) {}
    public func register<P, T, A, B>(_ protocol: P.Type, _ factory: @escaping (A, B) -> T) {}
    public func register<P, T, A, B, C>(_ protocol: P.Type, _ factory: @escaping (A, B, C) -> T) {}
    public func register<P, T, A, B, C, D>(_ protocol: P.Type, _ factory: @escaping (A, B, C, D) -> T) {}
    public func register<P, T, A, B, C, D, E>(_ protocol: P.Type, _ factory: @escaping (A, B, C, D, E) -> T) {}

    public func resolve<T>() throws -> T {
        try resolve(tag: nil)
    }
}
