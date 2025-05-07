import Foundation

public extension Vault.SystemBackend {
    struct SealStatus: Decodable, Sendable {
        public let type: String?
        public let initialized: Bool?
        public let sealed: Bool?
        public let secretThreshold: Int?
        public let secretShares: Int?
        public let progress: Int?
        public let nonce: String?
        public let version: String?
        public let buildDate: Date?
        public let migration: Bool?
        public let recoverySeal: Bool?
        public let storageType: String?
        public let hcpLinkStatus: String?
        public let hcpLinkResourceID: String?
        public let warnings: [String]?
        public let highAvailabilityEnabled: Bool?
        public let activeTime: Date?
        public let clusterName: String?
        public let clusterId: String?

        enum CodingKeys: String, CodingKey {
            case type = "type"
            case initialized = "initialized"
            case sealed = "sealed"
            case secretThreshold = "t"
            case secretShares = "n"
            case progress = "progress"
            case nonce = "nonce"
            case version = "version"
            case buildDate = "build_date"
            case migration = "migration"
            case recoverySeal = "recovery_seal"
            case storageType = "storage_type"
            case hcpLinkStatus = "hcp_link_status"
            case hcpLinkResourceID = "hcp_link_resource_ID"
            case warnings = "warnings"
            case highAvailabilityEnabled = "ha_enabled"
            case activeTime = "active_time"
            case clusterName = "cluster_name"
            case clusterId = "cluster_id"
        }
    }
}
