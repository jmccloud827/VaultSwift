import Foundation

public extension Vault.SecretEngines {
    struct TransformClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func encode(role: String, options: CodingOptions) async throws(VaultError) -> VaultResponse<EncodeResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/encode/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func decode(role: String, options: CodingOptions) async throws(VaultError) -> VaultResponse<DecodeResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/decode/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.transform.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildTransformClient(config: SecretEngines.TransformClient.Config) -> SecretEngines.TransformClient {
        .init(config: config, client: client)
    }
}
