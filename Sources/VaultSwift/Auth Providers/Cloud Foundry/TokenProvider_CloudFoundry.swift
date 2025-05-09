import Foundation

extension Vault.AuthProviders {
    /// A token provider for the Cloud Foundry authentication method.
    struct CloudFoundryTokenProvider: TokenProvider {
        let request: CloudFoundryAuthRequest
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the Cloud Foundry authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.cloudFoundry.rawValue)/login",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    /// A request structure for Cloud Foundry authentication.
    public struct CloudFoundryAuthRequest: Encodable {
        public let role: String
        public let instanceCertContent: String
        public let signature: String
        public let signatureDate: String
        
        /// Initializes a new `CloudFoundryAuthRequest` instance.
        ///
        /// - Parameters:
        ///   - role: The role for the Cloud Foundry authentication.
        ///   - instanceCertContent: The instance certificate content.
        ///   - signature: The signature.
        ///   - signatureDate: The date of the signature.
        public init(role: String, instanceCertContent: String, signature: String, signatureDate: Date) {
            self.role = role
            self.instanceCertContent = instanceCertContent
            self.signature = signature
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            self.signatureDate = dateFormatter.string(from: signatureDate)
        }
        
        enum CodingKeys: String, CodingKey {
            case role
            case instanceCertContent = "cf_instance_cert"
            case signature
            case signatureDate = "signing_time"
        }
    }
}
