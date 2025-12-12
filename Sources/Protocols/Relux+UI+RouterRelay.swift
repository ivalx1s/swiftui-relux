import SwiftUI
import Relux

extension Relux.UI {
    /// A generic wrapper that makes a pure RouterDefinition usable in SwiftUI.
    /// It conforms to ObservableObject so it can be injected via @EnvironmentObject.
    @MainActor
    public final class RouterRelay<Def: Relux.Navigation.RouterDefinition>: @MainActor Relux.Navigation.RouterRelaying, ObservableObject {
        
        /// The pure implementation of the router logic.
        public let interface: Def
        
        public init(_ interface: Def) {
            self.interface = interface
        }
        
        public var definitionTypeKey: TypeKeyable.Key {
            Def.key
        }
        
        public nonisolated static var key: TypeKeyable.Key { ObjectIdentifier(Self.self) }
        public nonisolated var key: TypeKeyable.Key { ObjectIdentifier(Self.self) }
    }
}
