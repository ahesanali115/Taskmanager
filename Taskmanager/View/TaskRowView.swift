import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    var task: TaskItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Checkmark Completion Button
            Button(action: {
                withAnimation(.spring()) {
                    viewModel.toggleComplete(task: task)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .secondary)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .strikethrough(task.isCompleted, color: .secondary)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                
                if !task.details.isEmpty {
                    Text(task.details)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    Label(task.subject.rawValue, systemImage: task.subject.iconName)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.purple.opacity(0.1))
                        .foregroundColor(.purple)
                        .cornerRadius(6)
                    
                    Text("+\(task.rewardXP) XP")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("+\(task.rewardGems) Gems")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}
