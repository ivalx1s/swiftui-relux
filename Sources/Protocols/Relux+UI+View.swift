import Relux
import SwiftUI

public extension Relux.UI {
    @MainActor
    protocol View: SwiftUI.View & Equatable {
        associatedtype Props = Relux.UI.ViewProps
        associatedtype ViewCallbacks = Relux.UI.ViewCallbacks
        
        nonisolated var props: Props { get }
//        var callbacks: ViewCallbacks { get }
    }
}


public extension Relux.UI.View where Props: Equatable {
    
    nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.props == rhs.props
    }
}
