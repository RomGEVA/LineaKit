import SwiftUI

struct OnboardingView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let onboardingPages = [
        OnboardingPage(
            title: "Welcome to Linea",
            subtitle: "Every day is like a new page in your diary",
            description: "Write down your thoughts, plan your tasks, and find inspiration in the quotes of the day",
            imageName: "book.fill"
        ),
        OnboardingPage(
            title: "Notes and Reflections",
            subtitle: "Express your thoughts freely",
            description: "Take notes, capture ideas, and save important moments from your day",
            imageName: "note.text"
        ),
        OnboardingPage(
            title: "Objectives and goals",
            subtitle: "Plan your day",
            description: "Set tasks, mark completed tasks and monitor progress",
            imageName: "checklist"
        ),
        OnboardingPage(
            title: "Quotes of the day",
            subtitle: "Find inspiration",
            description: "Every day starts with a new quote that will help you set yourself up for a productive day.",
            imageName: "quote.bubble"
        ),
        OnboardingPage(
            title: "Ready to get started?",
            subtitle: "Your diary is waiting",
            description: "Start writing down your thoughts and planning your days today.",
            imageName: "heart.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Bottom section
                VStack(spacing: 20) {
                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<onboardingPages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color("AccentColor") : Color("TextSecondary").opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            ModernButton("Back", style: .secondary) {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                        }
                        
                        Spacer()
                        
                        if currentPage < onboardingPages.count - 1 {
                            ModernButton("Next") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        } else {
                            ModernButton("Start") {
                                dataManager.completeOnboarding()
                                showMainApp = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color("AccentColor").opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 50))
                    .foregroundColor(Color("AccentColor"))
            }
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.custom("Georgia", size: 28))
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextPrimary"))
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(Color("AccentColor"))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    OnboardingView()
} 
