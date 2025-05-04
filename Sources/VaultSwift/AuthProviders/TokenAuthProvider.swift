import Foundation

struct TokenAuthProvider: AuthProvider {
    let token: String
        
    func getToken() throws(VaultError) -> String {
        token
    }
}
