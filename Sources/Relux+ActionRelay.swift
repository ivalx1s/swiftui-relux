
import SwiftUI
import Relux
import Combine

extension Relux.UI {
    /// Generic wrapper that makes ActionProviding injectable via @EnvironmentObject.
    /// Conforms to ActionRelaying (darwin-relux) + ObservableObject (Combine).
    @MainActor
    public final class ActionRelay<T: Relux.ActionProviding>: Relux.ActionRelaying, ObservableObject {
        nonisolated public let actions: T
        
        public init(_ actions: T) {
            self.actions = actions
        }
        
        public static var key: TypeKeyable.Key {
            .init(type(of: self))
        }
    }
}
