import Foundation

public extension Vault.SystemBackend {
    /// A client for interacting with multi-factor authentication (MFA) features of a Vault instance.
    struct MFAClient {
        /// A client for interacting with Duo.
        public lazy var duoClient = DuoClient(client: client)
        
        /// A client for interacting with Okta.
        public lazy var oktaClient = OktaClient(client: client)
        
        /// A client for interacting with PingID.
        public lazy var pingIDClient = PingIDClient(client: client)
        
        /// A client for interacting with TOTP.
        public lazy var totpClient = TOTPClient(client: client)
        
        private let client: Vault.Client
            
        /// Initializes a new `MFAClient` instance with the specified Vault client.
        ///
        /// - Parameter client: The Vault client.
        init(client: Vault.Client) {
            self.client = client
        }
        
        /// A protocol defining the base client requirements for MFA methods.
        public protocol BaseClient {
            var basePath: String { get }
            var client: Vault.Client { get }
            
            associatedtype Config: Codable, Sendable
        }
    }
}

public extension Vault.SystemBackend.MFAClient.BaseClient {
    /// Writes the configuration for an MFA method.
    ///
    /// - Parameters:
    ///   - config: The configuration to write.
    ///   - name: The name of the MFA method.
    func write(config: Config, forName name: String) async throws {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .post, request: config, wrapTimeToLive: nil)
    }
    
    /// Retrieves the configuration for an MFA method.
    ///
    /// - Parameter name: The name of the MFA method.
    /// - Returns: A `VaultResponse` containing the configuration.
    func getConfigFor(name: String) async throws -> VaultResponse<Config> {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .get, wrapTimeToLive: nil)
    }
    
    /// Deletes the configuration for an MFA method.
    ///
    /// - Parameter name: The name of the MFA method.
    func deleteConfigFor(name: String) async throws {
        try await client.makeCall(path: basePath + "v1/sys/mfa/method/" + basePath + "/" + name.trim(), httpMethod: .delete, wrapTimeToLive: nil)
    }
}
