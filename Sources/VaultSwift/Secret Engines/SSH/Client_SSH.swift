import Foundation

public extension Vault.SSH {
    struct Client {
        private let config: Config
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
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.ssh.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum SSH {}
    
    func buildSSHClient(config: SSH.Client.Config) -> SSH.Client {
        .init(config: config, client: client)
    }
}
