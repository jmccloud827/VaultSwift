import Foundation

public extension Vault.SSH {
    struct SignKeyResponse: Decodable, Sendable {
        public let serialNumber: String?
        public let signedKey: String?
        
        enum CodingKeys: String, CodingKey {
            case serialNumber = "serial_number"
            case signedKey = "signed_key"
        }
    }
}
