import Foundation

/// A container for interaction with various Vault functionalities.
public struct Vault {
    /// A client for interacting with the system backend.
    public lazy var systemsBackendClient = SystemBackend.Client(client: client)
    
    /// A client for interacting with secret engines.
    public lazy var secretEngines = SecretEngines(client: client)
    
    /// A client for interacting with authentication providers.
    public lazy var authProviders = AuthProviders(client: client)
    
    private let client: Client
    
    /// Initializes a new `Vault` instance with the specified configuration.
    ///
    /// - Parameter config: The configuration for the Vault.
    public init(config: Config) {
        self.client = .init(config: .init(baseURI: config.baseURI, namespace: config.namespace, authProvider: config.authProvider))
    }
    
    /// Configuration for initializing `Vault`.
    public struct Config {
        /// The base URI for the Vault.
        public let baseURI: String
        
        /// The namespace for Vault. Optional.
        public let namespace: String?
        
        /// The token provider for authentication. Optional.
        let authProvider: (any AuthProviders.TokenProvider)?
        
        /// Initializes a new `Config` instance.
        ///
        /// - Parameters:
        ///   - baseURI: The base URI for Vault.
        ///   - namespace: The namespace for Vault.
        ///   - authProvider: The token provider for authentication.
        public init(baseURI: String, namespace: String, authProvider: AuthProviders.TokenProviders) {
            self.init(baseURI: baseURI,
                      namespace: namespace,
                      authProvider: authProvider.asTokenProvider(client: .init(config: .init(baseURI: baseURI, namespace: nil, authProvider: nil))))
        }
        
        /// Internal initializer for `Config`.
        ///
        /// - Parameters:
        ///   - baseURI: The base URI for Vault.
        ///   - namespace: The namespace for Vault.
        ///   - authProvider: The token provider for authentication. Optional.
        init(baseURI: String, namespace: String?, authProvider: (any AuthProviders.TokenProvider)?) {
            self.baseURI = baseURI
            self.namespace = namespace
            self.authProvider = authProvider
        }
    }
}
