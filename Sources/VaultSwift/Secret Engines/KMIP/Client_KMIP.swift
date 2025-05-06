import Foundation

public extension Vault.KMIP {
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
            
        public func getCredentialsFor(role: String, scope: String, certificateFormat: CertificateFormat) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            guard !scope.isEmpty else {
                throw .init(error: "Key must not be empty")
            }
            
            let request = ["format": certificateFormat.rawValue]
            
            return try await client.makeCall(path: config.mount + "/scope/" + scope.trim() + "/role/" + role.trim() + "/credential/generate", httpMethod: .post, request: request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public enum CertificateFormat: String {
            case empty
            case der
            case pem
            case pemBundle = "pem_bundle"
        }
        
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.kmip.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum KMIP {}
    
    func buildKMIPClient(config: KMIP.Client.Config) -> KMIP.Client {
        .init(config: config, client: client)
    }
}
