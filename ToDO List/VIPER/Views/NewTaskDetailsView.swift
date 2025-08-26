import SwiftUI

struct NewTaskDetailsView: View {
    @State private var title: String = ""
    @State private var todo: String = ""
    let onSave: (String, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $title)
            
            Text("Date: \(Date(), format: Date.FormatStyle().day().month().year())")
                .padding(.top)
                .foregroundStyle(.appWhite.opacity(0.5))
            
            TextEditor(text: $todo)
            
            Spacer()
        }
        .padding()
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                    Button("Back") {
                        onSave(title, todo)
                    }
                }
            }
        }
    }
}

#Preview {
    NewTaskDetailsView { title, todo in
        print("Back pressed with title: \(title), todo: \(todo)")
    }
}
