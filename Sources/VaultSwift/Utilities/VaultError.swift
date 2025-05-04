import Foundation

public struct VaultError: LocalizedError {
    public let error: String
    public let statusCode: Int?
    
    public init(error: String, statusCode: Int? = nil) {
        self.error = error
        self.statusCode = statusCode
    }
    
    public var errorDescription: String? {
        "Vault Error: " + error
    }
}
