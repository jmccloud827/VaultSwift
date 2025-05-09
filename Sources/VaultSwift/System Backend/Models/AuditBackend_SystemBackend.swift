import Foundation

public extension Vault.SystemBackend {
    struct AuditBackend: Codable, Sendable {
        public let type: `Type`
        public let description: String?
        public let local: Bool?
        
        public init(type: Type, description: String?, local: Bool?) {
            self.type = type
            self.description = description
            self.local = local
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer = try decoder.container(keyedBy: Self.CodingKeys.self)
            self.description = try container.decodeIfPresent(String.self, forKey: Self.CodingKeys.description)
            self.local = try container.decodeIfPresent(Bool.self, forKey: Self.CodingKeys.local)
            
            let typeString = try container.decode(String.self, forKey: Self.CodingKeys.type)
            switch typeString {
            case Type.fileTypeString:
                let options = try container.decode(FileOptions.self, forKey: Self.CodingKeys.options)
                self.type = .file(options: options)
                
            case Type.syslogTypeString:
                let options = try container.decode(SyslogOptions.self, forKey: Self.CodingKeys.options)
                self.type = .syslog(options: options)
                
            default:
                let options = try container.decode([String: String].self, forKey: Self.CodingKeys.options)
                self.type = .custom(typeString, options: options)
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case type
            case description
            case local
            case options
        }
        
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(description, forKey: .description)
            try container.encode(local, forKey: .local)
            
            switch type {
            case let .file(options):
                try container.encode(options, forKey: .options)
                try container.encode(Type.fileTypeString, forKey: .type)
                
            case let .syslog(options):
                try container.encode(options, forKey: .options)
                try container.encode(Type.syslogTypeString, forKey: .type)
                
            case let .custom(type, options):
                try container.encode(options, forKey: .options)
                try container.encode(type, forKey: .type)
            }
        }
        
        public enum `Type`: Codable, Sendable {
            case file(options: FileOptions)
            case syslog(options: SyslogOptions)
            case custom(String, options: [String: String])
            
            static let fileTypeString = "file"
            static let syslogTypeString = "syslog"
            var typeString: String {
                switch self {
                case .file:
                    Self.fileTypeString
                    
                case .syslog:
                    Self.syslogTypeString
                    
                case let .custom(type, _):
                    type
                }
            }
        }
        
        public struct FileOptions: Codable, Sendable {
            public let elideListResponses: String?
            public let fallback: String?
            public let filter: String?
            public let format: String?
            public let hmacAccessor: String?
            public let logSensitiveDataInRawFormat: String?
            public let prefix: String?
            public let filePath: String?
            
            public init(elideListResponses: String? = "false",
                        fallback: String? = "",
                        filter: String? = "",
                        format: String? = "json",
                        hmacAccessor: String? = "true",
                        logSensitiveDataInRawFormat: String? = "false",
                        prefix: String? = "",
                        filePath: String?) {
                self.elideListResponses = elideListResponses
                self.fallback = fallback
                self.filter = filter
                self.format = format
                self.hmacAccessor = hmacAccessor
                self.logSensitiveDataInRawFormat = logSensitiveDataInRawFormat
                self.prefix = prefix
                self.filePath = filePath
            }
            
            enum CodingKeys: String, CodingKey {
                case elideListResponses = "elide_list_responses"
                case fallback
                case filter
                case format
                case hmacAccessor = "hmac_accessor"
                case logSensitiveDataInRawFormat = "log_raw"
                case prefix
                case filePath = "file_path"
            }
        }
        
        public struct SyslogOptions: Codable, Sendable {
            public let elideListResponses: String?
            public let fallback: String?
            public let filter: String?
            public let format: String?
            public let hmacAccessor: String?
            public let logSensitiveDataInRawFormat: String?
            public let prefix: String?
            public let facility: String?
            public let tag: String?
            
            public init(elideListResponses: String? = "false",
                        fallback: String? = "",
                        filter: String? = "",
                        format: String? = "json",
                        hmacAccessor: String? = "true",
                        logSensitiveDataInRawFormat: String? = "false",
                        prefix: String? = "",
                        facility: String? = "AUTH",
                        tag: String? = "vault") {
                self.elideListResponses = elideListResponses
                self.fallback = fallback
                self.filter = filter
                self.format = format
                self.hmacAccessor = hmacAccessor
                self.logSensitiveDataInRawFormat = logSensitiveDataInRawFormat
                self.prefix = prefix
                self.facility = facility
                self.tag = tag
            }
            
            enum CodingKeys: String, CodingKey {
                case elideListResponses = "elide_list_responses"
                case fallback
                case filter
                case format
                case hmacAccessor = "hmac_accessor"
                case logSensitiveDataInRawFormat = "log_raw"
                case prefix
                case facility
                case tag
            }
        }
    }
}
