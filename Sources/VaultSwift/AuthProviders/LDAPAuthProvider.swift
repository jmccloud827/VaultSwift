import Foundation

struct LDAPAuthProvider: AuthProvider {
    let username: String
    let password: String
    let mount: String?
    let client: Vault.Client
        
    func getToken() async throws(VaultError) -> String {
        let request = ["password": password]
        
        let response: VaultResponse<[String: JSONAny]> = try await client.makeCall(path: "/auth/\(mount?.trim() ?? "ldap")/login/\(username)", httpMethod: .post, request: request, wrapTimeToLive: nil)
            
        guard let auth = response.auth else {
            throw .init(error: "Auth was nil")
        }
            
        return auth.clientToken
    }
}
