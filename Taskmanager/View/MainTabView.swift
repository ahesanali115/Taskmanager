import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TaskManagerViewModel()
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Quest Hub", systemImage: "house.fill")
                }
            
            TaskListView()
                .tabItem {
                    Label("Quests", systemImage: "checklist")
                }
            
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
        }
        .environmentObject(viewModel)
        .accentColor(.purple)
    }
}
