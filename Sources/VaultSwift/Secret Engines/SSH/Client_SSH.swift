import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault SSH secret engine.
    struct SSHClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `SSHClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the SSH client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `SSHClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the SSH client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Generates a dynamic SSH credentials for a specific username and IP Address based on the named role.
        ///
        /// - Parameters:
        ///   - role: The role to retrieve credentials for.
        ///   - ipAddress: The IP address to retrieve credentials for.
        ///   - username: The username to retrieve credentials for (optional).
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails, the role is empty, or the IP address is empty.
        public func getCredentialsFor(role: String, ipAddress: String, username: String? = nil) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            guard !ipAddress.isEmpty else {
                throw VaultError(error: "IP Address must not be empty")
            }
            
            let request = [
                "ip": ipAddress,
                "username": username
            ]
            
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint signs an SSH public key based on the supplied parameters,
        /// subject to the restrictions contained in the role named in the endpoint.
        ///
        /// - Parameters:
        ///   - role: The role to sign the key for.
        ///   - data: The `SignKeyRequest` instance containing the key sign data.
        /// - Returns: A `VaultResponse` containing the sign key response.
        /// - Throws: An error if the request fails or the role is empty.
        public func signKeyFor(role: String, data: SignKeyRequest) async throws -> VaultResponse<SignKeyResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/sign/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Configuration for the SSH client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the SSH client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the SSH engine (default is `ssh`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.ssh.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `SSHClient` with the specified configuration.
    ///
    /// - Parameter config: The `SSHClient.Config` instance.
    /// - Returns: A new `SSHClient` instance.
    func buildSSHClient(config: SSHClient.Config) -> SSHClient {
        .init(config: config, client: client)
    }
}
