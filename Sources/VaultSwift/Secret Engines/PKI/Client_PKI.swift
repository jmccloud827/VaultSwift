import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault PKI (Public Key Infrastructure) secret engine.
    struct PKIClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `PKIClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the PKI client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `PKIClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the PKI client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// Generates a new set of credentials (private key and certificate) based on the role named in the endpoint.
        /// The issuing CA certificate is returned as well, so that only the root CA need be in a client's trust store.
        /// The private key is not stored.
        /// If you do not save the private key, you will need to request a new certificate.
        ///
        /// - Parameters:
        ///   - role: The role to retrieve credentials for.
        ///   - options: The `CredentialsOptions` instance containing the options for retrieving credentials.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails or the role is empty.
        public func getCredentialsFor(role: String, options: CredentialsOptions) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/issue/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves a certificate for the specified serial number.
        ///
        /// - Parameter serialNumber: The serial number of the certificate to be retrieved (Example: '17:67:16:b0:b9:45:58:c0:3a:29:e3:cb:d6:98:33:7a:a6:3b:66:c1').
        /// - Returns: A `VaultResponse` containing the certificate.
        /// - Throws: An error if the request fails or the serial number is empty.
        public func getCertificateFor(serialNumber: String) async throws -> VaultResponse<Certificate> {
            guard !serialNumber.isEmpty else {
                throw VaultError(error: "Serial Number must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/cert/" + serialNumber.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint signs a new certificate based upon the provided CSR and the supplied parameters,
        /// subject to the restrictions contained in the role named in the endpoint.
        /// The issuing CA certificate is returned as well, so that only the root CA need be in a client's trust store.
        ///
        /// - Parameters:
        ///   - role: The role to sign the certificate for.
        ///   - options: The `SignCertificateOptions` instance containing the options for signing the certificate.
        /// - Returns: A `VaultResponse` containing the signed certificate.
        /// - Throws: An error if the request fails or the role is empty.
        public func signCertificateFor(role: String, options: SignCertificateOptions) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/sign/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint revokes a certificate using its serial number.
        /// This is an alternative option to the standard method of revoking using Vault lease IDs.
        /// A successful revocation will rotate the CRL.
        ///
        /// - Parameter serialNumber: The serial number of the certificate to revoke.
        /// - Returns: A `VaultResponse` containing the revoked certificate.
        /// - Throws: An error if the request fails or the serial number is empty.
        public func revokeCertificateFor(serialNumber: String) async throws -> VaultResponse<RevokedCertificate> {
            guard !serialNumber.isEmpty else {
                throw VaultError(error: "Serial Number must not be empty")
            }
            
            let request = ["serial_number": serialNumber]
            
            return try await client.makeCall(path: config.mount + "/revoke", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves a list of all certificate keys (serial numbers).
        ///
        /// - Returns: A `VaultResponse` containing all certificates.
        /// - Throws: An error if the request fails.
        public func listAllCertificates() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/certs", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Retrieves a list of all revoked certificate keys (serial numbers).
        ///
        /// - Returns: A `VaultResponse` containing all revoked certificates.
        /// - Throws: An error if the request fails.
        public func listAllRevokedCertificates() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/certs/revoked", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// This endpoint allows tidying up the storage backend and/or CRL by removing certificates that have expired
        /// and are past a certain buffer period beyond their expiration time.
        ///
        /// - Parameter request: The `TidyRequest` instance containing the tidy options.
        /// - Throws: An error if the request fails.
        public func tidy(request: TidyRequest) async throws {
            try await client.makeCall(path: config.mount + "/tidy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// This endpoint allows auto tidying up the storage backend and/or CRL by removing certificates that have expired
        /// and are past a certain buffer period beyond their expiration time.
        ///
        /// - Parameter request: The `AutoTidyRequest` instance containing the auto-tidy options.
        /// - Throws: An error if the request fails.
        public func autoTidy(request: AutoTidyRequest) async throws {
            try await client.makeCall(path: config.mount + "/config/auto-tidy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// This is a read only endpoint that returns information about the current tidy operation,
        /// or the most recent if none are currently running.
        ///
        /// - Returns: A `VaultResponse` containing the tidy status.
        /// - Throws: An error if the request fails.
        public func getTidyStatus() async throws -> VaultResponse<TidyStatus> {
            try await client.makeCall(path: config.mount + "/tidy-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// This endpoint allows cancelling a running tidy operation.
        /// It takes no parameter and cancels the tidy at the next available checkpoint,
        /// which may process additional certificates between when the operation was
        /// marked as cancelled and when the operation stopped.
        ///
        /// - Returns: A `VaultResponse` containing the tidy status.
        /// - Throws: An error if the request fails.
        public func cancelTidy() async throws -> VaultResponse<TidyStatus> {
            try await client.makeCall(path: config.mount + "/tidy-cancel", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configuration for the PKI client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the PKI client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the PKI engine (default is `pki`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.pki.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds a `PKIClient` with the specified configuration.
    ///
    /// - Parameter config: The `PKIClient.Config` instance.
    /// - Returns: A new `PKIClient` instance.
    func buildPKIClient(config: PKIClient.Config) -> PKIClient {
        .init(config: config, client: client)
    }
}
