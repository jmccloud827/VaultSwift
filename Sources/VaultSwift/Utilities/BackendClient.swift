import Foundation

/// A protocol defining the requirements for a backend client.
public protocol BackendClient {
    /// The configuration for the backend client.
    var config: Config { get }
        
    /// Initializes a new instance of the backend client with the specified configuration.
    ///
    /// - Parameters:
    ///   - config: The configuration for the backend client.
    ///   - vaultConfig: The configuration for the Vault.
    init(config: Config, vaultConfig: Vault.Config)
    
    /// The type of configuration used by the backend client.
    associatedtype Config
}
