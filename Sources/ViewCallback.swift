
public extension Relux.UI {
    struct ViewCallback: Sendable, Equatable, Identifiable {
        public struct CallSite: Hashable, Sendable {
            let file: String
            let function: String
            let line: UInt
            
            public init(file: String, function: String, line: UInt) {
                self.file = file
                self.function = function
                self.line = line
            }
        }
        
        public let id: CallSite
        private let action: @Sendable () async -> Void
        
        public init(
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line,
            _ action: @escaping @Sendable () async -> Void
        ) {
            self.id = .init(file: file, function: function, line: line)
            self.action = action
        }
        
        public func callAsFunction() async {
            await action()
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
