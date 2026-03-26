import SwiftUI

struct NotesListView: View {
    @EnvironmentObject private var store: NotesStore
    @State private var isPresentingNewNote = false

    private var progressText: String {
        let doneCount = store.notes.filter(\.isDone).count
        return "\(doneCount) из \(store.notes.count) выполнено"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                headerCard

                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "На сегодня заметок нет",
                        systemImage: "sun.max",
                        description: Text("Нажми плюс и добавь первую задачу или заметку.")
                    )
                } else {
                    List {
                        ForEach(store.notes) { note in
                            NavigationLink {
                                NoteEditorView(mode: .edit(note))
                            } label: {
                                NoteRow(note: note) {
                                    store.toggleDone(for: note)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                        .onDelete(perform: store.delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding()
            .navigationTitle("Сегодня")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingNewNote = true
                    } label: {
                        Label("Добавить", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewNote) {
                NavigationStack {
                    NoteEditorView(mode: .create)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemGroupedBackground), Color(.secondarySystemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Мои заметки на день")
                .font(.title2.bold())
            Text(progressText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct NoteRow: View {
    let note: Note
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: toggle) {
                Image(systemName: note.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(note.isDone ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(note.title)
                    .font(.headline)
                    .strikethrough(note.isDone, color: .secondary)

                if !note.details.isEmpty {
                    Text(note.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    NotesListView()
        .environmentObject(NotesStore())
}
