import Foundation

public extension Vault.SystemBackend {
    struct RequestHeader: Codable, Sendable {
        public let name: String?
        public let hmac: Bool?
        
        public init(from decoder: any Decoder) throws {
            let mapping = try decoder.singleValueContainer().decode([String: [String: Bool]].self)
            
            guard let pair = mapping.first?.value else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Parsing error"))
            }
            
            self.name = pair.first?.key
            self.hmac = pair.first?.value
        }
        
        public init(name: String?, hmac: Bool?) {
            self.name = name
            self.hmac = hmac
        }
    }
}
