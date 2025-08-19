//
//  TaskDetailsView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import SwiftUI

struct TaskDetailsView: View {
    @Binding var title: String
    @Binding var todo: String
    @Binding var date: Date
    
    var onDismiss: () -> Void
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Title..", text: Binding(get: { 
                title
            }, set: { newTitle in
                title = newTitle
            }))
            .font(.system(size: 34, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.vertical, 4)
            
            Text(dateString)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.appWhite.opacity(0.5))

            
            TextField("Description..", text: Binding(get: { 
                todo
            }, set: { newTodo in
                todo = newTodo
            }))
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { 
                HStack {
                    Image(systemName: "chevron.left")
                    Button("Назад") { 
                        onDismiss()
                    }
                }
                .foregroundStyle(.accent)
            }
        }
    }
}
