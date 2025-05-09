import Foundation

extension Vault.AuthProviders {
    /// A token provider for the AliCloud authentication method.
    struct AliCloudTokenProvider: TokenProvider {
        let request: AliCloudAuthRequest
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the AliCloud authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.aliCloud.rawValue)/login",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    /// A request structure for AliCloud authentication.
    public struct AliCloudAuthRequest: Encodable {
        public let role: String
        public let base64EncodedIdentityRequestURL: String
        public let base64EncodedIdentityRequestHeaders: String
        
        /// Initializes a new `AliCloudAuthRequest` instance.
        ///
        /// - Parameters:
        ///   - role: The role for the AliCloud authentication.
        ///   - base64EncodedIdentityRequestURL: The base64 encoded identity request URL.
        ///   - base64EncodedIdentityRequestHeaders: The base64 encoded identity request headers.
        public init(role: String, base64EncodedIdentityRequestURL: String, base64EncodedIdentityRequestHeaders: String) {
            self.role = role
            self.base64EncodedIdentityRequestURL = base64EncodedIdentityRequestURL
            self.base64EncodedIdentityRequestHeaders = base64EncodedIdentityRequestHeaders
        }
        
        enum CodingKeys: String, CodingKey {
            case role
            case base64EncodedIdentityRequestURL = "identity_request_url"
            case base64EncodedIdentityRequestHeaders = "identity_request_headers"
        }
    }
}
