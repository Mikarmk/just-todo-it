import SwiftUI

struct NoteEditorView: View {
    enum Mode {
        case create
        case edit(Note)

        var title: String {
            switch self {
            case .create: "Новая заметка"
            case .edit: "Редактировать"
            }
        }
    }

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: NotesStore

    let mode: Mode

    @State private var title = ""
    @State private var details = ""

    private var buttonTitle: String {
        switch mode {
        case .create: "Сохранить"
        case .edit: "Готово"
        }
    }

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("Заголовок") {
                TextField("Например, позвонить маме", text: $title, axis: .vertical)
                    .lineLimit(1...3)
            }

            Section("Подробности") {
                TextField("Что важно не забыть", text: $details, axis: .vertical)
                    .lineLimit(4...8)
            }
        }
        .navigationTitle(mode.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Отмена") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(buttonTitle) {
                    save()
                }
                .disabled(!isValid)
            }
        }
        .onAppear(perform: populateIfNeeded)
    }

    private func populateIfNeeded() {
        guard case let .edit(note) = mode else { return }
        title = note.title
        details = note.details
    }

    private func save() {
        switch mode {
        case .create:
            store.add(title: title, details: details)
        case let .edit(note):
            store.update(note: note, title: title, details: details)
        }

        dismiss()
    }
}

#Preview {
    NavigationStack {
        NoteEditorView(mode: .create)
            .environmentObject(NotesStore())
    }
}
