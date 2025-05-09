import Foundation

extension Vault.AuthProviders {
    /// A token provider for the Okta authentication method.
    struct OktaTokenProvider: TokenProvider {
        let request: OktaAuthRequest
        let mount: String?
        let client: Vault.Client
        
        /// Retrieves a token using the Okta authentication method.
        ///
        /// - Returns: A token string.
        /// - Throws: An error if the request fails or the token cannot be located.
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? MethodType.okta.rawValue)/login/\(request.username)",
                                                                             httpMethod: .post,
                                                                             request: request,
                                                                             wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    /// A request structure for Okta authentication.
    public struct OktaAuthRequest: Encodable {
        public let username: String
        public let password: String
        public let totp: String?
        public let totpProvider: TOTPProvider?
        public let nonce: String?
        
        /// Initializes a new `OktaAuthRequest` instance.
        ///
        /// - Parameters:
        ///   - username: The username for the Okta account.
        ///   - password: The password for the Okta account.
        ///   - totp: The Time-based One-Time Password (optional).
        ///   - totpProvider: The provider for the TOTP (optional).
        ///   - nonce: The nonce value (optional).
        public init(username: String, password: String, totp: String? = nil, totpProvider: TOTPProvider? = nil, nonce: String? = nil) {
            self.username = username
            self.password = password
            self.totp = totp
            self.totpProvider = totpProvider
            self.nonce = nonce
        }
        
        /// Enumeration of TOTP providers.
        public enum TOTPProvider: Int {
            case okta
            case google
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(password, forKey: .password)
            try container.encode(totp, forKey: .totp)
            try container.encode(totpProvider?.rawValue, forKey: .totpProvider)
            try container.encode(nonce, forKey: .nonce)
        }
        
        enum CodingKeys: String, CodingKey {
            case password
            case totp
            case totpProvider = "provider"
            case nonce
        }
    }
}
