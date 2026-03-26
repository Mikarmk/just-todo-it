import Foundation

@MainActor
final class NotesStore: ObservableObject {
    @Published private(set) var notes: [Note] = [] {
        didSet { save() }
    }

    private let saveKey = "daily-notes-items"

    init() {
        load()
    }

    func add(title: String, details: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else { return }

        notes.insert(Note(title: trimmedTitle, details: trimmedDetails), at: 0)
    }

    func update(note: Note, title: String, details: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty,
              let index = notes.firstIndex(where: { $0.id == note.id }) else { return }

        notes[index].title = trimmedTitle
        notes[index].details = trimmedDetails
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }

    func toggleDone(for note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index].isDone.toggle()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            notes = [
                Note(title: "Купить продукты", details: "Молоко, фрукты, хлеб"),
                Note(title: "Созвон в 16:00", details: "Обсудить задачи на завтра"),
                Note(title: "10 минут на план дня")
            ]
            return
        }

        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            notes = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            assertionFailure("Failed to save notes: \(error)")
        }
    }
}
