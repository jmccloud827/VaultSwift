import Foundation

public extension Vault.SystemBackend {
    /// A client for interacting with enterprise features of a Vault instance.
    struct EnterpriseClient {
        private let client: Vault.Client
        private let basePath = "v1/sys"
        
        /// Initializes a new `EnterpriseClient` instance with the specified Vault client.
        ///
        /// - Parameter client: The Vault client.
        init(client: Vault.Client) {
            self.client = client
        }
        
        /// Retrieves the control group configuration.
        ///
        /// - Returns: A `VaultResponse` containing the control group configuration.
        public func getControlGroupConfig() async throws -> VaultResponse<ControlGroupConfig> {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes the control group configuration.
        ///
        /// - Parameter controlGroupConfig: The control group configuration to write.
        public func write(controlGroupConfig: ControlGroupConfig) async throws {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .put, request: controlGroupConfig, wrapTimeToLive: nil)
        }
        
        /// Deletes the control group configuration.
        public func deleteControlGroupConfig() async throws {
            try await client.makeCall(path: basePath + "/config/control-group", httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Authorizes a control group for a given accessor.
        ///
        /// - Parameter accessor: The accessor to authorize.
        /// - Returns: A `VaultResponse` containing the control group status.
        public func authorizeControlGroupFor(accessor: String) async throws -> VaultResponse<ControlGroupStatus> {
            let request = ["accessor": accessor]
            return try await client.makeCall(path: basePath + "/control-group/authorize", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the control group status for a given accessor.
        ///
        /// - Parameter accessor: The accessor to retrieve the status for.
        /// - Returns: A `VaultResponse` containing the control group status.
        public func getControlGroupStatusFor(accessor: String) async throws -> VaultResponse<ControlGroupStatus> {
            let request = ["accessor": accessor]
            return try await client.makeCall(path: basePath + "/control-group/request", httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves the license information.
        ///
        /// - Returns: A `VaultResponse` containing the license information.
        public func getLicense() async throws -> VaultResponse<License> {
            try await client.makeCall(path: basePath + "/license", httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Writes a license.
        ///
        /// - Parameter license: The license to write.
        public func write(license: String) async throws {
            let request = ["text": license]
            try await client.makeCall(path: basePath + "/license", httpMethod: .put, request: request, wrapTimeToLive: nil)
        }
        
        /// Retrieves all RGP policies.
        ///
        /// - Returns: A `VaultResponse` containing the keys of the RGP policies.
        public func getAllRGPPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policies/rgp", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific RGP policy.
        ///
        /// - Parameter rgpPolicy: The name of the RGP policy.
        /// - Returns: A `VaultResponse` containing the RGP policy.
        public func get(rgpPolicy: String) async throws -> VaultResponse<RGPPolicy> {
            try await client.makeCall(path: basePath + "/policies/rgp/" + rgpPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Adds or updates the RGP policy.
        /// Once a policy is updated, it takes effect immediately to all associated users.
        ///
        /// - Parameter rgpPolicy: The RGP policy to write.
        /// - Throws: A `VaultError` if the policy name is missing.
        public func write(rgpPolicy: RGPPolicy) async throws {
            guard let name = rgpPolicy.name else {
                throw VaultError(error: "RGP Policy name is required")
            }
            let request = ["policy": rgpPolicy.policy]
            try await client.makeCall(path: basePath + "/policies/rgp/" + name.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the named RGP policy. This will immediately affect all associated users.
        ///
        /// - Parameter rgpPolicy: The name of the RGP policy.
        public func delete(rgpPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policies/rgp/" + rgpPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves all EGP policies.
        ///
        /// - Returns: A `VaultResponse` containing the keys of the EGP policies.
        public func getAllEGPPolicies() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: basePath + "/policies/egp", httpMethod: .list, wrapTimeToLive: nil)
        }
        
        /// Retrieves a specific EGP policy.
        ///
        /// - Parameter egpPolicy: The name of the EGP policy.
        /// - Returns: A `VaultResponse` containing the EGP policy.
        public func get(egpPolicy: String) async throws -> VaultResponse<EGPPolicy> {
            try await client.makeCall(path: basePath + "/policies/egp/" + egpPolicy.trim(), httpMethod: .get, wrapTimeToLive: nil)
        }
        
        /// Adds or updates the EGP policy.
        /// Once a policy is updated, it takes effect immediately to all associated users.
        ///
        /// - Parameter egpPolicy: The EGP policy to write.
        /// - Throws: A `VaultError` if the policy name is missing.
        public func write(egpPolicy: EGPPolicy) async throws {
            guard let name = egpPolicy.name else {
                throw VaultError(error: "EGP Policy name is required")
            }
            let request = ["policy": egpPolicy.policy]
            try await client.makeCall(path: basePath + "/policies/egp/" + name.trim(), httpMethod: .post, request: request, wrapTimeToLive: nil)
        }
        
        /// Deletes the named EGP policy. This will immediately affect all associated users.
        ///
        /// - Parameter egpPolicy: The name of the EGP policy.
        public func delete(egpPolicy: String) async throws {
            try await client.makeCall(path: basePath + "/policies/egp/" + egpPolicy.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
    }
}
