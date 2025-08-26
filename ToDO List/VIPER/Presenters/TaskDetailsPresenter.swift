// TaskDetailsPresenter.swift
// VIPER Presenter for TaskDetails

import Foundation
import SwiftUI
import Combine

class TaskDetailsPresenter: ObservableObject {
    // Published properties to bind to the view
    @Published var title: String
    @Published var todo: String
    let date: Date
    
    // Reference to the interactor and router
    private let interactor: TaskDetailsInteractorProtocol
    private let router: TaskDetailsRouterProtocol
    
    // For view to call when dismissing
    let onDismiss: (String, String) -> Void
    
    init(title: String, todo: String, date: Date, interactor: TaskDetailsInteractorProtocol, router: TaskDetailsRouterProtocol, onDismiss: @escaping (String, String) -> Void) {
        self.title = title
        self.todo = todo
        self.date = date
        self.interactor = interactor
        self.router = router
        self.onDismiss = onDismiss
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func handleDismiss() {
        // Could add validation/business logic here
        onDismiss(title, todo)
    }
}

protocol TaskDetailsPresenterProtocol: ObservableObject {
    var title: String { get set }
    var todo: String { get set }
    var dateString: String { get }
    func handleDismiss()
}
