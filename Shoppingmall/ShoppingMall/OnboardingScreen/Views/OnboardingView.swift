import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @ObservedObject var viewModel: ViewModel
    @State private var showHomeView = false
    @State private var showNoNetworkView = false
    
    var body: some View {
        Text("Shoppingmall")
            .font(.title2)
            .padding(5)
        
        TabView {
            OnboardingCardView(image: Image("onboarding1"), 
                               text: "Шоппинг\n и отдых",
                               color: .blue)
            
            OnboardingCardView(image: Image("onboarding2"), 
                               text: "Особые\n привелегии",
                               color: .purple)
            
            NotificationCardView(viewModel: viewModel)
            
            RegistrationCardView()
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        
        HStack {
            Rectangle()
                .foregroundColor(.clear)
            
            Button("Пропустить", action: {
                if networkMonitor.isConnected {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        showHomeView = true
                    }
                } else {
                    showNoNetworkView = true
                }
            })
            .font(.system(size: 16))
            .foregroundColor(.secondary)
        }
        .frame(height: 15)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .fullScreenCover(isPresented: $showHomeView) {
            TabBarView(tabSelection: 1)
        }
        .popover(isPresented: $showNoNetworkView) {
            NoNetworkView()
        }
        .onAppear {
            viewModel.setupMobileDeviceId()
            UserDefaults.standard.showOnboarding = true
        }
    }
}
