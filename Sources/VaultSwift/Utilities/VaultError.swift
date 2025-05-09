import Foundation

/// A structure representing an error that can occur in the Vault system.
public struct VaultError: LocalizedError {
    /// A description of the error.
    public let error: String
    
    /// The status code associated with the error, if any.
    public let statusCode: Int?
    
    /// Initializes a new `VaultError` instance with the specified error message and optional status code.
    ///
    /// - Parameters:
    ///   - error: A description of the error.
    ///   - statusCode: The status code associated with the error. Optional.
    public init(error: String, statusCode: Int? = nil) {
        self.error = error
        self.statusCode = statusCode
    }
    
    /// A localized description of the error.
    public var errorDescription: String? {
        "Vault Error: " + error
    }
}
