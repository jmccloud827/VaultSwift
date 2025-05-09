import Foundation

public extension Vault.SecretEngines {
    struct TerraformClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.terraform.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildTerraformClient(config: TerraformClient.Config) -> TerraformClient {
        .init(config: config, client: client)
    }
}
