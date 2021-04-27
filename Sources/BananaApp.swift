import SwiftUI

// This is here just for reference if we wanted to switch to the pure SwiftUI life-cycle via the
// Project.swift Tuist file.
//
// By removing the main annotation, the runtime won't load this.
// @main
struct BananaApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
