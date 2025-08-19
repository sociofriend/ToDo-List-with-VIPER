//
//  TaskDetailsView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import SwiftUI

struct TaskDetailsView<Task: TodoProtocol>: View {
    
    @Binding var task: Task
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: task.date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Title..", text: $task.title)
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
