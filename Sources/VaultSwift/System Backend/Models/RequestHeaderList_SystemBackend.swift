import Foundation

public extension Vault.SystemBackend {
    struct RequestHeaderList: Decodable, Sendable {
        public let headers: [RequestHeader]?
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: Self.CodingKeys.self)
            let mapping = try container.decode([String: [String: [String: Bool]]].self, forKey: Self.CodingKeys.headers)
            
            var headers: [RequestHeader] = []
            
            guard let pair = mapping.first?.value else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Parsing error"))
            }
            
            for (key, value) in pair {
                headers.append(.init(name: key, hmac: value.first?.value))
            }
            
            self.headers = headers
        }
        
        enum CodingKeys: String, CodingKey {
            case headers
        }
    }
}
