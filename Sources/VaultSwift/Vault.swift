import Foundation

public struct Vault {
    let client: Client
    
    public struct Config {
        let baseURI: String
        let namespace: String?
        let authProvider: (any AuthProvider)?
        
        public init(baseURI: String, namespace: String, authProvider: AuthProviders) {
            self.init(baseURI: baseURI,
                      namespace: namespace,
                      authProvider: authProvider.asAuthProvider(client: .init(config: .init(baseURI: baseURI, namespace: nil, authProvider: nil))))
        }
        
        init(baseURI: String, namespace: String?, authProvider: (any AuthProvider)?) {
            self.baseURI = baseURI
            self.namespace = namespace
            self.authProvider = authProvider
        }
    }
    
    public init(config: Config) {
        self.client = .init(config: .init(baseURI: config.baseURI, namespace: config.namespace, authProvider: config.authProvider))
    }
}
