import Foundation

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: String { self.rawValue }
    
    var colorHex: String {
        switch self {
        case .low: return "34C759"      // Green
        case .medium: return "FF9500"   // Orange
        case .high: return "FF3B30"     // Red
        }
    }
}

enum Subject: String, Codable, CaseIterable, Identifiable {
    case math = "Mathematics"
    case science = "Science"
    case history = "History"
    case coding = "Coding & CS"
    case language = "Languages"
    case general = "General"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .math: return "function"
        case .science: return "atom"
        case .history: return "book.closed.fill"
        case .coding: return "laptopcomputer"
        case .language: return "character.book.closed"
        case .general: return "checklist"
        }
    }
}

struct TaskItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var details: String
    var subject: Subject
    var dueDate: Date
    var priority: Priority
    var isCompleted: Bool = false
    var rewardXP: Int
    var rewardGems: Int
    
    init(title: String, details: String = "", subject: Subject, dueDate: Date, priority: Priority, rewardXP: Int = 50, rewardGems: Int = 15) {
        self.title = title
        self.details = details
        self.subject = subject
        self.dueDate = dueDate
        self.priority = priority
        self.rewardXP = rewardXP
        self.rewardGems = rewardGems
    }
}
