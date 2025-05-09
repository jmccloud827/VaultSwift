import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Kubernetes secret engine.
    struct KubernetesClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `KubernetesClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Kubernetes client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `KubernetesClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Kubernetes client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Retrieves credentials for the specified role using the provided request.
        ///
        /// - Parameters:
        ///   - role: The role to retrieve credentials for.
        ///   - request: The `CredentialsRequest` instance containing the request details.
        /// - Returns: A `VaultResponse` containing the credentials response.
        /// - Throws: An error if the request fails or the role is empty.
        public func getCredentialsFor(role: String, request: CredentialsRequest) async throws -> VaultResponse<CredentialsResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Kubernetes client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Kubernetes client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Kubernetes engine (default is `kubernetes`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.kubernetes.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `KubernetesClient` with the specified configuration.
    ///
    /// - Parameter config: The `KubernetesClient.Config` instance.
    /// - Returns: A new `KubernetesClient` instance.
    func buildKubernetesClient(config: KubernetesClient.Config) -> KubernetesClient {
        .init(config: config, client: client)
    }
}
