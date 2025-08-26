//
//  TaskDetailsView.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 19.08.25.
//

import SwiftUI

// VIPER View

struct TaskDetailsView: View {
    @ObservedObject var presenter: TaskDetailsPresenter

    var body: some View {
        VStack(alignment: .leading) {
            // Minimal UI placeholder, all logic handled by presenter
            TextField("Title..", text: $presenter.title)
            Text(presenter.dateString)
                .foregroundStyle(.appWhite.opacity(0.5))
            
            TextEditor(text: $presenter.todo)
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Button("Back") {
                        presenter.onDismiss(presenter.title, presenter.todo)
                    }
                }
                .foregroundStyle(.accent)
            }
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

