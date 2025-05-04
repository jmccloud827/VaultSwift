import Foundation

struct AliCloudAuthProvider: AuthProvider {
    let request: AliCloudAuthRequest
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? "alicloud")/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
        }
            
        return auth.clientToken
    }
}

public struct AliCloudAuthRequest: Encodable {
    public let role: String
    public let base64EncodedIdentityRequestURL: String
    public let base64EncodedIdentityRequestHeaders: String
    
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
