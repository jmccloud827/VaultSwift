import Foundation

public extension Vault.SecretEngines {
    struct CubbyholeClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func get(secret: String) async throws(VaultError) -> VaultResponse<[String: JSONAny]> {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim() + "/", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func listSecretPathsFrom(path: String) async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/" + path.trim() + "/", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(secret: String, values: [String: JSONAny]) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .post, request: values, wrapTimeToLive: nil)
        }
        
        public func delete(secret: String) async throws(VaultError) {
            guard !secret.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: config.mount + "/" + secret.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.cubbyhole.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildCubbyholeClient(config: SecretEngines.CubbyholeClient.Config) -> SecretEngines.CubbyholeClient {
        .init(config: config, client: client)
    }
}
