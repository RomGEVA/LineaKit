import SwiftUI

// MARK: - Modern Gradient Background
struct ModernGradientBackground: View {
    @State private var animateGradient = false
    @State private var particleOffset: CGFloat = 0
    
    struct ModernGradientParticle: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
        let duration: Double
        let delay: Double
    }
    
    @State private var particles: [ModernGradientParticle] = []
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.05),
                    Color(red: 0.05, green: 0.05, blue: 0.10),
                    Color(red: 0.08, green: 0.08, blue: 0.15),
                    Color(red: 0.12, green: 0.12, blue: 0.20)
                ]),
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.3, green: 0.4, blue: 0.8).opacity(0.1),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 100,
                endRadius: 400
            )
            .opacity(animateGradient ? 0.8 : 0.5)
            .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animateGradient)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.3, blue: 0.6).opacity(0.1),
                    Color.clear
                ]),
                center: .bottomLeading,
                startRadius: 150,
                endRadius: 500
            )
            .opacity(animateGradient ? 0.6 : 0.3)
            .animation(.easeInOut(duration: 15).repeatForever(autoreverses: true), value: animateGradient)
            
            
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.white.opacity(particle.opacity))
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y + particleOffset)
                        .animation(
                            .easeInOut(duration: particle.duration)
                                .repeatForever(autoreverses: true)
                                .delay(particle.delay),
                            value: animateGradient
                        )
                }
            }
            
            // Subtle mesh gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.2, blue: 0.4).opacity(0.05),
                    Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.03),
                    Color.clear
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Blur effect for depth
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.1)
                .ignoresSafeArea()
        }
        .onAppear {
            if particles.isEmpty {
                let screen = UIScreen.main.bounds
                self.particles = (0..<30).map { _ in
                    ModernGradientParticle(
                        x: CGFloat.random(in: 0...screen.width),
                        y: CGFloat.random(in: 0...screen.height),
                        size: CGFloat.random(in: 3...12),
                        opacity: Double.random(in: 0.1...0.4),
                        duration: Double.random(in: 3...8),
                        delay: Double.random(in: 0...2)
                    )
                }
            }
            
            withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

// MARK: - Modern Card
struct ModernCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    
    init(padding: CGFloat = 20, cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.15, green: 0.15, blue: 0.18).opacity(0.8),
                                Color(red: 0.12, green: 0.12, blue: 0.15).opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.1),
                                        Color.white.opacity(0.05)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .shadow(color: Color.black.opacity(0.1), radius: 40, x: 0, y: 20)
            )
    }
}

// MARK: - Modern Button
struct ModernButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, destructive
    }
    
    init(_ title: String, icon: String? = nil, style: ButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderColor, lineWidth: 1)
                    )
                    .shadow(color: shadowColor, radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: UUID())
    }
    
    private var backgroundColor: LinearGradient {
        switch style {
        case .primary:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.6, blue: 0.8),
                    Color(red: 0.3, green: 0.5, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .secondary:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.15, green: 0.15, blue: 0.18),
                    Color(red: 0.12, green: 0.12, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .destructive:
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.3, blue: 0.3),
                    Color(red: 0.7, green: 0.2, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary, .destructive:
            return .white
        case .secondary:
            return Color(red: 0.9, green: 0.9, blue: 0.9)
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary:
            return Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.3)
        case .secondary:
            return Color.white.opacity(0.1)
        case .destructive:
            return Color(red: 0.8, green: 0.3, blue: 0.3).opacity(0.3)
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.3)
        case .secondary:
            return Color.black.opacity(0.2)
        case .destructive:
            return Color(red: 0.8, green: 0.3, blue: 0.3).opacity(0.3)
        }
    }
}

// MARK: - Modern Text Field
struct ModernTextField: View {
    let placeholder: String
    let icon: String?
    @Binding var text: String
    let isMultiline: Bool
    
    init(_ placeholder: String, icon: String? = nil, text: Binding<String>, isMultiline: Bool = false) {
        self.placeholder = placeholder
        self.icon = icon
        self._text = text
        self.isMultiline = isMultiline
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    .frame(width: 24)
            }
            
            if isMultiline {
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .background(Color.clear)
                    .frame(minHeight: 100)
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.12, green: 0.12, blue: 0.15),
                            Color(red: 0.10, green: 0.10, blue: 0.13)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Modern Checkbox
struct ModernCheckbox: View {
    @Binding var isChecked: Bool
    let title: String
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isChecked.toggle()
            }
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.15, green: 0.15, blue: 0.18),
                                    Color(red: 0.12, green: 0.12, blue: 0.15)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(isChecked ? 1.0 : 0.0)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isChecked ?
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.4, green: 0.6, blue: 0.8),
                                    Color(red: 0.3, green: 0.5, blue: 0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Modern Tab Bar
struct ModernTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 0
                }
            }
            
            TabBarItem(
                icon: "note.text",
                title: "Notes",
                isSelected: selectedTab == 1
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 1
                }
            }
            
            TabBarItem(
                icon: "checklist",
                title: "Tasks",
                isSelected: selectedTab == 2
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 2
                }
            }
            
            TabBarItem(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 3
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 3
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.15, green: 0.15, blue: 0.18).opacity(0.95),
                            Color(red: 0.12, green: 0.12, blue: 0.15).opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.4, green: 0.6, blue: 0.8) : Color(red: 0.7, green: 0.7, blue: 0.7))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.4, green: 0.6, blue: 0.8) : Color(red: 0.7, green: 0.7, blue: 0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ?
                        Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.1) :
                        Color.clear
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Modern Mood Picker
struct ModernMoodPicker: View {
    @Binding var selectedMood: Int?
    let title: String
    
    private let moods = [
        (1, "😢", "Very bad"),
        (2, "😕", "Badly"),
        (3, "😐", "Normal"),
        (4, "🙂", "Good"),
        (5, "😊", "Great")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
            
            HStack(spacing: 12) {
                ForEach(moods, id: \.0) { mood in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedMood = selectedMood == mood.0 ? nil : mood.0
                        }
                    }) {
                        VStack(spacing: 4) {
                            Text(mood.1)
                                .font(.system(size: 24))
                            
                            Text(mood.2)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedMood == mood.0 ? 
                                    Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.2) :
                                    Color(red: 0.08, green: 0.08, blue: 0.12)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedMood == mood.0 ? 
                                                Color(red: 0.4, green: 0.6, blue: 0.8) :
                                                Color(red: 0.2, green: 0.2, blue: 0.25),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.25), lineWidth: 1)
                )
        )
    }
}

// MARK: - Modern Priority Picker
struct ModernPriorityPicker: View {
    @Binding var selectedPriority: TaskPriority
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach([TaskPriority.low, .medium, .high], id: \.self) { priority in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedPriority = priority
                    }
                }) {
                    VStack(spacing: 4) {
                        Circle()
                            .fill(priorityColor(priority))
                            .frame(width: 12, height: 12)
                        
                        Text(priorityTitle(priority))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedPriority == priority ? 
                                priorityColor(priority).opacity(0.2) :
                                Color(red: 0.08, green: 0.08, blue: 0.12)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedPriority == priority ? 
                                            priorityColor(priority) :
                                            Color(red: 0.2, green: 0.2, blue: 0.25),
                                        lineWidth: 1
                                    )
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .medium:
            return Color(red: 0.8, green: 0.6, blue: 0.2)
        case .high:
            return Color(red: 0.8, green: 0.3, blue: 0.3)
        }
    }
    
    private func priorityTitle(_ priority: TaskPriority) -> String {
        switch priority {
        case .low:
            return "Short"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

// MARK: - Modern Section Header
struct ModernSectionHeader: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Modern Empty State
struct ModernEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8).opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.2, green: 0.2, blue: 0.25), lineWidth: 1)
                )
        )
    }
}

// MARK: - Note Card
struct NoteCard: View {
    let note: Note
    let date: Date
    
    var body: some View {
        NavigationLink(destination: EditNoteView(note: note, date: date)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(note.date, style: .time)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                
                Text(note.content)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.12, green: 0.12, blue: 0.15),
                                Color(red: 0.10, green: 0.10, blue: 0.13)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Task Card
struct TaskCard: View {
    let task: Task
    let date: Date
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationLink(destination: EditTaskView(task: task, date: date)) {
            HStack(spacing: 12) {
                Button(action: {
                    dataManager.toggleTaskCompletion(task)
                }) {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(task.isCompleted ? 
                            Color(red: 0.4, green: 0.8, blue: 0.4) :
                            Color(red: 0.7, green: 0.7, blue: 0.7)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .strikethrough(task.isCompleted)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(priorityColor(task.priority))
                            .frame(width: 8, height: 8)
                        
                        Text(priorityTitle(task.priority))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                        
                        Spacer()
                        
                        Text(task.date, style: .time)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.12, green: 0.12, blue: 0.15),
                                Color(red: 0.10, green: 0.10, blue: 0.13)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func priorityColor(_ priority: TaskPriority) -> Color {
        switch priority {
        case .low:
            return Color(red: 0.4, green: 0.8, blue: 0.4)
        case .medium:
            return Color(red: 0.8, green: 0.6, blue: 0.2)
        case .high:
            return Color(red: 0.8, green: 0.3, blue: 0.3)
        }
    }
    
    private func priorityTitle(_ priority: TaskPriority) -> String {
        switch priority {
        case .low:
            return "Short"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}

// MARK: - Modern Day Switcher
struct ModernDaySwitcher: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation(.spring()) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
            
            VStack(spacing: 2) {
                Text(selectedDate, style: .date)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.04))
            )
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    .padding(8)
                    .background(Color.white.opacity(0.05))
                    .clipShape(Circle())
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.02))
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Enhanced Modern Gradient Background
struct EnhancedModernGradientBackground: View {
    @State private var animateGradient = false
    @State private var particleOffset: CGFloat = 0
    
    struct EnhancedModernGradientParticle: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
        let duration: Double
        let delay: Double
        let color: Color
    }
    
    @State private var particles: [EnhancedModernGradientParticle] = []
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.15),
                    Color(red: 0.1, green: 0.1, blue: 0.25),
                    Color(red: 0.15, green: 0.15, blue: 0.35)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(animateGradient ? 0.8 : 0.5)
            .animation(.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateGradient)

            // Radial gradients for lighting effects
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.3, green: 0.4, blue: 0.8).opacity(0.1),
                        Color.clear
                    ]),
                    center: .topTrailing,
                    startRadius: 100,
                    endRadius: 400
                )
                .opacity(animateGradient ? 0.8 : 0.5)
                .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animateGradient)
            }
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.3, blue: 0.6).opacity(0.1),
                    Color.clear
                ]),
                center: .bottomLeading,
                startRadius: 150,
                endRadius: 500
            )
            .opacity(animateGradient ? 0.6 : 0.3)
            .animation(.easeInOut(duration: 15).repeatForever(autoreverses: true), value: animateGradient)
            
            // Floating particles
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .opacity(particle.opacity)
                        .scaleEffect(animateGradient ? 1.5 : 1)
                        .offset(x: particle.x, y: particle.y)
                        .animation(
                            .easeInOut(duration: particle.duration)
                            .repeatForever(autoreverses: true)
                            .delay(particle.delay),
                            value: animateGradient
                        )
                }
            }
            .offset(y: particleOffset)
            .blur(radius: 1)
            .animation(
                .linear(duration: 20)
                .repeatForever(autoreverses: false),
                value: particleOffset
            )

            // Material overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.1)
                .ignoresSafeArea()
        }
        .onAppear {
            if particles.isEmpty {
                let screen = UIScreen.main.bounds
                self.particles = (0..<30).map { _ in
                    EnhancedModernGradientParticle(
                        x: CGFloat.random(in: 0...screen.width),
                        y: CGFloat.random(in: 0...screen.height),
                        size: CGFloat.random(in: 10...40),
                        opacity: Double.random(in: 0.1...0.3),
                        duration: Double.random(in: 10...20),
                        delay: Double.random(in: 0...5),
                        color: [Color.blue, Color.purple, Color.pink].randomElement()!.opacity(0.5)
                    )
                }
            }
            
            withAnimation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
            
            withAnimation(Animation.linear(duration: 20).repeatForever(autoreverses: false)) {
                particleOffset = -UIScreen.main.bounds.height
            }
        }
    }
}

// MARK: - Modern Search Bar
struct ModernSearchBar: View {
    @Binding var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
            
            TextField("Search...", text: $text)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color(red: 0.05, green: 0.05, blue: 0.15))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
} 
