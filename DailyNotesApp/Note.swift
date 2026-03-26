import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var details: String
    var isDone: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        details: String = "",
        isDone: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.isDone = isDone
        self.createdAt = createdAt
    }
}
