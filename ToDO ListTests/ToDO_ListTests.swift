import Testing
import SwiftUI
import CoreData
@testable import ToDO_List

@MainActor
// Helper to get in-memory Core Data stack for tests
func makeTestContext() -> NSManagedObjectContext {
    PersistenceController(inMemory: true).container.viewContext
}

@MainActor
@Suite("TaskListPresenter Core Data logic")
struct TaskListPresenterCoreDataTests {
    @Test func testAddAndFetchItem() async throws {
        let context = makeTestContext()
        let interactor = TaskListInteractor<TodoDTO, TodoPresentationModel, ResponseDTO>(context: context)
        let presenter = TaskListPresenter<TodoDTO, TodoPresentationModel, ResponseDTO>(interactor: interactor)
        interactor.presenter = presenter
        presenter.addItem(id: 99, title: "New Task", todo: "Desc", completed: false, userID: 1, date: .now)
        // Wait for Core Data to process
        try await Task.sleep(nanoseconds: 300_000_000)
        interactor.fetchItems() // triggers presenter's didFetchTasks
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(presenter.tasks.contains { $0.id == 99 && $0.title == "New Task" && $0.todo == "Desc" })
    }
    @Test func testRemoveItem() async throws {
        let context = makeTestContext()
        let interactor = TaskListInteractor<TodoDTO, TodoPresentationModel, ResponseDTO>(context: context)
        let presenter = TaskListPresenter<TodoDTO, TodoPresentationModel, ResponseDTO>(interactor: interactor)
        interactor.presenter = presenter
        presenter.addItem(id: 42, title: "ToRemove", todo: "Remove me", completed: false, userID: 2, date: .now)
        try await Task.sleep(nanoseconds: 300_000_000)
        interactor.fetchItems()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(presenter.tasks.contains { $0.id == 42 })
        presenter.remove(at: 42)
        try await Task.sleep(nanoseconds: 300_000_000)
        interactor.fetchItems()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(!presenter.tasks.contains { $0.id == 42 })
    }
    @Test func testCheckboxToggle() async throws {
        let context = makeTestContext()
        let interactor = TaskListInteractor<TodoDTO, TodoPresentationModel, ResponseDTO>(context: context)
        let presenter = TaskListPresenter<TodoDTO, TodoPresentationModel, ResponseDTO>(interactor: interactor)
        interactor.presenter = presenter
        presenter.addItem(id: 7, title: "Toggle", todo: "Toggle complete", completed: false, userID: 1, date: .now)
        try await Task.sleep(nanoseconds: 300_000_000)
        interactor.fetchItems()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(presenter.tasks.first?.completed == false)
        presenter.checkboxToggled(for: 7)
        try await Task.sleep(nanoseconds: 400_000_000)
        interactor.fetchItems()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(presenter.tasks.first?.completed == true)
    }
    @Test func testDidFetchTasks() async throws {
        let context = makeTestContext()
        let interactor = TaskListInteractor<TodoDTO, TodoPresentationModel, ResponseDTO>(context: context)
        let presenter = TaskListPresenter<TodoDTO, TodoPresentationModel, ResponseDTO>(interactor: interactor)
        interactor.presenter = presenter
        presenter.addItem(id: 5, title: "A", todo: "A", completed: false, userID: 1, date: .now)
        presenter.addItem(id: 6, title: "B", todo: "B", completed: false, userID: 1, date: .now)
        try await Task.sleep(nanoseconds: 400_000_000)
        interactor.fetchItems()
        try await Task.sleep(nanoseconds: 200_000_000)
        #expect(presenter.tasks.count == 2)
        #expect(presenter.tasks.contains { $0.id == 5 })
        #expect(presenter.tasks.contains { $0.id == 6 })
    }
}

@Suite("TaskListView rendering")
struct TaskListViewTests {
    // Removed the render test that directly accessed view.body
}

#Preview {
    TaskDetailsView(title: "Hello", todo: "desc", date: .now, onDismiss: { _,_ in })
}


#Preview {
    TaskDetailsView(title: "Hello", todo: "desc", date: .now, onDismiss: { _,_ in })
}

#Preview {
    let context = makeTestContext()
    let interactor = TaskListInteractor<TodoDTO, TodoPresentationModel, ResponseDTO>(context: context)
    let presenter = TaskListPresenter<TodoDTO, TodoPresentationModel, ResponseDTO>(interactor: interactor)
    return TaskListView<TodoDTO, TodoPresentationModel, ResponseDTO>(presenter: presenter)
}
