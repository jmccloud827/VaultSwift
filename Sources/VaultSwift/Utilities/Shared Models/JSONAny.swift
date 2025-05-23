import Foundation

/// An enum representing any JSON value.
public enum JSONAny: Codable, Sendable {
    case string(String)
    case number(Float)
    case object([String: Self])
    case array([Self])
    case bool(Bool)
    case null
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
    
        switch self {
        case let .array(array):
            try container.encode(array)
            
        case let .object(object):
            try container.encode(object)
            
        case let .string(string):
            try container.encode(string)
            
        case let .number(number):
            try container.encode(number)
            
        case let .bool(bool):
            try container.encode(bool)
            
        case .null:
            try container.encodeNil()
        }
    }
  
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
    
        if let object = try? container.decode([String: Self].self) {
            self = .object(object)
        } else if let array = try? container.decode([Self].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Float.self) {
            self = .number(number)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unhandled type"))
        }
    }
    
    /// Converts the `JSONAny` value to an object of the specified type.
    ///
    /// - Returns: An object of the specified type.
    /// - Throws: An error if any value throws an error during decoding.
    public func toObject<T: Decodable & Sendable>() throws -> T {
        try self.fromJSONAny()
    }
}

public extension Encodable {
    /// Converts the encodable value to an object of the specified type.
    ///
    /// - Returns: An object of the specified type.
    /// - Throws: An error if any value throws an error during encoding or decoding.
    func fromJSONAny<T: Decodable & Sendable>() throws -> T {
        let jsonData = try JSONEncoder().encode(self)
        
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    
    /// Converts the encodable value to a `JSONAny` value.
    ///
    /// - Returns: A `JSONAny` value.
    /// - Throws: An error if any value throws an error during encoding or decoding.
    func toJSONAny() throws -> JSONAny {
        let jsonData = try JSONEncoder().encode(self)
        
        return try JSONDecoder().decode(JSONAny.self, from: jsonData)
    }
}
