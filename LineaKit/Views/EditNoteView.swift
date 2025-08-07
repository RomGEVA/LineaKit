import SwiftUI

struct EditNoteView: View {
    let note: Note
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var content: String
    @State private var isFavorite: Bool
    
    init(note: Note, date: Date) {
        self.note = note
        self.date = date
        self._title = State(initialValue: note.title)
        self._content = State(initialValue: note.content)
        self._isFavorite = State(initialValue: note.isFavorite)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                EnhancedModernGradientBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Edit note")
                            .font(.custom("Georgia", size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text(note.date, style: .date)
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 16) {
                        // Title field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Headline")
                                .font(.custom("Georgia", size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(Color("TextPrimary"))
                            
                            ModernTextField("Enter the title of the note", text: $title)
                        }
                        
                        // Content field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content")
                                .font(.custom("Georgia", size: 16))
                                .fontWeight(.medium)
                                .foregroundColor(Color("TextPrimary"))
                            
                            ModernTextField("Write your thoughts...", text: $content, isMultiline: true)
                        }
                        
                        // Favorite toggle
                        HStack {
                            ModernCheckbox(isChecked: $isFavorite, title: "In favorites")
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
                        .disabled(title.isEmpty || content.isEmpty)
                        .opacity(title.isEmpty || content.isEmpty ? 0.6 : 1.0)
                        
                        ModernButton("Delete note", style: .destructive) {
                            deleteNote()
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
        var updatedNote = note
        updatedNote.title = title
        updatedNote.content = content
        updatedNote.isFavorite = isFavorite
        
        dataManager.updateNote(updatedNote, in: date)
        dismiss()
    }
    
    private func deleteNote() {
        dataManager.deleteNote(note, from: date)
        dismiss()
    }
}
