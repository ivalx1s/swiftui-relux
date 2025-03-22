import SwiftUI
import Relux
@_exported import ReluxRouter

public extension View {
    @MainActor
    func passingObservableToEnvironment(fromStore store: Relux.Store) -> some View {
        var view: any View = self

        let uistates = store
            .states
            .values
            .map { $0 as Any }

        passToEnvironment(inView: &view, objects: uistates)

        return AnyView(view)
    }


    @MainActor
    private func passToEnvironment(inView view: inout any View, objects: [Any]) {
        objects
            .forEach { object in
                if let observableObj = object as? (any ObservableObject) {
                    debugPrint("[ReluxRootView] passing \(observableObj) as ObservableObject to SwiftUI environment")
                    view = view.environmentObject(observableObj)
                }

                if #available(iOS 17, *) {
                    if let observable = object as? (any Observable & AnyObject) {
                        debugPrint("[ReluxRootView] passing \(observable) as Observable to SwiftUI environment")
                        view = view.environment(observable)
                    }
                }
            }
    }
}
