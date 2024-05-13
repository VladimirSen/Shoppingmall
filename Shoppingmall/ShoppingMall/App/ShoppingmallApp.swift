import SwiftUI

@main
struct ShoppingmallApp: App {
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.showOnboarding == true {
                TabBarView(tabSelection: 1)
                    .environmentObject(networkMonitor)
            } else {
                OnboardingView(viewModel: ViewModel(service: Service()))
                    .environmentObject(networkMonitor)
            }
        }
    }
}
