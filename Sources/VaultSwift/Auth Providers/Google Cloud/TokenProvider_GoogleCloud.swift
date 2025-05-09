import Foundation

extension Vault.AuthProviders {
    /// A token provider for the Google Cloud authentication method.
    struct GoogleCloudTokenProvider: TokenProvider {
        let request: GoogleCloudAuthRequest
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the Google Cloud authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.googleCloud.rawValue)/login",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    /// A request structure for Google Cloud authentication.
    public struct GoogleCloudAuthRequest: Encodable {
        public let role: String
        public let jwt: String
        
        /// Initializes a new `GoogleCloudAuthRequest` instance.
        ///
        /// - Parameters:
        ///   - role: The role for the Google Cloud authentication.
        ///   - jwt: The JSON Web Token (JWT) for the Google Cloud authentication.
        public init(role: String, jwt: String) {
            self.role = role
            self.jwt = jwt
        }
        
        enum CodingKeys: String, CodingKey {
            case role
            case jwt
        }
    }
}
