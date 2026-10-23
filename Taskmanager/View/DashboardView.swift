import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: TaskManagerViewModel
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Profile HUD Card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(.purple)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(viewModel.profile.name)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text(viewModel.profile.titleRank)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // Streak & Gems Pills
                                VStack(alignment: .trailing, spacing: 6) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                        Text("\(viewModel.profile.streakDays) Days")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.15))
                                    .cornerRadius(12)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "gem.fill")
                                            .foregroundColor(.cyan)
                                        Text("\(viewModel.profile.gems)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.cyan.opacity(0.15))
                                    .cornerRadius(12)
                                }
                            }
                            
                            Divider()
                            
                            // XP Progress Bar & Level
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Level \(viewModel.profile.currentLevel)")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                    Spacer()
                                    Text("\(viewModel.profile.currentXP) / \(viewModel.profile.nextLevelXP) XP")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geometry.size.width, height: 10)
                                            .opacity(0.1)
                                            .foregroundColor(.purple)
                                        
                                        Rectangle()
                                            .frame(width: min(CGFloat(viewModel.profile.xpProgressRatio) * geometry.size.width, geometry.size.width), height: 10)
                                            .foregroundColor(.purple)
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(height: 10)
                                .cornerRadius(5)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                        
                        // Today's Active Quests Section Header
                        HStack {
                            Text("Today's Active Quests")
                                .font(.headline)
                            Spacer()
                            Button(action: { showingAddTask = true }) {
                                Label("Add Task", systemImage: "plus.circle.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        // Tasks List Preview
                        let activeTasks = viewModel.tasks.filter { !$0.isCompleted }
                        if activeTasks.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.green)
                                Text("All Quests Completed!")
                                    .font(.headline)
                                Text("Enjoy your free time or visit the shop.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 40)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(activeTasks) { task in
                                    TaskRowView(task: task)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // Reward Alert Popup Overlay
                if viewModel.showRewardPopup {
                    RewardPopupView(xp: viewModel.lastEarnedXP, gems: viewModel.lastEarnedGems, isPresented: $viewModel.showRewardPopup)
                }
            }
            .navigationTitle("Quest Hub")
            .sheet(isPresented: $showingAddTask) {
                AddEditTaskView()
            }
            .alert("🎉 Level Up!", isPresented: $viewModel.leveledUpAlert) {
                Button("Awesome!", role: .cancel) { }
            } message: {
                Text("Congratulations! You've reached Level \(viewModel.profile.currentLevel). Keep crushing your goals!")
            }
        }
    }
}
