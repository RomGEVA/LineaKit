import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    
    @State private var title = ""
    @State private var content = ""
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
                    
                    Text("New notes")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    
                    Spacer()
                    
                    Button("Save") {
                        saveNote()
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
                        "Note title",
                        icon: "textformat",
                        text: $title
                    )
                    
                    ModernTextField(
                        "Note description",
                        icon: "note.text",
                        text: $content,
                        isMultiline: true
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.bottom)
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Failed to save note")
        }
    }
    
    private func saveNote() {
        let note = Note(
            title: title,
            content: content,
            date: Date(),
            isFavorite: false
        )
        
        dataManager.addNote(note, to: Date())
        dismiss()
    }
}

#Preview {
    AddNoteView()
} 
