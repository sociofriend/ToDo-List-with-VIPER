//
//  BackButton.swift
//  ToDO List
//
//  Created by Lilit Avdalyan on 31.08.25.
//


import SwiftUI

struct BackButton: View {
    let action: () -> Void
    var label: String = "Back"
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
            Text(label)
        }
        .foregroundStyle(.accent)
    }
}