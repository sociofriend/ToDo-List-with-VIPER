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
        TaskListRouter<TodoDTO, ResponseDTO>.createModule()
            .onAppear {
                DataImporter<TodoDTO, ResponseDTO>.importJSON(context: context)
            }
    }
}

#Preview {
    ContentView()
}
