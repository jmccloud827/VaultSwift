import Foundation

protocol AuthProvider {
    func getToken() async throws(VaultError) -> String
}

public extension Vault {
    enum AuthProviders {
        case aliCloud(request: AliCloudAuthRequest, mount: String? = nil)
        case appRole(roleID: String, secretID: String?, mount: String? = nil)
        case aws(role: String, nonce: String, type: AWSAuthMethodType, mount: String? = nil)
        case azure(request: AzureAuthRequest, mount: String? = nil)
        case cloudFoundry(request: CloudFoundryAuthRequest, mount: String? = nil)
        case custom(getToken: () async throws -> String)
        case googleCloud(request: GoogleCloudAuthRequest, mount: String? = nil)
        case gitHub(personalAccessToken: String, mount: String? = nil)
        case jwt(role: String, jwt: String, mount: String? = nil)
        case kubernetes(role: String, jwt: String, mount: String? = nil)
        case ldap(username: String, password: String, mount: String? = nil)
        case oci(role: String, headers: [String: String], mount: String? = nil)
        case okta(request: OktaAuthRequest, mount: String? = nil)
        case radius(username: String, password: String, mount: String? = nil)
        case token(String)
        case userCredentials(username: String, password: String, mount: String? = nil)
        
        // Currently not supported: Certificate, Kerberos
        
        func asAuthProvider(client: Client) -> AuthProvider {
            switch self {
            case let .aliCloud(request, mount):
                AliCloudAuthProvider(request: request, mount: mount, client: client)
                
            case let .appRole(roleID, secretID, mount):
                AppRoleAuthProvider(roleID: roleID, secretID: secretID, mount: mount, client: client)
                
            case let .aws(role, nonce, type, mount):
                AWSAuthProvider(role: role, nonce: nonce, type: type, mount: mount, client: client)
                
            case let .azure(request, mount):
                AzureAuthProvider(request: request, mount: mount, client: client)
                
            case let .cloudFoundry(request: request, mount: mount):
                CloudFoundryAuthProvider(request: request, mount: mount, client: client)
                
            case let .custom(getToken: getToken):
                CustomAuthProvider(getToken: getToken)
                
            case let .googleCloud(request, mount):
                GoogleCloudAuthProvider(request: request, mount: mount, client: client)
                
            case let .gitHub(personalAccessToken, mount):
                GitHubAuthProvider(personalAccessToken: personalAccessToken, mount: mount, client: client)
                
            case let .jwt(role, jwt, mount):
                JWTAuthProvider(role: role, jwt: jwt, mount: mount, client: client)
                
            case let .kubernetes(role, jwt, mount):
                KubernetesAuthProvider(role: role, jwt: jwt, mount: mount, client: client)
                
            case let .ldap(username, password, mount):
                LDAPAuthProvider(username: username, password: password, mount: mount, client: client)
                
            case let .oci(role, headers, mount):
                OCIAuthProvider(role: role, headers: headers, mount: mount, client: client)
                
            case let .okta(request, mount):
                OktaAuthProvider(request: request, mount: mount, client: client)
                
            case let .radius(username, password, mount):
                RADIUSAuthProvider(username: username, password: password, mount: mount, client: client)
                
            case let .token(token):
                TokenAuthProvider(token: token)
                
            case let .userCredentials(username, password, mount):
                UserCredentialsAuthProvider(username: username, password: password, mount: mount, client: client)
            }
        }
    }
}
