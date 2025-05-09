import Foundation

public extension Vault.SecretEngines {
    struct ActiveDirectoryLibrary: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        public func write(serviceAccountSet: String, data: ServiceAccountSet) async throws {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public func get(serviceAccountSet: String) async throws -> VaultResponse<ServiceAccountSet> {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllServiceAccountSets() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/library", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(serviceAccountSet: String) async throws {
            guard !serviceAccountSet.isEmpty else {
                throw VaultError(error: "Service Account Set must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func checkOutCredentialsFor(serviceAccountSet: String, timeToLive: Int? = nil) async throws -> VaultResponse<ServiceAccountSetCredentials> {
            let request = ["ttl": timeToLive]
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim() + "/check-out", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func checkInCredentialsFor(serviceAccountSet: String, serviceAccounts: [String]? = nil) async throws -> VaultResponse<CheckInServiceAccountSetCredentialsResponse> {
            let request = ["service_account_names": serviceAccounts]
            
            return try await client.makeCall(path: self.config.mount + "/library/" + serviceAccountSet.trim() + "/check-in", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func forceCheckInCredentialsFor(serviceAccountSet: String, serviceAccounts: [String]? = nil) async throws -> VaultResponse<CheckInServiceAccountSetCredentialsResponse> {
            let request = ["service_account_names": serviceAccounts]
            
            return try await client.makeCall(path: self.config.mount + "/library/manage/" + serviceAccountSet.trim() + "/check-in", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
            
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.activeDirectory.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    func buildActiveDirectoryLibrary(config: ActiveDirectoryLibrary.Config) -> ActiveDirectoryLibrary {
        .init(config: config, client: client)
    }
}
