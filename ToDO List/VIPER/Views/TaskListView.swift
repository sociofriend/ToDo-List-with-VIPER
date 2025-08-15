//
//  TaskListView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import SwiftUI
import Speech

import SwiftUI

struct TaskListView<Task: TodoProtocol, Response: ResponseProtocol>: View {
    @ObservedObject var presenter: TaskListPresenter<Task, Response>
    @StateObject private var speechHelper = SpeechRecognizerHelper()
    @State private var searchInput: String = ""
    
    var body: some View {
        NavigationView {
            List(presenter.tasks) { task in
                HStack(alignment: .top) {
                    Image(systemName: (!task.completed ? "circle" : "checkmark.circle"))
                        .foregroundStyle(!task.completed ? .white : .accent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.todo)
                            .font(.headline)
                            .strikethrough(task.completed)
                        
                        if let description = task.description {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let date = task.date {
                            Text(date.formatted(date: .numeric, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundStyle(!task.completed ? .white : .gray)
                }
            }
            .searchable(text: $searchInput, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .onChange(of: speechHelper.transcribedText) { newValue in
                searchInput = newValue
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleRecording) {
                        Image(systemName: speechHelper.isRecording ? "mic.fill" : "mic")
                    }
                }
            }
            .onAppear {
                presenter.loadTasks()
                speechHelper.requestPermissions { granted in
                    if !granted {
                        print("Speech or mic permissions not granted")
                    }
                }
            }
        }
    }
    
    private func toggleRecording() {
        if speechHelper.isRecording {
            speechHelper.stopRecording()
        } else {
            speechHelper.startRecording()
        }
    }
}

#Preview {
    ContentView()
        .colorScheme(.dark)
}
