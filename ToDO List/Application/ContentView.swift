//
//  ContentView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    var body: some View {
        TaskListRouter<TodoDTO, TodoPresentationModel, ResponseDTO>.createModule()
            .task {
                do {
                    try await DataImporter<TodoDTO, ResponseDTO>.importJSON(context: context)
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    ContentView()
}
