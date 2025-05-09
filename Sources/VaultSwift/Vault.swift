import Foundation

public struct Vault {
    public lazy var systemsBackendClient = SystemBackend.Client(client: client)
    public lazy var secretEngines = SecretEngines(client: client)
    public lazy var authProviders = AuthProviders(client: client)
    private let client: Client
    
    public init(config: Config) {
        self.client = .init(config: .init(baseURI: config.baseURI, namespace: config.namespace, authProvider: config.authProvider))
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
