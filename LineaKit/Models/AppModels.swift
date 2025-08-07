import Foundation

// MARK: - Note Model
struct Note: Codable, Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var date: Date
    var isFavorite: Bool
    
    init(title: String, content: String, date: Date = Date(), isFavorite: Bool = false) {
        self.title = title
        self.content = content
        self.date = date
        self.isFavorite = isFavorite
    }
}

// MARK: - Task Model
struct Task: Codable, Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var date: Date
    var priority: TaskPriority
    
    init(title: String, isCompleted: Bool = false, date: Date = Date(), priority: TaskPriority = .medium) {
        self.title = title
        self.isCompleted = isCompleted
        self.date = date
        self.priority = priority
    }
}

// MARK: - Task Priority
enum TaskPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "priorityLow"
        case .medium: return "priorityMedium"
        case .high: return "priorityHigh"
        }
    }
}

// MARK: - Quote Model
struct Quote: Codable {
    var text: String
    var author: String
    var date: Date
    
    init(text: String, author: String, date: Date = Date()) {
        self.text = text
        self.author = author
        self.date = date
    }
}

// MARK: - Day Entry Model
struct DayEntry: Codable, Identifiable {
    let id = UUID()
    var date: Date
    var notes: [Note]
    var tasks: [Task]
    var quote: Quote?
    var mood: Int? // 1-5 scale
    
    init(date: Date = Date(), notes: [Note] = [], tasks: [Task] = [], quote: Quote? = nil, mood: Int? = nil) {
        self.date = date
        self.notes = notes
        self.tasks = tasks
        self.quote = quote
        self.mood = mood
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var isOnboardingCompleted: Bool
    var isDarkMode: Bool
    var enableNotifications: Bool
    var defaultQuote: String
    var defaultAuthor: String
    
    init() {
        self.isOnboardingCompleted = false
        self.isDarkMode = false
        self.enableNotifications = true
        self.defaultQuote = "Every day is a new page in the book of life"
        self.defaultAuthor = "Unknown author"
    }
} 
