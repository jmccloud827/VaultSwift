import Foundation

public extension Vault.SystemBackend {
    struct KeyStatus: Decodable, Sendable {
        public let installTime: String?
        public let sequentialKeyNumber: Int?

        enum CodingKeys: String, CodingKey {
            case installTime = "install_time"
            case sequentialKeyNumber = "term"
        }
    }
}
