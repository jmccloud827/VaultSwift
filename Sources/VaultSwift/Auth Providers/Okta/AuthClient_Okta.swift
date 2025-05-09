import Foundation

public extension Vault.AuthProviders {
    /// A client for interacting with the Vault Okta authentication method.
    struct OktaClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        private let basePath = "v1/auth"
        
        /// Initializes a new `OktaClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Okta client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.config = config
            self.client = .init(config: vaultConfig)
        }
        
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Verifies a push challenge asynchronously.
        ///
        /// - Parameters:
        ///   - nonce: Nonce provided if performing login that requires number verification challenge. Logins through the vault login CLI command will automatically generate a nonce.
        /// - Returns: A `VaultResponse` containing the verification response.
        /// - Throws: An error if the request fails or the nonce is empty.
        public func verifyPushChallengeAsync(nonce: String) async throws -> VaultResponse<VerifyPushChallengeResponse> {
            guard !nonce.isEmpty else {
                throw VaultError(error: "Nonce must not be empty")
            }
            
            return try await client.makeCall(path: basePath + config.mount + "/verify/nonce/" + nonce.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Configuration for the Okta client.
        public struct Config {
            public let mount: String
            
            /// Initializes a new `Config` instance for the Okta client.
            ///
            /// - Parameter mount: The mount path for the Okta engine (default is `okta`).
            public init(mount: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MethodType.okta.rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    /// Builds an `OktaClient` with the specified configuration.
    ///
    /// - Parameter config: The `OktaClient.Config` instance.
    /// - Returns: A new `OktaClient` instance.
    func buildOktaClient(config: OktaClient.Config) -> OktaClient {
        .init(config: config, client: client)
    }
}
