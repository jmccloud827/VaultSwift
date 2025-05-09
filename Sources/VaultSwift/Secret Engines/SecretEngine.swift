import Foundation

public extension Vault {
    struct SecretEngines {
        let client: Vault.Client
        
        init(client: Vault.Client) {
            self.client = client
        }
        
        public enum MountType: Codable, Sendable {
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
}
