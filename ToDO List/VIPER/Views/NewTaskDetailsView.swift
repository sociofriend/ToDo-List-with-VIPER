import SwiftUI

struct NewTaskDetailsView: View {
    @State private var title: String = ""
    @State private var todo: String = ""
    let onSave: (String, String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Title", text: $title)
                .font(.largeTitle)
            
            Text("Date: \(Date(), format: Date.FormatStyle().day().month().year())")
                .padding(.top)
                .foregroundStyle(.appWhite.opacity(0.5))
            
            TextEditor(text: $todo)
                .menuIndicator(.visible)
                .tint(.accentColor)
                .border(Color(.systemGray4), width: 1)
                
            Spacer()
        }
        .padding()
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton {
                    onSave(title, todo)
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
