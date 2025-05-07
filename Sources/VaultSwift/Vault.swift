import Foundation

public struct Vault {
    let client: Client
    public let systemsBackendClient: SystemBackend.Client
    
    public init(config: Config) {
        let client = Client(config: .init(baseURI: config.baseURI, namespace: config.namespace, authProvider: config.authProvider))
        self.client = client
        self.systemsBackendClient = .init(client: client)
    }
    
    public struct Config {
        let baseURI: String
        let namespace: String?
        let authProvider: (any AuthProviders.TokenProvider)?
        
        public init(baseURI: String, namespace: String, authProvider: AuthProviders.TokenProviders) {
            self.init(baseURI: baseURI,
                      namespace: namespace,
                      authProvider: authProvider.asTokenProvider(client: .init(config: .init(baseURI: baseURI, namespace: nil, authProvider: nil))))
        }
        
        init(baseURI: String, namespace: String?, authProvider: (any AuthProviders.TokenProvider)?) {
            self.baseURI = baseURI
            self.namespace = namespace
            self.authProvider = authProvider
        }
    }
}

// TODO: Check guard error messages
// TODO: Convert jsonanys to generics
// TODO: Auth Method clients
// TODO: MFA clients
