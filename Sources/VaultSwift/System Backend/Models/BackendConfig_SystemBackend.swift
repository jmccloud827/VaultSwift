import Foundation

public extension Vault.SystemBackend {
    struct BackendConfig: Codable, Sendable {
        public let defaultLeaseTtl: Int?
        public let forceNoCache: Bool?
        public let maximumLeaseTtl: Int?
        public let description: String?
        public let auditNonHMACRequestKeys: [String]?
        public let auditNonHMACResponseKeys: [String]?
        public let listingVisibility: ListingVisibility?
        public let passthroughRequestHeaders: [String]?
        public let allowedResponseHeaders: [String]?
        public let allowedManagedKeys: [String]?
        public let pluginVersion: String?
        
        public init(defaultLeaseTtl: Int?,
                    forceNoCache: Bool?,
                    maximumLeaseTtl: Int?,
                    description: String?,
                    auditNonHMACRequestKeys: [String]?,
                    auditNonHMACResponseKeys: [String]?,
                    listingVisibility: ListingVisibility? = .hidden,
                    passthroughRequestHeaders: [String]?,
                    allowedResponseHeaders: [String]?,
                    allowedManagedKeys: [String]?,
                    pluginVersion: String?) {
            self.defaultLeaseTtl = defaultLeaseTtl
            self.forceNoCache = forceNoCache
            self.maximumLeaseTtl = maximumLeaseTtl
            self.description = description
            self.auditNonHMACRequestKeys = auditNonHMACRequestKeys
            self.auditNonHMACResponseKeys = auditNonHMACResponseKeys
            self.listingVisibility = listingVisibility
            self.passthroughRequestHeaders = passthroughRequestHeaders
            self.allowedResponseHeaders = allowedResponseHeaders
            self.allowedManagedKeys = allowedManagedKeys
            self.pluginVersion = pluginVersion
        }

        enum CodingKeys: String, CodingKey {
            case defaultLeaseTtl = "default_lease_ttl"
            case forceNoCache = "force_no_cache"
            case maximumLeaseTtl = "max_lease_ttl"
            case description
            case auditNonHMACRequestKeys = "audit_non_hmac_request_keys"
            case auditNonHMACResponseKeys = "audit_non_hmac_response_keys"
            case listingVisibility = "listing_visibility"
            case passthroughRequestHeaders = "passthrough_request_headers"
            case allowedResponseHeaders = "allowed_response_headers"
            case allowedManagedKeys = "allowed_managed_keys"
            case pluginVersion = "plugin_version"
        }
        
        public enum ListingVisibility: String, Codable, Sendable {
            case hidden
            case unauth
        }
    }
}
