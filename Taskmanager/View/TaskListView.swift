import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    @State private var selectedFilter: TaskFilter = .all
    @State private var showingAddTask = false
    
    enum TaskFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
        var id: String { self.rawValue }
    }
    
    var filteredTasks: [TaskItem] {
        switch selectedFilter {
        case .all:
            return viewModel.tasks
        case .active:
            return viewModel.tasks.filter { !$0.isCompleted }
        case .completed:
            return viewModel.tasks.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Segmented Control
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredTasks) { task in
                        TaskRowView(task: task)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("All Quests")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddEditTaskView()
            }
        }
    }
}
