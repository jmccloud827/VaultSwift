import Foundation

extension Vault.AuthProviders {
    struct CustomTokenProvider: TokenProvider {
        let getToken: () async throws -> String
        
        func getToken() async throws -> String {
            do {
                return try await getToken()
            } catch let error as VaultError {
                throw error
            } catch {
                throw VaultError(error: error.localizedDescription)
            }
        }
    }
}
