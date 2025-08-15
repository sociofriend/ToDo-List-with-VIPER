//
//  ContentView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TaskListRouter<TodoDTO, ResponseDTO>.createModule()
    }
}

#Preview {
    ContentView()
}
