import Foundation

extension String {
    /// Trims the leading and trailing slashes from the string.
    ///
    /// - Returns: A new string with the leading and trailing slashes removed.
    func trim() -> Self {
        self.trimmingCharacters(in: .init(charactersIn: "/"))
    }
}
