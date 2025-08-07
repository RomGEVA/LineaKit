import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: TaskPriority = .medium
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    
                    Spacer()
                    
                    Text("New task")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    Spacer()
                    
                    Button("Save") {
                        saveTask()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(title.isEmpty ? Color(red: 0.5, green: 0.5, blue: 0.5) : Color(red: 0.4, green: 0.6, blue: 0.8))
                    .disabled(title.isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Form
                VStack(spacing: 20) {
                    ModernTextField(
                        "New task",
                        icon: "checklist",
                        text: $title
                    )
                    
                    ModernTextField(
                        "Description (optional)",
                        icon: "text.alignleft",
                        text: $description,
                        isMultiline: true
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Priority")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                        
                        ModernPriorityPicker(selectedPriority: $priority)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.bottom)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .alert("Fail", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Fail to save")
        }
    }
    
    private func saveTask() {
        let task = Task(
            title: title,
            isCompleted: false,
            date: Date(),
            priority: priority
        )
        
        dataManager.addTask(task, to: Date())
        dismiss()
    }
}

#Preview {
    AddTaskView()
} 
