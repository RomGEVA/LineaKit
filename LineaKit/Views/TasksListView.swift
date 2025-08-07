import SwiftUI

struct TasksListView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddTask = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Text("Tasks")
                        .font(.custom("Georgia", size: 28))
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextPrimary"))
                    
                    ModernDaySwitcher(selectedDate: $selectedDate)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        let entry = dataManager.getDayEntry(for: selectedDate)
                        
                        if entry.tasks.isEmpty {
                            EmptyTasksView(showingAddTask: $showingAddTask)
                        } else {
                            // Progress summary
                            ProgressSummaryView(date: selectedDate)
                            
                            // Tasks list
                            ForEach(entry.tasks) { task in
                                TaskDetailView(task: task, date: selectedDate)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .padding(.top, 70)
        }
        .ignoresSafeArea()
        .navigationTitle("Tasks")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
    }
}

struct EmptyTasksView: View {
    @Binding var showingAddTask: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(Color("TextSecondary").opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No task")
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextPrimary"))
                
                Text("Create your first task")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
            }
            
            ModernButton("Add task") {
                showingAddTask = true
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct ProgressSummaryView: View {
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ModernCard {
            VStack(spacing: 12) {
                HStack {
                    Text("Progress of the day")
                        .font(.custom("Georgia", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextPrimary"))
                    
                    Spacer()
                    
                    Text("\(completedTasksCount)/\(totalTasksCount)")
                        .font(.custom("Georgia", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color("AccentColor"))
                }
                
                ProgressView(value: progressValue, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("AccentColor")))
                    .frame(height: 6)
                    .background(Color("BorderColor").opacity(0.3))
                    .cornerRadius(3)
                
                Text("\(Int(progressValue * 100))% done")
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(Color("TextSecondary"))
            }
        }
    }
    
    private var completedTasksCount: Int {
        dataManager.getCompletedTasksCount(for: date)
    }
    
    private var totalTasksCount: Int {
        dataManager.getTotalTasksCount(for: date)
    }
    
    private var progressValue: Double {
        totalTasksCount > 0 ? Double(completedTasksCount) / Double(totalTasksCount) : 0.0
    }
}

struct TaskDetailView: View {
    let task: Task
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditTask = false
    
    var body: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color("TextPrimary"))
                            .strikethrough(task.isCompleted)
                            .opacity(task.isCompleted ? 0.6 : 1.0)
                        
                        Text(task.date, style: .time)
                            .font(.custom("Georgia", size: 12))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditTask = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Priority and status
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(task.priority.color))
                            .frame(width: 10, height: 10)
                        
                        Text(task.priority.displayName)
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 6) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 16))
                            .foregroundColor(task.isCompleted ? Color.green : Color("TextSecondary"))
                        
                        Text(task.isCompleted ? "Done" : "In progress")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(task.isCompleted ? Color.green : Color("TextSecondary"))
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditTask) {
            EditTaskView(task: task, date: date)
        }
    }
}

#Preview {
    TasksListView()
} 
