//
//  TaskListView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 15.08.25.
//


import SwiftUI

struct TaskListView<Task: TodoProtocol, Response: ResponseProtocol>: View {
    @ObservedObject var presenter: TaskListPresenter<Task, Response>

    var body: some View {
        
        List(presenter.tasks) { task in
            HStack(alignment: .top) { 
                Image(systemName: (!task.completed ? "circle" : "checkmark.circle"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.todo)
                        .font(.headline)
                    if let description = task.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    if let date = task.date {
                        Text(date.formatted(date: .numeric, time: .omitted).description) 
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .onAppear {
            presenter.loadTasks()
        }        
    }
}
