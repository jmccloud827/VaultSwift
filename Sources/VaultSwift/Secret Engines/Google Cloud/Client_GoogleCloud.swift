import Foundation

public extension Vault.SecretEngines {
    struct GoogleCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func getOAuth2Token(roleset: String) async throws -> VaultResponse<Token> {
            guard !roleset.isEmpty else {
                throw VaultError(error: "Roleset must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/token", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getServiceAccountKey(roleset: String,
                                         algorithm: ServiceAccountKey.AlgorithmType = .unspecified,
                                         privateKey: ServiceAccountKey.PrivateKeyType = .googleCredentials,
                                         timeToLive: String = "") async throws -> VaultResponse<ServiceAccountKey> {
            guard !roleset.isEmpty else {
                throw VaultError(error: "Roleset must not be empty")
            }
            
            let request = [
                "key_algorithm": algorithm.rawValue,
                "key_type": privateKey.rawValue,
                "ttl": timeToLive
            ]
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/key", httpMethod: .get, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.googleCloud.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildGoogleCloudClient(config: GoogleCloudClient.Config) -> GoogleCloudClient {
        .init(config: config, client: client)
    }
}
