import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            EnhancedModernGradientBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                        
                        Text("Personalize your app")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                    }
                    .padding(.top, 20)
                    
                    // Data Management
                    ModernCard {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "folder.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                
                                Text("Data management")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 16) {
                                SettingRow(
                                    icon: "trash.fill",
                                    title: "Reset data",
                                    subtitle: "Delete all notes and tasks"
                                ) {
                                    Button(action: {
                                        showingResetAlert = true
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 0.8, green: 0.3, blue: 0.3))
                                    }
                                }
                            }
                        }
                    }
                    
                    // Legal
                    ModernCard {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                
                                Text("Legal information")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 16) {
                                SettingRow(
                                    icon: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    subtitle: "How we process your data"
                                ) {
                                    Button(action: {
                                        openDeepLink(link: "https://telegra.ph/Privacy-Policy-for-Linea-08-07")
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                    }
                                }
                            }
                        }
                    }
                    
                    // App Info
                    ModernCard {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.8))
                                
                                Text("About the application")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                                
                                Spacer()
                            }
                            
                            VStack(spacing: 16) {
                                SettingRow(
                                    icon: "app.fill",
                                    title: "Version",
                                    subtitle: "1.0.0"
                                ) {
                                    EmptyView()
                                }
                                
                                Button {rateUs()} label: {
                                    SettingRow(
                                        icon: "heart.fill",
                                        title: "Rate us",
                                        subtitle: ""
                                    ) {}
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .padding(.top, 70)
        }
        .navigationBarHidden(true)
        .alert("Reset data", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                dataManager.resetAllData()
            }
        } message: {
            Text("This action will delete all your notes and tasks. This action cannot be undone.")
        }
        .ignoresSafeArea()
        
    }
    func rateUs() {
        SKStoreReviewController.requestReview()
    }
    
    func openDeepLink(link: String) {
        guard let url = URL(string: link) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

// MARK: - Setting Row
struct SettingRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content
    
    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
            }
            
            Spacer()
            
            content
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Modern Toggle Style
struct ModernToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                configuration.isOn.toggle()
            }
        }) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    configuration.isOn ?
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
                            Color(red: 0.12, green: 0.12, blue: 0.15),
                            Color(red: 0.10, green: 0.10, blue: 0.13)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isOn)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
} 
