//
//  TaskListView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import SwiftUI
import Speech

struct TaskListView<Task: TodoProtocol, TaskModel: TodoPresentationProtocol, Response: ResponseProtocol>: View {
    
    @ObservedObject var presenter: TaskListPresenter<Task, TaskModel, Response>
    @StateObject private var speechHelper = SpeechRecognizerHelper()
    @State private var searchInput: String = ""
    
    @State var selectedTaskId: Int? = nil
    
    var filteredTasks: [TaskModel] {
        let base = searchInput.isEmpty
        ? presenter.tasks
        : presenter.tasks.filter {
            ($0.title.localizedCaseInsensitiveContains(searchInput)) ||
            $0.todo.localizedCaseInsensitiveContains(searchInput)
        }
        
        // Sort by id (assuming id is Comparable, e.g. UUID or Int)
        return base.sorted { $0.id < $1.id }
    }    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                if let taskId = selectedTaskId {
                    if let task = presenter.tasks.first(where: { $0.id == taskId }) {
                        TaskDetailsView(title: task.title, todo: task.todo, date: task.date) { title, todo in
                            presenter.update(
                                Task(
                                    id: Int64(task.id), 
                                    title: title, 
                                    todo: todo, 
                                    completed: task.completed, 
                                    userId: Int64(task.userId), 
                                    date: Date()))
                            selectedTaskId = nil
                        }
                        
                    } else {
                        
                        NewTaskDetailsView() { title, todo in
                            
                            presenter.addItem(
                                id: presenter.tasks.count + 1, 
                                title: title, 
                                todo: todo, 
                                completed: false, 
                                userID: presenter.tasks.count > 0 ? presenter.tasks[0].userId : 1, 
                                date: Date())
                            
                            self.selectedTaskId = nil
                        }
                    }
                } else {
                    searchView()
                    listView()
                    bottomView()
                }
            }

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
        
        
        List(filteredTasks, id: \.id) { task in
            HStack(alignment: .center) {
                Image(systemName: (task.completed ? "checkmark.circle" : "circle" ))
                    .resizable()
                    .foregroundStyle(task.completed ? .accent : .appWhite)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        // change completed in core data
                        presenter.checkboxToggled(for: task.id)
                    }
                
                preview(task)
            }
            .onTapGesture {
                selectedTaskId = task.id
            }
            .listRowBackground(Color(.systemBackground))
            .contextMenu(menuItems: {
                VStack {
                    Button {
                        selectedTaskId = task.id
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
                        presenter.remove(at: Int(task.id))
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
        .navigationTitle("Задачи")
    }
    
    fileprivate func bottomView() -> some View {
        return ZStack {
            
            Text(String("\(presenter.tasks.count) задач"))
                .frame(width: UIScreen.main.bounds.width / 3)
                .multilineTextAlignment(.center)
            
            HStack {
                Spacer()
                Button {
                    if let last = presenter.tasks.last {
                        selectedTaskId = last.id + 1
                    } else {
                        selectedTaskId = 1
                    }
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
    private func preview(_ task: TaskModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            
            if !task.title.isEmpty {
                Text(task.title)
                    .font(.system(size: 16))
                    .strikethrough(task.completed)
                    .fontWeight(.medium)
            }
            
            Text(task.todo)
                .font(.system(size: 12))
                .strikethrough((task.title.isEmpty == true) && task.completed)
                .fontWeight(.regular)
                .frame(maxHeight: 70)
            

            Text((task.date).formatted(date: .numeric, time: .omitted))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .foregroundStyle(.appWhite.opacity(!task.completed ? 1 : 0.5))
    }
    
}

//functions
extension TaskListView {
    // voice
    private func toggleRecording() {
        if speechHelper.isRecording {
            speechHelper.stopRecording()
        } else {
            speechHelper.startRecording()
        }
    }
}

internal import CoreData
#Preview {
    let persistenceController = PersistenceController.shared
    ContentView()
        .colorScheme(.dark)
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
}
