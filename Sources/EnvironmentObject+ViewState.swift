import SwiftUI
import Relux
@_exported import ReluxRouter

public extension View {
    /// Injects observable states and relays from the store into the SwiftUI environment.
    /// - Parameter store: The Relux store containing UI states and relays.
    /// - Returns: A view with states and relays injected as environment objects.
    @MainActor
    func passingObservableToEnvironment(fromStore store: Relux.Store) -> some View {
        var view: any View = self
        
        let observables: [Any] =
        store.uiStates.values.map { $0 } +
        store.relays.values.map { $0 } +
        store.actionRelays.values.map { $0 }
        
        passToEnvironment(inView: &view, objects: observables)

        return AnyView(view)
    }

    @MainActor
    private func passToEnvironment(inView view: inout any View, objects: [Any]) {
        if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
            passEnvironmentObjectsAndObservables(inView: &view, objects: objects)
        } else {
            passEnvironmentObjectsOnly(inView: &view, objects: objects)
        }
    }


    @MainActor
    @available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
    private func passEnvironmentObjectsOnly(inView view: inout any View, objects: [Any]) {
        objects.forEach { object in
            if let observableObj = object as? (any ObservableObject) {
                debugPrint("[ReluxRootView] passing \(observableObj) as ObservableObject to SwiftUI environment")
                view = view.environmentObject(observableObj)
            }
        }
    }


    @MainActor
    @available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
    private func passEnvironmentObjectsAndObservables(inView view: inout any View, objects: [Any]) {
        objects.forEach { object in
            if let observableObj = object as? (any ObservableObject) {
                debugPrint("[ReluxRootView] passing \(observableObj) as ObservableObject to SwiftUI environment")
                view = view.environmentObject(observableObj)
            }

            if let observable = object as? (any Observable & AnyObject) {
                debugPrint("[ReluxRootView] passing \(observable) as Observable to SwiftUI environment")
                view = view.environment(observable)
            }
        }
    }
}
