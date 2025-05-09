import Foundation

public extension Vault.SystemBackend {
    struct SecretEngine<Config: Codable & Sendable, Options: Codable & Sendable>: Codable, Sendable {
        public let type: Vault.SecretEngines.MountType
        public let id: String?
        public let accessor: String?
        public let config: Config?
        public let externalEntropyAccess: Bool?
        public let description: String?
        public let deprecationStatus: Bool?
        public let local: Bool?
        public let options: Options?
        public let pluginName: String?
        public let pluginVersion: String?
        public let runningPluginVersion: String?
        public let runningSHA256: String?
        public let sealWrap: Bool?
        
        public init(type: Vault.SecretEngines.MountType,
                    id: String?,
                    accessor: String?,
                    config: Config?,
                    description: String?,
                    deprecationStatus: Bool?,
                    externalEntropyAccess: Bool?,
                    local: Bool?,
                    options: Options?,
                    pluginName: String?,
                    pluginVersion: String?,
                    runningPluginVersion: String?,
                    runningSHA256: String?,
                    sealWrap: Bool?) {
            self.type = type
            self.id = id
            self.accessor = accessor
            self.config = config
            self.description = description
            self.deprecationStatus = deprecationStatus
            self.externalEntropyAccess = externalEntropyAccess
            self.local = local
            self.options = options
            self.pluginName = pluginName
            self.pluginVersion = pluginVersion
            self.runningPluginVersion = runningPluginVersion
            self.runningSHA256 = runningSHA256
            self.sealWrap = sealWrap
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case id = "uuid"
            case accessor
            case config
            case description
            case deprecationStatus = "deprecation_status"
            case externalEntropyAccess = "external_entropy_access"
            case local
            case options
            case pluginName = "plugin_name"
            case pluginVersion = "plugin_version"
            case runningPluginVersion = "running_plugin_version"
            case runningSHA256 = "running_sha256"
            case sealWrap = "seal_wrap"
        }
    }
}
