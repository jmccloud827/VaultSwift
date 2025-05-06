import Foundation

public extension Vault.KeyManagement {
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
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.keyManagement.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum KeyManagement {}
    
    func buildKeyManagementClient(config: KeyManagement.Client.Config) -> KeyManagement.Client {
        .init(config: config, client: client)
    }
}
