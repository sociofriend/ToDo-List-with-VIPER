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
    
    var filteredTasks: [Task] {
        guard !searchInput.isEmpty else { return presenter.tasks }
        return presenter.tasks.filter {
            ($0.title?.localizedCaseInsensitiveContains(searchInput) ?? false) ||
            $0.todo.localizedCaseInsensitiveContains(searchInput)
        }
    }
            

    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchInput)
                        .padding(8)
                        .padding(.leading, 30)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                
                                Button(action: toggleRecording) {
                                    Image(systemName: speechHelper.isRecording ? "mic.fill" : "mic")
                                        .foregroundColor(speechHelper.isRecording ? .accentColor : .white)
                                        .padding(.trailing, 8)
                                }
                            }
                        )
                }
                .padding(.horizontal)
                
                List(filteredTasks) { task in
                    HStack(alignment: .top) {
                        Image(systemName: (!task.completed ? "circle" : "checkmark.circle"))
                            .foregroundStyle(!task.completed ? .primaryWhite : .accent)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            if let title = task.title {
                                Text(title)
                                    .font(.system(size: 16))
                                    .strikethrough(task.completed)
                            }
                            
                            Text(task.todo)
                                .font(.system(size: 12))
                                .strikethrough(task.title == nil && task.completed)
                            
                            if let description = task.title {
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
                        .foregroundStyle(.primaryWhite.opacity(!task.completed ? 1 : 0.5))
                    }
                }
                .onChange(of: speechHelper.transcribedText) { newValue in
                    if !newValue.isEmpty {
                        searchInput = newValue
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
                
                ZStack {
                    
                    Text(String("\(presenter.tasks.count) задач"))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .frame(height: 49)
                .padding()
            }
        }
        .navigationTitle("Задачи")
        
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
