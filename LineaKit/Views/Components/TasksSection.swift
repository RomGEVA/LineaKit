import SwiftUI

struct TasksSection: View {
    let date: Date
    @Binding var showingAddTask: Bool
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        let entry = dataManager.getDayEntry(for: date)
        
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "checklist")
                        .foregroundColor(Color("AccentColor"))
                    Text("Task")
                        .font(.custom("Georgia", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextPrimary"))
                    Spacer()
                    
                    Button(action: {
                        showingAddTask = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("AccentColor"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Progress bar
                if !entry.tasks.isEmpty {
                    ProgressView(value: progressValue, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color("AccentColor")))
                        .frame(height: 4)
                        .background(Color("BorderColor").opacity(0.3))
                        .cornerRadius(2)
                    
                    Text("\(completedTasksCount) of \(totalTasksCount) done")
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(Color("TextSecondary"))
                }
                
                // Tasks list
                if entry.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checklist")
                            .font(.system(size: 40))
                            .foregroundColor(Color("TextSecondary").opacity(0.5))
                        
                        Text("No task")
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color("TextSecondary"))
                        
                        ModernButton("Add task", style: .secondary) {
                            showingAddTask = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    VStack(spacing: 8) {
                        ForEach(entry.tasks.prefix(5)) { task in
                            TaskRowView(task: task, date: date)
                        }
                        
                        if entry.tasks.count > 5 {
                            Button(action: {
                                // Navigate to full tasks list
                            }) {
                                Text("Shall all (\(entry.tasks.count))")
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(Color("AccentColor"))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
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

struct TaskRowView: View {
    let task: Task
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditTask = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            ModernCheckbox(isChecked: Binding(
                get: { task.isCompleted },
                set: { newValue in
                    var updatedTask = task
                    updatedTask.isCompleted = newValue
                    dataManager.updateTask(updatedTask, in: date)
                }
            ), title: "")
            
            // Task content
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color("TextPrimary"))
                    .strikethrough(task.isCompleted)
                    .opacity(task.isCompleted ? 0.6 : 1.0)
                
                HStack(spacing: 8) {
                    // Priority indicator
                    Circle()
                        .fill(Color(task.priority.color))
                        .frame(width: 8, height: 8)
                    
                    Text(task.priority.displayName)
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(Color("TextSecondary"))
                    
                    Spacer()
                    
                    Text(task.date, style: .time)
                        .font(.custom("Georgia", size: 12))
                        .foregroundColor(Color("TextSecondary").opacity(0.7))
                }
            }
            
            Spacer()
            
            // Edit button
            Button(action: {
                showingEditTask = true
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(12)
        .background(Color("BackgroundColor"))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("BorderColor").opacity(0.5), lineWidth: 1)
        )
        .sheet(isPresented: $showingEditTask) {
            EditTaskView(task: task, date: date)
        }
    }
}

#Preview {
    TasksSection(date: Date(), showingAddTask: .constant(false))
} 
