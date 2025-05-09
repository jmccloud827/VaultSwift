import Foundation

public extension Vault.SecretEngines {
    struct KeyManagementClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func get<T: Decodable & Sendable>(key: String) async throws -> VaultResponse<Key<T>> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get(key: String, inKMS kms: String) async throws -> VaultResponse<KMSKey> {
            guard !key.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            guard !kms.isEmpty else {
                throw VaultError(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/kms/" + kms.trim() + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.keyManagement.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildKeyManagementClient(config: KeyManagementClient.Config) -> KeyManagementClient {
        .init(config: config, client: client)
    }
}
