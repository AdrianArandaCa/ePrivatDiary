//
//  ePrivatDiaryApp.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import SwiftUI
import SwiftData

@main
struct ePrivatDiaryApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: PageModel.self)
        } catch {
            fatalError()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PageModel.self)
    }
}
