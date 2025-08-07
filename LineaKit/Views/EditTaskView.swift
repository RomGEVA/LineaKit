import SwiftUI

struct EditTaskView: View {
    let task: Task
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var priority: TaskPriority
    @State private var isCompleted: Bool
    
    init(task: Task, date: Date) {
        self.task = task
        self.date = date
        self._title = State(initialValue: task.title)
        self._priority = State(initialValue: task.priority)
        self._isCompleted = State(initialValue: task.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                EnhancedModernGradientBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Edit task")
                            .font(.custom("Georgia", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text(task.date, style: .date)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Title field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Task name")
                                .font(.custom("Georgia", size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(Color("TextPrimary"))
                            
                            ModernTextField("Enter the task name", text: $title)
                        }
                        
                        // Priority picker
                        ModernPriorityPicker(selectedPriority: $priority)
                        
                        // Completion status
                        HStack {
                            ModernCheckbox(isChecked: $isCompleted, title: "Done")
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        ModernButton("Save changes") {
                            saveChanges()
                        }
                        .disabled(title.isEmpty)
                        .opacity(title.isEmpty ? 0.6 : 1.0)
                        
                        ModernButton("Delete task", style: .destructive) {
                            deleteTask()
                        }
                        
                        ModernButton("Cancel", style: .secondary) {
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }
    
    private func saveChanges() {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.priority = priority
        updatedTask.isCompleted = isCompleted
        
        dataManager.updateTask(updatedTask, in: date)
        dismiss()
    }
    
    private func deleteTask() {
        dataManager.deleteTask(task, from: date)
        dismiss()
    }
}
