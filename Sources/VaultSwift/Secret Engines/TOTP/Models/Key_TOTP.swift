import Foundation

public extension Vault.SecretEngines.TOTPClient {
    struct Key: Decodable, Sendable {
        public let accountName: String?
        public let algorithm: String?
        public let digits: Int?
        public let issuer: String?
        public let period: Int?
        
        enum CodingKeys: String, CodingKey {
            case accountName
            case algorithm
            case digits
            case issuer
            case period
        }
    }
}
