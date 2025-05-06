import Foundation

public extension Vault.AWS {
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
        
        public func write(rootIAMCredentials: RootIAMCredentialsConfig) async throws(VaultError) {
            try await client.makeCall(path: self.config.mount + "/config/root", httpMethod: .post, request: rootIAMCredentials, wrapTimeToLive: nil)
        }
        
        public func getRootIAMCredentials() async throws(VaultError) -> VaultResponse<RootIAMCredentialsConfig> {
            try await client.makeCall(path: self.config.mount + "/config/root", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func rotateRootIAMCredentials() async throws(VaultError) -> VaultResponse<RotateRootIAMCredentialsResponse> {
            try await client.makeCall(path: self.config.mount + "/config/rotate-root", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        public func write(lease: LeaseConfig) async throws(VaultError) {
            try await client.makeCall(path: self.config.mount + "/config/lease", httpMethod: .post, request: lease, wrapTimeToLive: nil)
        }
        
        public func getLease() async throws(VaultError) -> VaultResponse<LeaseConfig> {
            try await client.makeCall(path: self.config.mount + "/config/lease", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func write(role: String, data: RoleRequest) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
            
        public func get(role: String) async throws(VaultError) -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func getAllRoles() async throws(VaultError) -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func delete(role: String) async throws(VaultError) {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getCredentialsFor(role: String, arn: String? = nil, sessionName: String? = nil) async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            var queryParameters: [String] = []
            
            if let arn {
                queryParameters.append("role_arn=\(arn)")
            }
            
            if let sessionName {
                queryParameters.append("role_session_name=\(sessionName)")
            }
            
            let queryString = queryParameters.isEmpty ? "" : "?" + queryParameters.joined(separator: "&")
            
            return try await client.makeCall(path: self.config.mount + "/creds/" + role.trim() + queryString, httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public func generateSTSCredentialsFor(role: String, arn: String? = nil, sessionName: String? = nil, timeToLive: String = "1h") async throws(VaultError) -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw .init(error: "Path must not be empty")
            }
            
            var request: [String: String] = [:]
            
            if let sessionName {
                request["role_arn"] = sessionName
            }
            
            if let arn {
                request["role_session_name"] = arn
            }
            
            if !timeToLive.isEmpty {
                request["ttl"] = timeToLive
            }
            
            return try await client.makeCall(path: self.config.mount + "/sts/" + role.trim(), httpMethod: .post, request: request.isEmpty ? nil : request, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        public struct Config {
            let mount: String
            let wrapTimeToLive: String?
                
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount ?? SecretEngineType.aws.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault {
    enum AWS {}
    
    func buildAWSClient(config: AWS.Client.Config) -> AWS.Client {
        .init(config: config, client: client)
    }
}
