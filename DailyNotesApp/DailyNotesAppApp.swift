import SwiftUI

@main
struct DailyNotesAppApp: App {
    @StateObject private var store = NotesStore()

    var body: some Scene {
        WindowGroup {
            NotesListView()
                .environmentObject(store)
        }
    }
}
