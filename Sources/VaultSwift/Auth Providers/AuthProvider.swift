import Foundation

public extension Vault {
    /// Namespace for authentication providers.
    struct AuthProviders {
        let client: Vault.Client
        
        /// Initializes a new `Client` instance with the specified Vault client.
        ///
        /// - Parameter client: The Vault client.
        init(client: Vault.Client) {
            self.client = client
        }
        
        /// Protocol for token providers.
        protocol TokenProvider {
            func getToken() async throws -> String
        }
        
        /// Enumeration of supported authentication method types.
        public enum MethodType: Codable, Sendable {
            case aliCloud
            case appRole
            case aws
            case azure
            case cloudFoundry
            case googleCloud
            case gitHub
            case jwt
            case kubernetes
            case ldap
            case oci
            case okta
            case radius
            case token
            case userCredentials
            case custom(String)
            
            public var rawValue: String {
                switch self {
                case .aliCloud:
                    return "alicloud"
                    
                case .appRole:
                    return "approle"
                    
                case .aws:
                    return "aws"
                    
                case .azure:
                    return "azure"
                    
                case .cloudFoundry:
                    return "cf"
                    
                case .googleCloud:
                    return "gcp"
                    
                case .gitHub:
                    return "github"
                    
                case .jwt:
                    return "jwt"
                    
                case .kubernetes:
                    return "kubernetes"
                    
                case .ldap:
                    return "ldap"
                    
                case .oci:
                    return "oci"
                    
                case .okta:
                    return "okta"
                    
                case .radius:
                    return "radius"
                    
                case .token:
                    return "token"
                    
                case .userCredentials:
                    return "userpass"
                    
                case let .custom(value):
                    return value
                }
            }
            
            static let allCases: [Self] = [
                .aliCloud,
                .appRole,
                .aws,
                .azure,
                .cloudFoundry,
                .googleCloud,
                .gitHub,
                .jwt,
                .kubernetes,
                .ldap,
                .oci,
                .okta,
                .radius,
                .token,
                .userCredentials
            ]
            
            public init(from decoder: any Decoder) throws {
                let type = try decoder.singleValueContainer().decode(String.self)
                self = Self.allCases.first { $0.rawValue == type } ?? .custom(type)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(rawValue)
            }
        }
        
        /// Enumeration of token providers. Currently not supported: Certificate, Kerberos
        public enum TokenProviders {
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
            
            /// Converts the token provider to a `TokenProvider` instance.
            ///
            /// - Parameter client: The `Vault.Client` instance.
            /// - Returns: A `TokenProvider` instance.
            func asTokenProvider(client: Vault.Client) -> TokenProvider {
                switch self {
                case let .aliCloud(request, mount):
                    return AliCloudTokenProvider(request: request, mount: mount, client: client)
                    
                case let .appRole(roleID, secretID, mount):
                    return AppRoleTokenProvider(roleID: roleID, secretID: secretID, mount: mount, client: client)
                    
                case let .aws(role, nonce, type, mount):
                    return AWSTokenProvider(role: role, nonce: nonce, type: type, mount: mount, client: client)
                    
                case let .azure(request, mount):
                    return AzureTokenProvider(request: request, mount: mount, client: client)
                    
                case let .cloudFoundry(request, mount):
                    return CloudFoundryTokenProvider(request: request, mount: mount, client: client)
                    
                case let .custom(getToken):
                    return CustomTokenProvider(getToken: getToken)
                    
                case let .googleCloud(request, mount):
                    return GoogleCloudTokenProvider(request: request, mount: mount, client: client)
                    
                case let .gitHub(personalAccessToken, mount):
                    return GitHubTokenProvider(personalAccessToken: personalAccessToken, mount: mount, client: client)
                    
                case let .jwt(role, jwt, mount):
                    return JWTTokenProvider(role: role, jwt: jwt, mount: mount, client: client)
                    
                case let .kubernetes(role, jwt, mount):
                    return KubernetesTokenProvider(role: role, jwt: jwt, mount: mount, client: client)
                    
                case let .ldap(username, password, mount):
                    return LDAPTokenProvider(username: username, password: password, mount: mount, client: client)
                    
                case let .oci(role, headers, mount):
                    return OCITokenProvider(role: role, headers: headers, mount: mount, client: client)
                    
                case let .okta(request, mount):
                    return OktaTokenProvider(request: request, mount: mount, client: client)
                    
                case let .radius(username, password, mount):
                    return RADIUSTokenProvider(username: username, password: password, mount: mount, client: client)
                    
                case let .token(token):
                    return TokenTokenProvider(token: token)
                    
                case let .userCredentials(username, password, mount):
                    return UserCredentialsTokenProvider(username: username, password: password, mount: mount, client: client)
                }
            }
        }
    }
}
