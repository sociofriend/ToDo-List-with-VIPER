//
//  TaskDetailsView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import SwiftUI

struct TaskDetailsView<Task: TodoProtocol>: View {
    
    @Binding var task: Task
    
    private var titleBinding: Binding<String> {
        Binding(
            get: { task.title ?? "" },
            set: { task.title = $0 }
        )
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let date = task.date {
            return formatter.string(from: date)
        } else {
            return "No date"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Title..", text: titleBinding)
            .font(.system(size: 34, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.vertical, 4)
            
            Text(dateString)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.appWhite.opacity(0.5))

            
            TextField("Description..", text: $task.todo)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.leading)
        }
    }
}


#Preview {
    @State var sampleTask = TodoDTO(id: 87, todo: "Todo title", completed: false, userId: 99)
    return TaskDetailsView<TodoDTO>(task: $sampleTask)
}

