import Foundation
import SwiftUI
import Combine

class TaskManagerViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet { saveTasks() }
    }
    @Published var profile: StudentProfile = StudentProfile.defaultProfile {
        didSet { saveProfile() }
    }
    
    // Popup reward alert state
    @Published var showRewardPopup: Bool = false
    @Published var lastEarnedXP: Int = 0
    @Published var lastEarnedGems: Int = 0
    @Published var leveledUpAlert: Bool = false
    
    private let tasksKey = "saved_tasks_key"
    private let profileKey = "saved_profile_key"
    
    init() {
        loadTasks()
        loadProfile()
        if tasks.isEmpty {
            loadSampleData()
        }
    }
    
    // MARK: - Task Actions
    func addTask(title: String, details: String, subject: Subject, dueDate: Date, priority: Priority) {
        let baseXP = priority == .high ? 100 : (priority == .medium ? 60 : 30)
        let baseGems = priority == .high ? 30 : (priority == .medium ? 15 : 5)
        
        let newTask = TaskItem(
            title: title,
            details: details,
            subject: subject,
            dueDate: dueDate,
            priority: priority,
            rewardXP: baseXP,
            rewardGems: baseGems
        )
        tasks.insert(newTask, at: 0)
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func toggleComplete(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            
            if tasks[index].isCompleted {
                awardRewards(xp: tasks[index].rewardXP, gems: tasks[index].rewardGems)
            }
        }
    }
    
    private func awardRewards(xp: Int, gems: Int) {
        profile.currentXP += xp
        profile.gems += gems
        
        lastEarnedXP = xp
        lastEarnedGems = gems
        showRewardPopup = true
        
        // Check Level Up
        if profile.currentXP >= profile.nextLevelXP {
            profile.currentXP -= profile.nextLevelXP
            profile.currentLevel += 1
            leveledUpAlert = true
        }
    }
    
    // MARK: - Shop Actions
    func purchaseReward(item: RewardItem) -> Bool {
        if profile.gems >= item.gemCost, let index = profile.inventory.firstIndex(where: { $0.id == item.id }) {
            profile.gems -= item.gemCost
            profile.inventory[index].isPurchased = true
            return true
        }
        return false
    }
    
    // MARK: - Persistence (UserDefaults)
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) {
            tasks = decoded
        }
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(StudentProfile.self, from: data) {
            profile = decoded
        }
    }
    
    private func loadSampleData() {
        tasks = [
            TaskItem(title: "Complete Calculus Problem Set", details: "Exercises 4 through 12 on derivatives", subject: .math, dueDate: Date().addingTimeInterval(3600 * 4), priority: .high, rewardXP: 100, rewardGems: 30),
            TaskItem(title: "Read Physics Chapter 5", details: "Focus on electromagnetic waves", subject: .science, dueDate: Date().addingTimeInterval(3600 * 24), priority: .medium, rewardXP: 60, rewardGems: 15),
            TaskItem(title: "History Essay Draft", details: "Write 500 words on the Renaissance", subject: .history, dueDate: Date().addingTimeInterval(3600 * 48), priority: .high, rewardXP: 120, rewardGems: 40),
            TaskItem(title: "Finish SwiftUI Layout", details: "Implement profile view cards", subject: .coding, dueDate: Date().addingTimeInterval(3600 * 2), priority: .low, rewardXP: 30, rewardGems: 10)
        ]
    }
}
