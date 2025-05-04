import Foundation

public extension Vault.GoogleCloud {
    struct Client {
        private let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func getOAuth2Token(roleset: String) async throws(VaultError) -> VaultResponse<Token> {
            guard !roleset.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/token", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getServiceAccountKey(roleset: String,
                                         algorithm: ServiceAccountKey.AlgorithmType = .unspecified,
                                         privateKey: ServiceAccountKey.PrivateKeyType = .googleCredentials,
                                         timeToLive: String = "") async throws(VaultError) -> VaultResponse<ServiceAccountKey> {
            guard !roleset.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            let request = [
                "key_algorithm": algorithm.rawValue,
                "key_type": privateKey.rawValue,
                "ttl": timeToLive
            ]
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/key", httpMethod: .get, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String?, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? "gcp")
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum GoogleCloud {}
    
    func buildGoogleCloudClient(config: GoogleCloud.Client.Config) -> GoogleCloud.Client {
        .init(config: config, client: client)
    }
}
