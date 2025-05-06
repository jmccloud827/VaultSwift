import Foundation

typealias AuthProviderType = Vault.AuthProviderType
typealias SecretEngineType = Vault.SecretEngineType
public struct Vault {
    let client: Client
    
    public init(config: Config) {
        self.client = .init(config: .init(baseURI: config.baseURI, namespace: config.namespace, authProvider: config.authProvider))
    }
    
    public struct Config {
        let baseURI: String
        let namespace: String?
        let authProvider: (any AuthProvider)?
        
        public init(baseURI: String, namespace: String, authProvider: AuthProviders) {
            self.init(baseURI: baseURI,
                      namespace: namespace,
                      authProvider: authProvider.asAuthProvider(client: .init(config: .init(baseURI: baseURI, namespace: nil, authProvider: nil))))
        }
        
        init(baseURI: String, namespace: String?, authProvider: (any AuthProvider)?) {
            self.baseURI = baseURI
            self.namespace = namespace
            self.authProvider = authProvider
        }
    }
    
    public enum AuthProviderType: Codable, Sendable {
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
    
    public enum SecretEngineType: Codable, Sendable {
        case activeDirectory
        case aliCloud
        case aws
        case azure
        case consul
        case cubbyhole
        case database
        case googleCloud
        case googleCloudKMS
        case identity
        case keyManagement
        case keyValueV1
        case keyValueV2
        case kmip
        case kubernetes
        case mongoDBAtlas
        case nomad
        case openLDAP
        case pki
        case rabbitMQ
        case ssh
        case terraform
        case totp
        case transform
        case transit
        case unknown(String)
        
        public var rawValue: String {
            switch self {
            case .activeDirectory:
                "ad"

            case .aliCloud:
                "alicloud"
                
            case .aws:
                "aws"
                
            case .azure:
                "azure"
                
            case .consul:
                "consul"
                
            case .cubbyhole:
                "cubbyhole"
                
            case .database:
                "database"
                
            case .googleCloud:
                "gcp"
                
            case .googleCloudKMS:
                "gcpkms"
                
            case .identity:
                "identity"
                
            case .keyManagement:
                "keymgmt"
                
            case .keyValueV1:
                "kv"
                
            case .keyValueV2:
                "kv-v2"
                
            case .kmip:
                "kmip"
                
            case .kubernetes:
                "kubernetes"
                
            case .mongoDBAtlas:
                "mongodb"
                
            case .nomad:
                "nomad"
                
            case .openLDAP:
                "openldap"
                
            case .pki:
                "pki"
                
            case .rabbitMQ:
                "rabbitmq"
                
            case .ssh:
                "ssh"
                
            case .terraform:
                "terraform"
                
            case .totp:
                "totp"
                
            case .transform:
                "transform"
                
            case .transit:
                "transit"
            case let .unknown(value):
                value
            }
        }
        
        static let allCases: [Self] = [
            .activeDirectory,
            .aliCloud,
            .aws,
            .azure,
            .consul,
            .cubbyhole,
            .database,
            .googleCloud,
            .googleCloudKMS,
            .identity,
            .keyManagement,
            .keyValueV1,
            .keyValueV2,
            .kmip,
            .kubernetes,
            .mongoDBAtlas,
            .nomad,
            .openLDAP,
            .pki,
            .rabbitMQ,
            .ssh,
            .terraform,
            .totp,
            .transform,
            .transit
        ]
        
        public init(from decoder: any Decoder) throws {
            let type = try decoder.singleValueContainer().decode(String.self)
            self = Self.allCases.first(where: { $0.rawValue == type }) ?? .unknown(type)
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
}
