import Foundation

extension Vault.AuthProviders {
    struct GoogleCloudTokenProvider: TokenProvider {
        let request: GoogleCloudAuthRequest
        let mount: String?
        let client: Vault.Client
        
        func getToken() async throws -> String {
            let response: VaultResponse<JSONAny> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? MethodType.googleCloud.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
            guard let auth = response.auth else {
                throw VaultError(error: "Unable to locate token")
            }
            
            return auth.clientToken
        }
    }
    
    public struct GoogleCloudAuthRequest: Encodable {
        public let role: String
        public let jwt: String
        
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
