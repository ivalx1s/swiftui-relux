import SwiftUI
import Relux

extension Relux.UI {
    /// Relays state snapshots to SwiftUI views.
    ///
    /// StateRelay subscribes to a `SnapshotProviding` state's async stream
    /// and republishes snapshots via `@Published` for SwiftUI observation.
    ///
    /// Usage:
    /// ```swift
    /// // In your API module, create a typealias:
    /// public typealias OrientationRelay = Relux.UI.StateRelay<OrientationSnapshot>
    ///
    /// // In views:
    /// @EnvironmentObject var orientation: OrientationRelay
    /// Text("\(orientation.value.someProperty)")
    /// ```
    ///
    /// StateRelay is automatically injected into the SwiftUI environment
    /// when registered via the module's `relays` property.
    @MainActor
    public final class StateRelay<T: Relux.StateSnapshot>: Relux.StateRelaying, ObservableObject {
        public typealias Snapshot = T

        /// The current snapshot value.
        @Published public private(set) var value: T

        private var task: Task<Void, Never>?

        /// Creates a relay from any SnapshotProviding source.
        /// - Parameter source: The state that provides snapshots.
        public init<S: SnapshotProviding>(_ source: S) where S.Snapshot == T {
            self.value = source.current
            self.task = Task { [weak self] in
                for await snapshot in source.snapshots {
                    guard !Task.isCancelled else { break }
                    await MainActor.run {
                        guard let self = self else { return }
                        if self.value != snapshot {
                            self.value = snapshot
                        }
                    }
                }
            }
        }

        /// Creates a relay with an initial value and async stream.
        /// - Parameters:
        ///   - initial: The initial snapshot value.
        ///   - stream: An async stream of snapshot updates.
        public init(initial: T, stream: AsyncStream<T>) {
            self.value = initial
            self.task = Task { [weak self] in
                for await snapshot in stream {
                    guard !Task.isCancelled else { break }
                    await MainActor.run {
                        guard let self = self else { return }
                        if self.value != snapshot {
                            self.value = snapshot
                        }
                    }
                }
            }
        }

        deinit {
            task?.cancel()
        }
    }
}
