import Foundation

public extension Vault.MongoDBAtlas {
    struct Credentials: Decodable, Sendable {
        public let leaseDuration: String?
        public let leaseRenewable: String?
        public let description: String?
        public let privateKey: String?
        public let publicKey: String?
        
        enum CodingKeys: String, CodingKey {
            case leaseDuration = "lease_duration"
            case leaseRenewable = "lease_renewable"
            case description
            case privateKey = "private_key"
            case publicKey = "public_key"
        }
    }
}
