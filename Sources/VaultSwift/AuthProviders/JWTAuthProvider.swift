import Foundation

struct JWTAuthProvider: AuthProvider {
    let role: String
    let jwt: String
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        let request = ["role": role, "jwt": jwt]
        
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? "jwt")/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
        }
            
        return auth.clientToken
    }
}
