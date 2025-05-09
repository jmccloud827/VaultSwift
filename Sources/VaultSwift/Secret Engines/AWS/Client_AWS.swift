import Foundation

public extension Vault.SecretEngines {
    /// A client for interacting with the Vault AWS secret engine.
    struct AWSClient: BackendClient {
        public let config: Config
        private let client: Vault.Client
        
        /// Initializes a new `AWSClient` instance with the specified configuration and Vault configuration.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AWS client.
        ///   - vaultConfig: The `Vault.Config` instance for the Vault client.
        public init(config: Config = .init(), vaultConfig: Vault.Config) {
            self.init(config: config, client: .init(config: vaultConfig))
        }
        
        /// Initializes a new `AWSClient` instance with the specified configuration and Vault client.
        ///
        /// - Parameters:
        ///   - config: The `Config` instance for the AWS client.
        ///   - client: The `Vault.Client` instance.
        init(config: Config, client: Vault.Client) {
            self.config = config
            self.client = client
        }
        
        /// This endpoint configures the root IAM credentials to communicate with AWS.
        /// There are multiple ways to pass root IAM credentials to the Vault server,
        /// specified below with the highest precedence first.
        /// If credentials already exist, this will overwrite them.
        /// The official AWS SDK is used for sourcing credentials from env vars,
        /// shared files, or IAM/ECS instances.
        ///
        /// Static credentials provided to the API as a payload
        /// Credentials in the AWS ACCESS KEY, AWS SECRET KEY, and AWS REGION environment
        /// variables on the server
        /// Shared credentials files
        /// Assigned IAM role or ECS task role credentials
        ///
        /// At present, this endpoint does not confirm that the provided AWS credentials are
        /// valid AWS credentials with proper permissions.
        ///
        /// - Parameter rootIAMCredentials: The `RootIAMCredentialsConfig` instance containing the root IAM credentials configuration.
        /// - Throws: An error if the request fails.
        public func write(rootIAMCredentials: RootIAMCredentialsConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config/root", httpMethod: .post, request: rootIAMCredentials, wrapTimeToLive: nil)
        }
        
        /// This endpoint allows you to read non-secure values that have been configured in the config/root endpoint.
        /// In particular, the secretKey parameter is never returned.
        ///
        /// - Returns: A `VaultResponse` containing the root IAM credentials configuration.
        /// - Throws: An error if the request fails.
        public func getRootIAMCredentials() async throws -> VaultResponse<RootIAMCredentialsConfig> {
            try await client.makeCall(path: self.config.mount + "/config/root", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// When you have configured Vault with static credentials,
        /// you can use this endpoint to have Vault rotate the access key it used.
        /// Note that, due to AWS eventual consistency, after calling this endpoint,
        /// subsequent calls from Vault to AWS may fail for a few seconds until
        /// AWS becomes consistent again.
        /// In order to call this endpoint, Vault's AWS access key MUST be the only
        /// access key on the IAM user; otherwise, generation of a new access key will fail.
        /// Once this method is called, Vault will now be the only entity that
        /// knows the AWS secret key is used to access AWS.
        ///
        /// - Returns: A `VaultResponse` containing the response for the rotation request.
        /// - Throws: An error if the request fails.
        public func rotateRootIAMCredentials() async throws -> VaultResponse<RotateRootIAMCredentialsResponse> {
            try await client.makeCall(path: self.config.mount + "/config/rotate-root", httpMethod: .post, wrapTimeToLive: nil)
        }
        
        /// Configures the lease for the AWS engine.
        ///
        /// - Parameter lease: The `LeaseConfig` instance containing the lease configuration.
        /// - Throws: An error if the request fails.
        public func write(lease: LeaseConfig) async throws {
            try await client.makeCall(path: self.config.mount + "/config/lease", httpMethod: .post, request: lease, wrapTimeToLive: nil)
        }
        
        /// Retrieves the lease configuration from the AWS engine.
        ///
        /// - Returns: A `VaultResponse` containing the lease configuration.
        /// - Throws: An error if the request fails.
        public func getLease() async throws -> VaultResponse<LeaseConfig> {
            try await client.makeCall(path: self.config.mount + "/config/lease", httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// This endpoint creates or updates the role with the given name.
        /// If a role with the name does not exist, it will be created.
        /// If the role exists, it will be updated with the new attributes.
        ///
        /// - Parameters:
        ///   - role: The name of the role.
        ///   - data: The `RoleRequest` instance containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func write(role: String, data: RoleRequest) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .post, request: data, wrapTimeToLive: nil)
        }
        
        /// This endpoint queries an existing role by the given name.
        /// If invalid role data was supplied to the role from an earlier version of Vault,
        /// then it will show up in the response as invalid_data.
        ///
        /// - Parameter role: The name of the role.
        /// - Returns: A `VaultResponse` containing the role data.
        /// - Throws: An error if the request fails or the role name is empty.
        public func get(role: String) async throws -> VaultResponse<RoleResponse> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            return try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .get, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Retrieves all roles from the AWS engine.
        ///
        /// - Returns: A `VaultResponse` containing the keys of all roles.
        /// - Throws: An error if the request fails.
        public func getAllRoles() async throws -> VaultResponse<Vault.Keys> {
            try await client.makeCall(path: self.config.mount + "/roles", httpMethod: .list, wrapTimeToLive: config.wrapTimeToLive)
        }
        
        /// Deletes a role from the AWS engine.
        ///
        /// - Parameter role: The name of the role to delete.
        /// - Throws: An error if the request fails or the role name is empty.
        public func delete(role: String) async throws {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
            }
            
            try await client.makeCall(path: self.config.mount + "/roles/" + role.trim(), httpMethod: .delete, wrapTimeToLive: nil)
        }
        
        /// Retrieves credentials for a role from the AWS engine.
        ///
        /// - Parameters:
        ///   - role: The name of the role to retrieve credentials for.
        ///   - arn: The ARN of the role to assume if credentialType on the Vault role is assumedRole. Must match one of the allowed role ARNs in the Vault role. Optional if the Vault role only allows a single AWS role ARN; required otherwise.
        ///   - sessionName: The role session name to attach to the assumed role ARN. Limited to 64 characters; if exceeded, the assumed role ARN will be truncated to 64 characters. If not provided, then it will be generated dynamically by default.
        /// - Returns: A `VaultResponse` containing the credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func getCredentialsFor(role: String, arn: String? = nil, sessionName: String? = nil) async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
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
        
        /// Generates a dynamic IAM AWS credential  with an STS token based on the named role.
        /// The TTL will be 3600 seconds (one hour).
        ///
        /// - Parameters:
        ///   - role: The name of the role to generate STS credentials for.
        ///   - arn: The ARN of the role to assume if credentialType on the Vault role is assumedRole. Must match one of the allowed role ARNs in the Vault role. Optional if the Vault role only allows a single AWS role ARN; required otherwise.
        ///   - sessionName: The role session name to attach to the assumed role ARN. Limited to 64 characters; if exceeded, the assumed role ARN will be truncated to 64 characters. If not provided, then it will be generated dynamically by default.
        ///   - timeToLive: The time to live for the credentials (default is "1h").
        /// - Returns: A `VaultResponse` containing the generated STS credentials.
        /// - Throws: An error if the request fails or the role name is empty.
        public func generateSTSCredentialsFor(role: String, arn: String? = nil, sessionName: String? = nil, timeToLive: String = "1h") async throws -> VaultResponse<Credentials> {
            guard !role.isEmpty else {
                throw VaultError(error: "Role must not be empty")
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
        
        /// Configuration for the AWS client.
        public struct Config {
            public let mount: String
            public let wrapTimeToLive: String?
            
            /// Initializes a new `Config` instance for the AWS client.
            ///
            /// - Parameters:
            ///   - mount: The mount path for the AWS engine (default is `aws`).
            ///   - wrapTimeToLive: The wrap time to live for the requests (optional).
            public init(mount: String? = nil, wrapTimeToLive: String? = nil) {
                self.mount = "/" + (mount?.trim() ?? MountType.aws.rawValue)
                self.wrapTimeToLive = wrapTimeToLive
            }
        }
    }
}

public extension Vault.SecretEngines {
    /// Builds an `AWSClient` with the specified configuration.
    ///
    /// - Parameter config: The `AWSClient.Config` instance.
    /// - Returns: A new `AWSClient` instance.
    func buildAWSClient(config: AWSClient.Config) -> AWSClient {
        .init(config: config, client: client)
    }
}
