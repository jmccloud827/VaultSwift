import Foundation

extension String {
    func trim() -> Self {
        self.trimmingCharacters(in: .init(charactersIn: "/"))
    }
}
