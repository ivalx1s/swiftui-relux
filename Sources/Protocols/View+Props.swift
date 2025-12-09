import SwiftUI

@available(*, deprecated, message: "Use Relux.UI.ViewProps instead", renamed: "Relux.UI.ViewProps")
public protocol ViewProps: DynamicProperty, Equatable, Hashable, Sendable {}

@available(*, deprecated, message: "Use Relux.UI.ViewCallbacks instead", renamed: "Relux.UI.ViewCallbacks")
public protocol ViewActions: Sendable {}
