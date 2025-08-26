// TaskDetailsEntity.swift
// VIPER Entity for TaskDetails

import Foundation

struct TaskEntity: Identifiable {
    let id = UUID()
    var title: String
    var todo: String
    var date: Date
}
