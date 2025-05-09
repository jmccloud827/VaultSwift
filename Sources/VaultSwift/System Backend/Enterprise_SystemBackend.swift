import Foundation

public extension Vault.SystemBackend {
    struct EnterpriseClient {
        private let client: Vault.Client
        private let basePath = "v1/sys"
            
        init(client: Vault.Client) {
            self.client = client
        }
        
        public func getControlGroupConfig() async throws -> VaultResponse<ControlGroupConfig> {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(controlGroupConfig: ControlGroupConfig) async throws {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .put, request: controlGroupConfig, wrapTimeToLive: nil)
        }
        
        public func deleteControlGroupConfig() async throws {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func authorizeControlGroupFor(accessor: String) async throws -> VaultResponse<ControlGroupStatus> {
            let request = ["accessor": accessor]
            
            return try await client.makeCall(path: basePath + "/control-group/authorize", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getControlGroupStatusFor(accessor: String) async throws -> VaultResponse<ControlGroupStatus> {
            let request = ["accessor": accessor]
            
            return try await client.makeCall(path: basePath + "/control-group/request", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func getLicense() async throws -> VaultResponse<License> {
            try await client.makeCall(path: basePath + "/license", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(license: String) async throws {
            let request = ["text": license]
            
            try await client.makeCall(path: basePath + "/license", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        public func getAllRGPPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policies/rgp", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func get(rgpPolicy: String) async throws -> VaultResponse<RGPPolicy> {
            try await client.makeCall(path: basePath + "/policies/rgp/" + rgpPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(rgpPolicy: RGPPolicy) async throws {
            guard let name = rgpPolicy.name else {
                throw VaultError(error: "PGP Policy is required")
            }
            
            let request = ["policy": rgpPolicy.policy]
            
            try await client.makeCall(path: basePath + "/policies/rgp/" + name.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func delete(rgpPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policies/rgp/" + rgpPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        public func getAllEGPPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policies/egp", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        public func get(egpPolicy: String) async throws -> VaultResponse<EGPPolicy> {
            try await client.makeCall(path: basePath + "/policies/egp/" + egpPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        public func write(egpPolicy: EGPPolicy) async throws {
            guard let name = egpPolicy.name else {
                throw VaultError(error: "EGP Policy is required")
            }
            
            let request = ["policy": egpPolicy.policy]
            
            try await client.makeCall(path: basePath + "/policies/egp/" + name.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        public func delete(egpPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policies/egp/" + egpPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
    }
}
