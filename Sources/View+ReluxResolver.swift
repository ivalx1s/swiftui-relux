import SwiftUI
import Relux

public extension View {
    /*
     view invocer behaves as simple splash view without any Relux context
     awaits for relux being resolved and passes it to content view builder
     also passes observables from relux store to environment of the content view
     */
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
    /*
     awaits for relux being resolved and passes it to content view builder
     also passes observables from relux store to environment of the content view
     splash view behaves as simple splash view without any Relux context
     */
    public struct Resolver<Splash: View, Content: View>: View {
        @SwiftUI.State private var resolved: Relux?

        @ViewBuilder private let splash: () -> Splash
        @ViewBuilder private let content: (Relux) -> Content
        private let resolver: () async -> Relux

        init(
            @ViewBuilder splash: @escaping () -> Splash,
            @ViewBuilder content: @escaping (Relux) -> Content,
            resolver: @escaping () async -> Relux
        ) {
            self.splash = splash
            self.content = content
            self.resolver = resolver
        }

        public var body: some View {
            VStack {
                switch resolved {
                    case .none:
                        splash()
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
