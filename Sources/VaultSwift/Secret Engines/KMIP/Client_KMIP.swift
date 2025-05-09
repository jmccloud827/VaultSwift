import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault KMIP (Key Management Interoperability Protocol) secret engine.
    struct KMIPClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `KMIPClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KMIP client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `KMIPClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the KMIP client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Retrieves credentials for the specified role and scope using the provided certificate format.
        ///
        /// - Parameters:
        ///   - role: The role to retrieve credentials for.
        ///   - scope: The scope to retrieve credentials for.
        ///   - certificateFormat: The format of the certificate.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails, the role is empty, or the scope is empty.
        public func getCredentialsFor(role: String, scope: String, certificateFormat: CertificateFormat) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !scope.isEmpty else {
                throw VaultError(error: "Scope must not be empty")
            }
            
            let request = ["format": certificateFormat.rawValue]
            
            return try await client.makeCall(path: config.mount + "/scope/" + scope.trim() + "/role/" + role.trim() + "/credential/generate", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Certificate format options for the KMIP client.
        public enum CertificateFormat: String {
            case empty
            case der
            case pem
            case pemBundle = "pem_bundle"
        }
        
        /// Configuration for the KMIP client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the KMIP client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the KMIP engine (default is `kmip`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.kmip.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `KMIPClient` with the specified configuration.
    ///
    /// - Parameter config: The `KMIPClient.Config` instance.
    /// - Returns: A new `KMIPClient` instance.
    func buildKMIPClient(config: KMIPClient.Config) -> KMIPClient {
        .init(config: config, client: client)
    }
}
