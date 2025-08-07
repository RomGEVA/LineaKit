import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Published var dayEntries: [DayEntry] = []
    @Published var settings: AppSettings = AppSettings()
    @Published var currentDate: Date = Date()
    
    private let dayEntriesKey = "dayEntries"
    private let settingsKey = "appSettings"
    
    private init() {
        loadData()
    }
    
    // MARK: - Data Loading
    private func loadData() {
        loadDayEntries()
        loadSettings()
    }
    
    private func loadDayEntries() {
        if let data = UserDefaults.standard.data(forKey: dayEntriesKey),
           let entries = try? JSONDecoder().decode([DayEntry].self, from: data) {
            self.dayEntries = entries
        } else {
            // Create default entry for today
            let defaultEntry = DayEntry(
                date: Date(),
                notes: [],
                tasks: [],
                quote: Quote(
                    text: "Every day is a new page in the book of life",
                    author: "Unknown author"
                ),
                mood: nil
            )
            self.dayEntries = [defaultEntry]
        }
    }
    
    private func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = settings
        }
    }
    
    // MARK: - Data Saving
    private func saveDayEntries() {
        if let data = try? JSONEncoder().encode(dayEntries) {
            UserDefaults.standard.set(data, forKey: dayEntriesKey)
        }
    }
    
    private func saveSettings() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }
    
    // MARK: - Day Entry Management
    func getDayEntry(for date: Date) -> DayEntry {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if let existingEntry = dayEntries.first(where: { entry in
            calendar.isDate(entry.date, inSameDayAs: startOfDay)
        }) {
            return existingEntry
        } else {
            let newEntry = DayEntry(
                date: startOfDay,
                notes: [],
                tasks: [],
                quote: Quote(
                    text: settings.defaultQuote,
                    author: settings.defaultAuthor
                ),
                mood: nil
            )
            dayEntries.append(newEntry)
            saveDayEntries()
            return newEntry
        }
    }
    
    func updateDayEntry(_ entry: DayEntry) {
        if let index = dayEntries.firstIndex(where: { $0.id == entry.id }) {
            dayEntries[index] = entry
            saveDayEntries()
        }
    }
    
    func addNote(_ note: Note, to date: Date) {
        var entry = getDayEntry(for: date)
        entry.notes.append(note)
        updateDayEntry(entry)
    }
    
    func updateNote(_ note: Note, in date: Date) {
        var entry = getDayEntry(for: date)
        if let index = entry.notes.firstIndex(where: { $0.id == note.id }) {
            entry.notes[index] = note
            updateDayEntry(entry)
        }
    }
    
    func deleteNote(_ note: Note, from date: Date) {
        var entry = getDayEntry(for: date)
        entry.notes.removeAll { $0.id == note.id }
        updateDayEntry(entry)
    }
    
    func addTask(_ task: Task, to date: Date) {
        var entry = getDayEntry(for: date)
        entry.tasks.append(task)
        updateDayEntry(entry)
    }
    
    func updateTask(_ task: Task, in date: Date) {
        var entry = getDayEntry(for: date)
        if let index = entry.tasks.firstIndex(where: { $0.id == task.id }) {
            entry.tasks[index] = task
            updateDayEntry(entry)
        }
    }
    
    func deleteTask(_ task: Task, from date: Date) {
        var entry = getDayEntry(for: date)
        entry.tasks.removeAll { $0.id == task.id }
        updateDayEntry(entry)
    }
    
    func updateQuote(_ quote: Quote, for date: Date) {
        var entry = getDayEntry(for: date)
        entry.quote = quote
        updateDayEntry(entry)
    }
    
    func updateMood(_ mood: Int, for date: Date) {
        var entry = getDayEntry(for: date)
        entry.mood = mood
        updateDayEntry(entry)
    }
    
    // MARK: - Settings Management
    func updateSettings(_ newSettings: AppSettings) {
        settings = newSettings
        saveSettings()
    }
    
    func completeOnboarding() {
        settings.isOnboardingCompleted = true
        hasCompletedOnboarding = true
        saveSettings()
    }
    
    func toggleDarkMode() {
        settings.isDarkMode.toggle()
        saveSettings()
    }
    
    func toggleNotifications() {
        settings.enableNotifications.toggle()
        saveSettings()
    }
    
    // MARK: - Data Reset
    func resetAllData() {
        dayEntries = []
        settings = AppSettings()
        UserDefaults.standard.removeObject(forKey: dayEntriesKey)
        UserDefaults.standard.removeObject(forKey: settingsKey)
    }
    
    // MARK: - Statistics
    func getCompletedTasksCount(for date: Date) -> Int {
        let entry = getDayEntry(for: date)
        return entry.tasks.filter { $0.isCompleted }.count
    }
    
    func getTotalTasksCount(for date: Date) -> Int {
        let entry = getDayEntry(for: date)
        return entry.tasks.count
    }
    
    func getNotesCount(for date: Date) -> Int {
        let entry = getDayEntry(for: date)
        return entry.notes.count
    }
    
    // MARK: - Convenience Methods
    func getEntry(for date: Date) -> DayEntry {
        return getDayEntry(for: date)
    }
    
    func toggleTaskCompletion(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        
        // Find the entry containing this task
        if let entryIndex = dayEntries.firstIndex(where: { entry in
            entry.tasks.contains { $0.id == task.id }
        }) {
            if let taskIndex = dayEntries[entryIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                dayEntries[entryIndex].tasks[taskIndex] = updatedTask
                saveDayEntries()
            }
        }
    }
} 
