//
//  ToDO_ListApp.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
internal import CoreData

@main
struct ToDO_ListApp: App {
    @Environment(\.colorScheme) private var colorScheme
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .colorScheme(.dark)

        }
    }
}
