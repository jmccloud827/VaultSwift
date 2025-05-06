import Foundation

public extension Vault.SystemBackend {
    struct Leader: Decodable, Sendable {
        public let highAvailabilityEnabled: Bool?
        public let isSelf: Bool?
        public let activeTime: Date?
        public let address: String?
        public let clusterAddress: String?
        public let performanceStandby: Bool?
        public let performanceStandbyLastRemoteWal: Int?
        public let lastWal: Int?
        public let raftCommittedIndex: Int?
        public let raftAppliedIndex: Int?

        enum CodingKeys: String, CodingKey {
            case highAvailabilityEnabled = "ha_enabled"
            case isSelf = "is_self"
            case activeTime = "active_time"
            case address = "leader_address"
            case clusterAddress = "leader_cluster_address"
            case performanceStandby = "performance_standby"
            case performanceStandbyLastRemoteWal = "performance_standby_last_remote_wal"
            case lastWal = "last_wal"
            case raftCommittedIndex = "raft_committed_index"
            case raftAppliedIndex = "raft_applied_index"
        }
    }
}
