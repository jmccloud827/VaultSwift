import Foundation

public extension Vault.Identity {
    struct KeyResponse: Decodable, Sendable {
        public let data: Data
        
        enum CodingKeys: String, CodingKey {
            case data
        }
        
        public struct Data: Decodable, Sendable {
            public let rotationPeriod: String?
            public let verificationTimeToLive: String?
            public let algorithm: String?
            
            enum CodingKeys: String, CodingKey {
                case rotationPeriod = "rotation_period"
                case verificationTimeToLive = "verification_ttl"
                case algorithm
            }
        }
    }
}
