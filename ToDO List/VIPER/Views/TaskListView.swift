//
//  TaskListView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import SwiftUI
import Speech

struct TaskListView<Task: TodoProtocol, Response: ResponseProtocol>: View {
    
    @ObservedObject var presenter: TaskListPresenter<Task, Response>
    @StateObject private var speechHelper = SpeechRecognizerHelper()
    @State private var searchInput: String = ""
    
    var filteredTasks: [Task] {
        let base = searchInput.isEmpty
        ? presenter.tasks
        : presenter.tasks.filter {
            ($0.title?.localizedCaseInsensitiveContains(searchInput) ?? false) ||
            $0.todo.localizedCaseInsensitiveContains(searchInput)
        }
        
        // Sort by id (assuming id is Comparable, e.g. UUID or Int)
        return base.sorted { $0.id < $1.id }
    }    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchView()
                
                listView()
                
                bottomView()
            }
            .navigationTitle("Задачи")
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


// view builder methods
extension TaskListView {
    
    @ViewBuilder
    fileprivate func searchView() -> some View {
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
    }
    
    @ViewBuilder
    fileprivate func listView() -> some View {
        Group {
            if #available(iOS 17.0, *) {
                List(filteredTasks, id: \.id) { task in
                    HStack(alignment: .center) {
                        Image(systemName: (!task.completed ? "circle" : "checkmark.circle"))
                            .resizable()
                            .foregroundStyle(!task.completed ? .appWhite : .accent)
                            .frame(width: 24, height: 24)
                        preview(task)
                    }
                    
                    .listRowBackground(Color(.systemBackground))
                    .contextMenu(menuItems: {
                        VStack {
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Редактировать")
                                    Spacer()
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Поделиться")
                                    Spacer()
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Удалить")
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                                .foregroundStyle(.red)
                            }
                        }
                    },
                        preview: {
                        ZStack {
                            HStack {
                                preview(task)
                                    .padding()
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 32)
                            .cornerRadius(4)
                            .background(.appGray)
                        }
                        .background {
                            LinearGradient(
                                colors: [.blue, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .ignoresSafeArea()
                        }
                        .ignoresSafeArea()
                    })
                }
                .listSectionSpacing(0)
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
            } else {
                List(filteredTasks, id: \.id) { task in
                    HStack(alignment: .center) {
                        Image(systemName: (!task.completed ? "circle" : "checkmark.circle"))
                            .resizable()
                            .foregroundStyle(!task.completed ? .appWhite : .accent)
                            .frame(width: 24, height: 24)
                        preview(task)
                    }
                    .listRowBackground(Color(.systemBackground))
                    .contextMenu(menuItems: {
                        VStack {
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Редактировать")
                                    Spacer()
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Поделиться")
                                    Spacer()
                                    Image(systemName: "square.and.arrow.up")
                                }
                            }
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("Удалить")
                                    Spacer()
                                    Image(systemName: "trash")
                                }
                                .foregroundStyle(.red)
                            }
                        }
                    },
                        preview: {
                        ZStack {
                            HStack {
                                preview(task)
                                    .padding()
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width - 32)
                            .cornerRadius(4)
                            .background(.appGray)
                        }
                        .background {
                            LinearGradient(
                                colors: [.blue, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .ignoresSafeArea()
                        }
                        .ignoresSafeArea()
                    })
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
            }
        }
    }
    
    fileprivate func bottomView() -> some View {
        return ZStack {
            
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
        .ignoresSafeArea()
        .frame(height: 49)
        .padding(.horizontal)
        .background(.appGray)
    }
    
    @ViewBuilder
    private func preview(_ task: Task) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            if let title = task.title, !title.isEmpty {
                Text(title)
                    .font(.system(size: 16))
                    .strikethrough(task.completed)
                    .fontWeight(.medium)
            }
            
            Text(task.todo)
                .font(.system(size: 12))
                .strikethrough((task.title == nil || task.title?.isEmpty == true) && task.completed)
                .fontWeight(.regular)
            
            if let description = task.title, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            //                            if let date = task.date {
            Text((task.date ?? Date()).formatted(date: .numeric, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
            //                            }
        }
        .foregroundStyle(.appWhite.opacity(!task.completed ? 1 : 0.5))
    }
    
}

internal import CoreData
#Preview {
    let persistenceController = PersistenceController.shared
    ContentView()
        .colorScheme(.dark)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
}
