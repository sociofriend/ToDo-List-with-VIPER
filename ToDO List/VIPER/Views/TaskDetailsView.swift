//
//  TaskDetailsView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import SwiftUI

struct TaskDetailsView: View {
    @State var title: String 
    @State var todo: String
    var date: Date
    
    var onDismiss: (String,String) -> Void
    
    init(title: String, todo: String, date: Date, onDismiss: @escaping (String, String) -> Void) {
        self._title = State(wrappedValue: title)
        self._todo = State(wrappedValue: todo)
        self.date = date
        self.onDismiss = onDismiss
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Title..", text: $title)
            .font(.system(size: 34, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.vertical, 4)
            
            Text(dateString)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.appWhite.opacity(0.5))

            
            TextEditor(text: $todo)
                .font(.system(size: 16, weight: .regular))
                .multilineTextAlignment(.leading)
                .frame(minHeight: 100) // so it looks like a text area
                .padding(.vertical, 4)
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { 
                HStack {
                    Image(systemName: "chevron.left")
                    Button("Назад") { 
                        onDismiss(title, todo)
                    }
                }
                .foregroundStyle(.accent)
            }
        }
    }
}


struct NewTaskDetailsView: View {
    
    @State var title: String = ""
    @State var todo: String = ""
    var date: Date =  Date()
    
    var onDismiss: (String,String) -> Void
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            TextField("Title..", text: $title)
            .font(.system(size: 34, weight: .bold))
            .multilineTextAlignment(.leading)
            .padding(.vertical, 4)
            
            Text(dateString)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.appWhite.opacity(0.5))
            
            
            TextField("Description..", text: $todo)
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
                        onDismiss(title, todo)
                    }
                }
                .foregroundStyle(.accent)
            }
        }
    }
}
