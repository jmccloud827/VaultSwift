import Foundation

struct AppRoleAuthProvider: AuthProvider {
    let roleID: String
    let secretID: String?
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        var request = ["role_id": roleID]
        
        if let secretID {
            request["secret_id"] = secretID
        }
        
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "v1/auth/\(mount?.trim() ?? AuthProviderType.appRole.rawValue)/login", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
        }
            
        return auth.clientToken
    }
}
