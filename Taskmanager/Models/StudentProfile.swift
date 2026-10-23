import Foundation

struct RewardItem: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var gemCost: Int
    var iconName: String
    var isPurchased: Bool = false
}

struct StudentProfile: Codable {
    var name: String
    var currentXP: Int
    var currentLevel: Int
    var gems: Int
    var streakDays: Int
    var lastActiveDate: Date?
    var inventory: [RewardItem]
    
    var nextLevelXP: Int {
        return currentLevel * 200 // Scaling requirement per level
    }
    
    var xpProgressRatio: Double {
        return Double(currentXP) / Double(nextLevelXP)
    }
    
    var titleRank: String {
        switch currentLevel {
        case 1...2: return "Novice Scholar"
        case 3...4: return "Adept Apprentice"
        case 5...7: return "Honor Student"
        case 8...10: return "Master Academic"
        default: return "Legendary Scholar"
        }
    }
    
    static var defaultProfile = StudentProfile(
        name: "Alex",
        currentXP: 120,
        currentLevel: 1,
        gems: 45,
        streakDays: 3,
        lastActiveDate: Date(),
        inventory: [
            RewardItem(name: "30 Min Gaming", description: "Treat yourself to 30 minutes of video games", gemCost: 50, iconName: "gamecontroller.fill"),
            RewardItem(name: "Favorite Snack", description: "Grab your favorite candy or treat", gemCost: 30, iconName: "fork.knife"),
            RewardItem(name: "Custom Theme Color", description: "Unlock neon neon-green app accents", gemCost: 100, iconName: "paintpalette.fill")
        ]
    )
}
