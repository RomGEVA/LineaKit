import SwiftUI

struct HomeView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDate = Date()
    @State private var dragOffset: CGFloat = 0
    @State private var showingAddNote = false
    @State private var showingAddTask = false
    
    private var entry: DayEntry {
        dataManager.getEntry(for: selectedDate)
    }
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with date navigation
                        dateNavigationHeader
                        
                        // Quote card
                        quoteCard
                        
                        // Mood tracker
                        moodTrackerCard
                        
                        // Statistics
                        statisticsCard
                        
                        // Notes section
                        notesSection
                        
                        // Tasks section
                        tasksSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 70)
                }
                .scrollContentBackground(.hidden)
            }
            .padding(.top, 70)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddNote) {
            AddNoteView()
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
    
    // MARK: - Date Navigation Header
    private var dateNavigationHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text(selectedDate, style: .date)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                ModernCard(padding: 0) {
                    Color.clear
                }
            )
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if value.translation.width > 50 {
                                selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                            } else if value.translation.width < -50 {
                                selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                            }
                            dragOffset = 0
                        }
                    }
            )
        }
    }
    
    // MARK: - Quote Card
    private var quoteCard: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                    
                    Text("Quote of the day")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    Spacer()
                }
                
                Text(entry.quote?.text ?? "Every day is a new page in the book of life")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                
                HStack {
                    Spacer()
                    
                    Text("— \(entry.quote?.author ?? "Author not specified")")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
            }
        }
    }
    
    // MARK: - Mood Tracker Card
    private var moodTrackerCard: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                    
                    Text("Mood")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    Spacer()
                }
                
                ModernMoodPicker(selectedMood: Binding(
                    get: { entry.mood },
                    set: { newMood in
                        if let mood = newMood {
                            dataManager.updateMood(mood, for: selectedDate)
                        }
                    }
                ), title: "")
            }
        }
    }
    
    // MARK: - Statistics Card
    private var statisticsCard: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                    
                    Text("Statistics")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    StatItem(
                        icon: "note.text",
                        title: "Notes",
                        value: "\(entry.notes.count)",
                        color: Color(red: 0.4, green: 0.6, blue: 0.8)
                    )
                    
                    StatItem(
                        icon: "checklist",
                        title: "Tasks",
                        value: "\(entry.tasks.count)",
                        color: Color(red: 0.6, green: 0.8, blue: 0.4)
                    )
                    
                    StatItem(
                        icon: "checkmark.circle",
                        title: "Done",
                        value: "\(entry.tasks.filter { $0.isCompleted }.count)",
                        color: Color(red: 0.8, green: 0.6, blue: 0.4)
                    )
                }
            }
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ModernSectionHeader(title: "Note", icon: "note.text") {
                showingAddNote = true
            }
            
            if entry.notes.isEmpty {
                ModernEmptyState(
                    icon: "note.text",
                    title: "No notes",
                    subtitle: "Add your first note for this day"
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(entry.notes.prefix(3)) { note in
                        NoteCard(note: note, date: selectedDate)
                    }
                    
                    if entry.notes.count > 3 {
                        NavigationLink(destination: NotesListView()) {
                            HStack {
                                Text("Show all (\(entry.notes.count))")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Tasks Section
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ModernSectionHeader(title: "Taskl", icon: "checklist") {
                showingAddTask = true
            }
            
            if entry.tasks.isEmpty {
                ModernEmptyState(
                    icon: "checklist",
                    title: "No task",
                    subtitle: "Add your first task for the day"
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(entry.tasks.prefix(3)) { task in
                        TaskCard(task: task, date: selectedDate)
                    }
                    
                    if entry.tasks.count > 3 {
                        NavigationLink(destination: TasksListView()) {
                            HStack {
                                Text("Show all (\(entry.tasks.count))")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
} 
