import Foundation

public extension Vault.SecretEngines {
    struct KeyManagementClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func get(key: String) async throws(VaultError) -> VaultResponse<Key> {
            guard !key.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func get(key: String, inKMS kms: String) async throws(VaultError) -> VaultResponse<KMSKey> {
            guard !key.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            guard !kms.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/kms/" + kms.trim() + "/key/" + key.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.keyManagement.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildKeyManagementClient(config: SecretEngines.KeyManagementClient.Config) -> SecretEngines.KeyManagementClient {
        .init(config: config, client: client)
    }
}
