import Foundation

public extension Vault {
    struct AuthProviders {
        let client: Vault.Client
        
        init(client: Vault.Client) {
            self.client = client
        }
        
        protocol TokenProvider {
            func getToken() async throws -> String
        }
        
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
                    "alicloud"
                    
                case .appRole:
                    "approle"
                    
                case .aws:
                    "aws"
                    
                case .azure:
                    "azure"
                    
                case .cloudFoundry:
                    "cf"
                    
                case .googleCloud:
                    "gcp"
                    
                case .gitHub:
                    "github"
                    
                case .jwt:
                    "jwt"
                    
                case .kubernetes:
                    "kubernetes"
                    
                case .ldap:
                    "ldap"
                    
                case .oci:
                    "oci"
                    
                case .okta:
                    "okta"
                    
                case .radius:
                    "radius"
                    
                case .token:
                    "token"
                    
                case .userCredentials:
                    "userpass"
                    
                case let .custom(value):
                    value
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
                self = Self.allCases.first(where: { $0.rawValue == type }) ?? .custom(type)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(rawValue)
            }
        }
    }
}

public extension Vault.AuthProviders {
    enum TokenProviders {
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
        
        func asTokenProvider(client: Vault.Client) -> TokenProvider {
            switch self {
            case let .aliCloud(request, mount):
                AliCloudTokenProvider(request: request, mount: mount, client: client)
                
            case let .appRole(roleID, secretID, mount):
                AppRoleTokenProvider(roleID: roleID, secretID: secretID, mount: mount, client: client)
                
            case let .aws(role, nonce, type, mount):
                AWSTokenProvider(role: role, nonce: nonce, type: type, mount: mount, client: client)
                
            case let .azure(request, mount):
                AzureTokenProvider(request: request, mount: mount, client: client)
                
            case let .cloudFoundry(request: request, mount: mount):
                CloudFoundryTokenProvider(request: request, mount: mount, client: client)
                
            case let .custom(getToken: getToken):
                CustomTokenProvider(getToken: getToken)
                
            case let .googleCloud(request, mount):
                GoogleCloudTokenProvider(request: request, mount: mount, client: client)
                
            case let .gitHub(personalAccessToken, mount):
                GitHubTokenProvider(personalAccessToken: personalAccessToken, mount: mount, client: client)
                
            case let .jwt(role, jwt, mount):
                JWTTokenProvider(role: role, jwt: jwt, mount: mount, client: client)
                
            case let .kubernetes(role, jwt, mount):
                KubernetesTokenProvider(role: role, jwt: jwt, mount: mount, client: client)
                
            case let .ldap(username, password, mount):
                LDAPTokenProvider(username: username, password: password, mount: mount, client: client)
                
            case let .oci(role, headers, mount):
                OCITokenProvider(role: role, headers: headers, mount: mount, client: client)
                
            case let .okta(request, mount):
                OktaTokenProvider(request: request, mount: mount, client: client)
                
            case let .radius(username, password, mount):
                RADIUSTokenProvider(username: username, password: password, mount: mount, client: client)
                
            case let .token(token):
                TokenTokenProvider(token: token)
                
            case let .userCredentials(username, password, mount):
                UserCredentialsTokenProvider(username: username, password: password, mount: mount, client: client)
            }
        }
    }
}
