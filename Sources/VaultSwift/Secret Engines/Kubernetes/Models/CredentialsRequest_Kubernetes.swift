import Foundation

public extension Vault.Kubernetes {
    struct CredentialsRequest: Encodable, Sendable {
        public let namespace: String
        public let clusterRoleBinding: String?
        public let timeToLive: String?
        
        public init(namespace: String, clusterRoleBinding: String?, timeToLive: String?) {
            self.namespace = namespace
            self.clusterRoleBinding = clusterRoleBinding
            self.timeToLive = timeToLive
        }
        
        enum CodingKeys: String, CodingKey {
            case namespace = "kubernetes_namespace"
            case clusterRoleBinding = "cluster_role_binding"
            case timeToLive = "ttl"
        }
    }
}
