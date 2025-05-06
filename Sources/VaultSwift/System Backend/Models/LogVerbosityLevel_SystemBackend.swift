import Foundation

public extension Vault.SystemBackend {
    enum LogVerbosityLevel: String, Encodable, Sendable {
        case trace
        case debug
        case notice
        case info
        case warn
        case warning
        case error
        case err
    }
}
