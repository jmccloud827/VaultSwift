import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault MongoDB Atlas secret engine.
    struct MongoDBAtlasClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `MongoDBAtlasClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the MongoDB Atlas client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `MongoDBAtlasClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the MongoDB Atlas client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Retrieves credentials for the specified role.
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
        
        /// Configuration for the MongoDB Atlas client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the MongoDB Atlas client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the MongoDB Atlas engine (default is `mongodb-atlas`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.mongoDBAtlas.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `MongoDBAtlasClient` with the specified configuration.
    ///
    /// - Parameter config: The `MongoDBAtlasClient.Config` instance.
    /// - Returns: A new `MongoDBAtlasClient` instance.
    func buildMongoDBAtlasClient(config: MongoDBAtlasClient.Config) -> MongoDBAtlasClient {
        .init(config: config, client: client)
    }
}
