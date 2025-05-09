import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Transform secret engine.
    struct TransformClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `TransformClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Transform client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `TransformClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Transform client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Encodes data using the specified role.
        ///
        /// - Parameters:
        ///   - role: The role to use for encoding.
        ///   - options: The `CodingOptions` instance containing the encoding options.
        /// - Returns: A `VaultResponse` containing the encode response.
        /// - Throws: An error if the request fails or the role is empty.
        public func encode(role: String, options: CodingOptions) async throws -> VaultResponse<EncodeResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/encode/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Decodes data using the specified role.
        ///
        /// - Parameters:
        ///   - role: The role to use for decoding.
        ///   - options: The `CodingOptions` instance containing the decoding options.
        /// - Returns: A `VaultResponse` containing the decode response.
        /// - Throws: An error if the request fails or the role is empty.
        public func decode(role: String, options: CodingOptions) async throws -> VaultResponse<DecodeResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/decode/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Transform client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Transform client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Transform engine (default is `transform`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.transform.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `TransformClient` with the specified configuration.
    ///
    /// - Parameter config: The `TransformClient.Config` instance.
    /// - Returns: A new `TransformClient` instance.
    func buildTransformClient(config: TransformClient.Config) -> TransformClient {
        .init(config: config, client: client)
    }
}
