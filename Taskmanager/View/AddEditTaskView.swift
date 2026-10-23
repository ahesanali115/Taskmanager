import SwiftUI

struct AddEditTaskView: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var subject: Subject = .math
    @State private var priority: Priority = .medium
    @State private var dueDate: Date = Date().addingTimeInterval(3600 * 3)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quest Info")) {
                    TextField("Quest Title (e.g. Physics Homework)", text: $title)
                    TextField("Description or Notes (Optional)", text: $details)
                }
                
                Section(header: Text("Category & Priority")) {
                    Picker("Subject", selection: $subject) {
                        ForEach(Subject.allCases) { subj in
                            Label(subj.rawValue, systemImage: subj.iconName).tag(subj)
                        }
                    }
                    
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { pri in
                            Text(pri.rawValue).tag(pri)
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Deadline", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationTitle("New Quest")
            .toolbar {
                ToolbarItem(placement: sobretudoBarPlacement(cancel: true)) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: sobretudoBarPlacement(cancel: false)) {
                    Button("Create") {
                        guard !title.isEmpty else { return }
                        viewModel.addTask(title: title, details: details, subject: subject, dueDate: dueDate, priority: priority)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func sobretudoBarPlacement(cancel: Bool) -> ToolbarItemPlacement {
        return cancel ? .cancellationAction : .confirmationAction
    }
}
