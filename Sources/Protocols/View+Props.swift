import SwiftUI

public protocol ViewProps: DynamicProperty, Equatable, Hashable, Sendable {}

public protocol ViewActions: Sendable {}
