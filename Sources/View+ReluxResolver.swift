import SwiftUI
import Relux

public extension View {
    /// Creates a view that resolves and provides a Relux instance.
    ///
    /// This modifier wrap a view into a resolver that manages the asynchronous loading of a Relux instance.
    /// It displays the parent view as a splash screen while Relux is being resolved,
    /// then switches to the content view once Relux is available.
    ///
    /// - Parameters:
    ///   - content: A view builder closure that takes the resolved Relux instance and returns the content view.
    ///   - resolver: An asynchronous closure that resolves and returns the Relux instance.
    /// - Returns: A view that handles the resolution of Relux and displays the appropriate content.
    func resolvedRelux<Content: View>(
        @ViewBuilder content: @escaping (Relux) -> Content,
        resolver: @escaping () async -> Relux
    ) -> some View {
        Relux.Resolver(
            splash: { self },
            content: content,
            resolver: resolver
        )
    }
}



extension Relux {
    /// A view that handles the resolution of a Relux instance and displays appropriate content.
    ///
    /// `Resolver` manages the lifecycle of asynchronously loading a Relux instance:
    /// 1. Initially displays a splash view while resolving the Relux instance
    /// 2. Once resolved, displays the content view and injects Relux observables into the environment
    public struct Resolver<Splash: View, Content: View>: View {
        @SwiftUI.State private var resolved: Relux?

        private let splash: Splash
        private let content: (Relux) -> Content
        private let resolver: () async -> Relux

        /// Creates a new Resolver that handles Relux resolution.
        ///
        /// - Parameters:
        ///   - splash: A view builder closure that returns the splash view to display while resolving.
        ///   - content: A view builder closure that takes the resolved Relux instance and returns the content view.
        ///   - resolver: An asynchronous closure that resolves and returns the Relux instance.
        public init(
            @ViewBuilder splash: @escaping () -> Splash,
            @ViewBuilder content: @escaping (Relux) -> Content,
            resolver: @escaping () async -> Relux
        ) {
            self.splash = splash()
            self.content = content
            self.resolver = resolver
        }

        /// Creates a new Resolver that handles Relux resolution.
        ///
        /// - Parameters:
        ///   - splash: A view builder closure that returns the splash view to display while resolving.
        ///   - content: A view builder closure that takes the resolved Relux instance and returns the content view.
        ///   - resolver: An asynchronous closure that resolves and returns the Relux instance.
        public var body: some View {
            VStack {
                switch resolved {
                    case .none:
                        splash
                            .task {
                                self.resolved = await resolver()
                            }
                    case let .some(relux):
                        content(relux)
                            .passingObservableToEnvironment(fromStore: relux.store)
                }
            }
        }
    }
}
