import Foundation

struct GoogleCloudAuthProvider: AuthProvider {
    let request: GoogleCloudAuthRequest
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? "gcp")/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
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
