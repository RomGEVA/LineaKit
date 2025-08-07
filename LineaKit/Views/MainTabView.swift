import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    HomeView()
                }
                .tag(0)
                
                NavigationView {
                    NotesListView()
                }
                .tag(1)
                
                NavigationView {
                    TasksListView()
                }
                .tag(2)
                
                NavigationView {
                    SettingsView()
                }
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            // Custom Tab Bar
            ModernTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(dataManager)
    }
}

#Preview {
    MainTabView()
} 
