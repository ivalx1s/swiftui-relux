
public extension Relux.UI {
    struct ViewInputCallback<Input: Sendable>: Sendable, Equatable, Identifiable {
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
        private let action: @Sendable (Input) async -> Void

        public init(
            file: String = #fileID,
            function: String = #function,
            line: UInt = #line,
            _ action: @escaping @Sendable (Input) async -> Void
        ) {
            self.id = CallSite(file: file, function: function, line: line)
            self.action = action
        }

        public func callAsFunction(_ input: Input) async {
            await action(input)
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
}
