//
//  ViewAction.swift
//  swiftui-relux
//
//  Created by Ivan Oparin on 09.12.2025.
//


// MARK: - Modern Implementation of ViewCallbacks with parameter packs in generic parameters (iOS 17+)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension Relux.UI {
    struct ViewAction<each Input: Sendable>: Sendable, Equatable, Identifiable {
        
        public struct CallSite: Hashable, Sendable {
            let file: String
            let function: String
            let line: UInt
            
            public init(file: String, function: String, line: UInt) {
                self.file = file; self.function = function; self.line = line
            }
        }
        
        public let id: CallSite
        
        // ✨ The Magic: Storing the parameter pack directly
        private let action: @Sendable (repeat each Input) async -> Void
        
        public init(
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line,
            _ action: @escaping @Sendable (repeat each Input) async -> Void
        ) {
            self.id = CallSite(file: file, function: function, line: line)
            self.action = action
        }
        
        public func callAsFunction(_ input: repeat each Input) async {
            await action(repeat each input)
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
