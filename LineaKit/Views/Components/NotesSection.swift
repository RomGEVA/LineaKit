import SwiftUI

struct NotesSection: View {
    let date: Date
    @Binding var showingAddNote: Bool
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        let entry = dataManager.getDayEntry(for: date)
        
        ModernCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(Color("AccentColor"))
                    Text("Notes")
                        .font(.custom("Georgia", size: 18))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextPrimary"))
                    Spacer()
                    
                    Button(action: {
                        showingAddNote = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color("AccentColor"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Notes list
                if entry.notes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "note.text")
                            .font(.system(size: 40))
                            .foregroundColor(Color("TextSecondary").opacity(0.5))
                        
                        Text("No notes")
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color("TextSecondary"))
                        
                        ModernButton("Add notes", style: .secondary) {
                            showingAddNote = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    VStack(spacing: 12) {
                        ForEach(entry.notes.prefix(3)) { note in
                            NoteRowView(note: note, date: date)
                        }
                        
                        if entry.notes.count > 3 {
                            Button(action: {
                                // Navigate to full notes list
                            }) {
                                Text("Show all (\(entry.notes.count))")
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
}

struct NoteRowView: View {
    let note: Note
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    @State private var showingEditNote = false
    
    var body: some View {
        Button(action: {
            showingEditNote = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(note.title)
                        .font(.custom("Georgia", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextPrimary"))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if note.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color.red)
                    }
                }
                
                Text(note.content)
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(note.date, style: .time)
                    .font(.custom("Georgia", size: 12))
                    .foregroundColor(Color("TextSecondary").opacity(0.7))
            }
            .padding(12)
            .background(Color("BackgroundColor"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("BorderColor").opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingEditNote) {
            EditNoteView(note: note, date: date)
        }
    }
}

#Preview {
    NotesSection(date: Date(), showingAddNote: .constant(false))
} 
