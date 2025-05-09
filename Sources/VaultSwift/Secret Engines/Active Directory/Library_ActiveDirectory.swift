import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault Active Directory Library secret engine.
    struct ActiveDirectoryLibrary: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `ActiveDirectoryLibrary` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Active Directory Library client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `ActiveDirectoryLibrary` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the Active Directory Library client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Writes the sets of service accounts that Vault will offer for check-out.
        /// When adding a service account to the library, Vault verifies it already exists in Active Directory.
        ///
        /// - Parameters:
        ///   - serviceAccountSet: The name of the service account set.
        ///   - data: The `ServiceAccountSet` instance containing the service account set data.
        /// - Throws: An error if the request fails or the service account set name is empty.
        public func write(serviceAccountSet: String, data: ServiceAccountSet) async throws {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// Retrieves a service account set from the Active Directory Library engine.
        ///
        /// - Parameter serviceAccountSet: The name of the service account set.
        /// - Returns: A `VaultResponse` containing the service account set data.
        /// - Throws: An error if the request fails or the service account set name is empty.
        public func get(serviceAccountSet: String) async throws -> VaultResponse<ServiceAccountSet> {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all service account sets from the Active Directory Library engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all service account sets.
        /// - Throws: An error if the request fails.
        public func getAllServiceAccountSets() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/library", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a service account set from the Active Directory Library engine.
        ///
        /// - Parameter serviceAccountSet: The name of the service account set to delete.
        /// - Throws: An error if the request fails or the service account set name is empty.
        public func delete(serviceAccountSet: String) async throws {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Checks out credentials for a service account set from the Active Directory Library engine.
        ///
        /// - Parameters:
        ///   - serviceAccountSet: The name of the service account set.
        ///   - timeToLive: The maximum amount of time a check-out lasts before Vault automatically checks it back in. Setting it to zero reflects an unlimited lending period. Defaults to the set's ttl. If the requested ttl is higher than the set's, the set's will be used.
        /// - Returns: A `VaultResponse` containing the checked-out service account set credentials.
        /// - Throws: An error if the request fails.
        public func checkOutCredentialsFor(serviceAccountSet: String, timeToLive: Int? = nil) async throws -> VaultResponse<ServiceAccountSetCredentials> {
            let request = ["ttl": timeToLive]
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim() + "/check-out", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Checks in a checked out credential.
        /// By default, check-in must be called by the same entity or client token used for check-out.
        /// If a caller attempts to check in a service account they're not authorized to check in,
        /// they will receive an error response. If they attempt to check in a service account
        /// they are authorized to check in, but it's already checked in, they will receive a
        /// successful response but the account will not be included in the checkIns listed.
        /// checkIns shows which service accounts were checked in by this particular call.
        ///
        /// - Parameters:
        ///   - serviceAccountSet: The name of the service account set.
        ///   - serviceAccounts: The service account names to check in (optional).
        /// - Returns: A `VaultResponse` containing the check-in response.
        /// - Throws: An error if the request fails.
        public func checkInCredentialsFor(serviceAccountSet: String, serviceAccounts: [String]? = nil) async throws -> VaultResponse<CheckInServiceAccountSetCredentialsResponse> {
            let request = ["service_account_names": serviceAccounts]
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim() + "/check-in", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Force checks in a checked out credential.
        /// Access to this endpoint should only be granted to highly privileged Vault users,
        /// like Vault operators.
        /// If they attempt to check in a service account
        /// they are authorized to check in, but it's already checked in, they will receive a
        /// successful response but the account will not be included in the checkIns listed.
        /// checkIns shows which service accounts were checked in by this particular call.
        ///
        /// - Parameters:
        ///   - serviceAccountSet: The name of the service account set.
        ///   - serviceAccounts: The service account names to force check in (optional).
        /// - Returns: A `VaultResponse` containing the force check-in response.
        /// - Throws: An error if the request fails.
        public func forceCheckInCredentialsFor(serviceAccountSet: String, serviceAccounts: [String]? = nil) async throws -> VaultResponse<CheckInServiceAccountSetCredentialsResponse> {
            let request = ["service_account_names": serviceAccounts]
            
            return try await client.makeCall(path: self.config.mount + "/library/manage/" + serviceAccountSet.trim() + "/check-in", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Configuration for the Active Directory Library client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the Active Directory Library client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the Active Directory Library engine (default is `ad`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.activeDirectory.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `ActiveDirectoryLibrary` client with the specified configuration.
    ///
    /// - Parameter config: The `ActiveDirectoryLibrary.Config` instance.
    /// - Returns: A new `ActiveDirectoryLibrary` instance.
    func buildActiveDirectoryLibrary(config: ActiveDirectoryLibrary.Config) -> ActiveDirectoryLibrary {
        .init(config: config, client: client)
    }
}
