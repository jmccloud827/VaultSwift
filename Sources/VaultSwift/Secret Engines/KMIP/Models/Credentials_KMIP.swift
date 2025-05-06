import Foundation

public extension Vault.KMIP {
    struct Credentials: Decodable, Sendable {
        public let caChainContent: [String]?
        public let certificateContent: String?
        public let privateKeyContent: String?
        public let serialNumber: String?
        
        enum CodingKeys: String, CodingKey {
            case caChainContent = "ca_chain"
            case certificateContent = "certificate"
            case privateKeyContent = "private_key"
            case serialNumber = "serial_number"
        }
    }
}
