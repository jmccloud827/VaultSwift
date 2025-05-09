import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Terraform secret engine.
    struct TerraformClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `TerraformClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Terraform client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `TerraformClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Terraform client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Returns a Terraform Cloud token based on the given role definition.
        /// For Organization and Team roles, the same API token is returned until
        /// the token is rotated with rotate-role.
        /// For User roles, a new token is generated with each request.
        ///
        /// - Parameter role: The role to retrieve credentials for.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails or the role is empty.
        public func getCredentialsFor(role: String) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Terraform client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Terraform client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Terraform engine (default is `terraform`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.terraform.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `TerraformClient` with the specified configuration.
    ///
    /// - Parameter config: The `TerraformClient.Config` instance.
    /// - Returns: A new `TerraformClient` instance.
    func buildTerraformClient(config: TerraformClient.Config) -> TerraformClient {
        .init(config: config, client: client)
    }
}
