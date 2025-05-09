import Foundation

public extension Vault.SecretEngines {
    struct PKIClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func getCredentialsFor(role: String, options: CredentialsOptions) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/issue/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getCertificateFor(serialNumber: String) async throws -> VaultResponse<Certificate> {
            guard !serialNumber.isEmpty else {
                throw VaultError(error: "Serial Number must not be empty")
            }
            
            return try await client.makeCall(path: config.mount + "/cert/" + serialNumber.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func signCertificateFor(role: String, options: SignCertificateOptions) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/sign/" + role.trim(), httpMethod: .post, request: options, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func revokeCertificateFor(serialNumber: String) async throws -> VaultResponse<RevokedCertificate> {
            guard !serialNumber.isEmpty else {
                throw VaultError(error: "Serial Number must not be empty")
            }
            
            let request = ["serial_number": serialNumber]
            
            return try await client.makeCall(path: config.mount + "/revoke", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func listAllCertificates() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/certs", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func listAllRevokedCertificates() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: config.mount + "/certs/revoked", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func tidy(request: TidyRequest) async throws {
            try await client.makeCall(path: config.mount + "/tidy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func autoTidy(request: AutoTidyRequest) async throws {
            try await client.makeCall(path: config.mount + "/config/auto-tidy", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getTidyStatus() async throws -> VaultResponse<TidyStatus> {
            try await client.makeCall(path: config.mount + "/tidy-status", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func cancelTidy() async throws -> VaultResponse<TidyStatus> {
            try await client.makeCall(path: config.mount + "/tidy-cancel", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.pki.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildPKIClient(config: PKIClient.Config) -> PKIClient {
        .init(config: config, client: client)
    }
}
