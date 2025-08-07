import SwiftUI

struct NotesListView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddNote = false
    @State private var selectedDate = Date()
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 16) {
                    Text("Notes")
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
                        
                        if entry.notes.isEmpty {
                            EmptyNotesView(showingAddNote: $showingAddNote)
                        } else {
                            ForEach(entry.notes) { note in
                                NoteDetailView(note: note, date: selectedDate)
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
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddNote) {
            AddNoteView()
        }
    }
}

struct EmptyNotesView: View {
    @Binding var showingAddNote: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color("TextSecondary").opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No notes")
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextPrimary"))
                
                Text("Create your first note")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
            }
            
            ModernButton("Add a note") {
                showingAddNote = true
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

struct NoteDetailView: View {
    let note: Note
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditNote = false
    
    var body: some View {
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title)
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text(note.date, style: .time)
                            .font(.custom("Georgia", size: 12))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        if note.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.red)
                        }
                        
                        Button(action: {
                            showingEditNote = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16))
                                .foregroundColor(Color("TextSecondary"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Content
                Text(note.content)
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color("TextPrimary"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
        }
        .sheet(isPresented: $showingEditNote) {
            EditNoteView(note: note, date: date)
        }
    }
}

#Preview {
    NotesListView()
} 
