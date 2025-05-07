import Foundation

public extension Vault.SecretEngines {
    struct AzureClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func getCredentialsFor(role: String) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.azure.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildAzureClient(config: SecretEngines.AzureClient.Config) -> SecretEngines.AzureClient {
        .init(config: config, client: client)
    }
}
