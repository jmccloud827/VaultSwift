import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Google Cloud secret engine.
    struct GoogleCloudClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `GoogleCloudClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Google Cloud client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `GoogleCloudClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Google Cloud client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Generates an OAuth2 token with the scopes defined on the roleset.
        /// This OAuth access token can be used in GCP API calls.
        /// Tokens are non-renewable and have a TTL of an hour by default.
        ///
        /// - Parameter roleset: The roleset to retrieve the token for.
        /// - Returns: A `VaultResponse` containing the token.
        /// - Throws: An error if the request fails or the roleset is empty.
        public func getOAuth2Token(roleset: String) async throws -> VaultResponse<Token> {
            guard !roleset.isEmpty else {
                throw VaultError(error: "Roleset must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/token", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Generates a service account key.
        /// These keys are renewable and have TTL/max TTL as defined by either the backend config or the
        /// system default if config was not defined.
        ///
        /// - Parameters:
        ///   - roleset: The roleset to retrieve the service account key for.
        ///   - algorithm: The algorithm type for the service account key (default is `._2048`).
        ///   - privateKey: The private key type for the service account key (default is `.googleCredentials`).
        ///   - timeToLive: The time to live for the service account key (default is an empty string).
        /// - Returns: A `VaultResponse` containing the service account key.
        /// - Throws: An error if the request fails or the roleset is empty.
        public func getServiceAccountKey(roleset: String,
                                         algorithm: ServiceAccountKey.AlgorithmType = ._2048,
                                         privateKey: ServiceAccountKey.PrivateKeyType = .googleCredentials,
                                         timeToLive: String = "") async throws -> VaultResponse<ServiceAccountKey> {
            guard !roleset.isEmpty else {
                throw VaultError(error: "Roleset must not be empty")
            }
            
            let request = [
                "key_algorithm": algorithm.rawValue,
                "key_type": privateKey.rawValue,
                "ttl": timeToLive
            ]
            
            return try await client.makeCall(path: config.mount + "/roleset/" + roleset.trim() + "/key", httpMethod: .get, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Google Cloud client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Google Cloud client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Google Cloud engine (default is `google-cloud`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.googleCloud.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `GoogleCloudClient` with the specified configuration.
    ///
    /// - Parameter config: The `GoogleCloudClient.Config` instance.
    /// - Returns: A new `GoogleCloudClient` instance.
    func buildGoogleCloudClient(config: GoogleCloudClient.Config) -> GoogleCloudClient {
        .init(config: config, client: client)
    }
}
