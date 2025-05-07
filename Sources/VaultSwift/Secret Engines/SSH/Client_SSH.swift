import Foundation

public extension Vault.SecretEngines {
    struct SSHClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
            
        public init(config: Config, vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
            
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
            
        public func getCredentialsFor(role: String, ipAddress: String, username: String? = nil) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            guard !ipAddress.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            let request = [
                "ip": ipAddress,
                "username": username
            ]
        
            return try await client.makeCall(path: config.mount + "/creds/" + role.trim(), httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func signKeyFor(role: String, data: SignKeyRequest) async throws(VaultError) -> VaultResponse<SignKeyResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
        
            return try await client.makeCall(path: config.mount + "/sign/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? MountType.ssh.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    func buildSSHClient(config: SecretEngines.SSHClient.Config) -> SecretEngines.SSHClient {
        .init(config: config, client: client)
    }
}
