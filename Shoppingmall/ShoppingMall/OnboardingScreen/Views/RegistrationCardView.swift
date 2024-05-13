import SwiftUI

struct RegistrationCardView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State private var showRegistrationView = false
    @State private var showAuthorizationView = false
    @State private var showNoNetworkView = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            
            VStack {
                Image("registration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("Регистрация")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                Text("Станьте частью сообщества Shoppingmall и получайте баллы")
                    .frame(width: 300)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                VStack {
                    Button("Зарегистрироваться", action: {
                        if networkMonitor.isConnected {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                showRegistrationView = true
                            }
                        } else {
                            showNoNetworkView = true
                        }
                    })
                    .frame(width: 264, height: 35)
                    .background(.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .fullScreenCover(isPresented: $showRegistrationView) {
                        RegistrationNumberPhoneView()
                    }
                    .popover(isPresented: $showNoNetworkView) {
                        NoNetworkView()
                    }
                    
                    Button("У меня уже есть аккаунт", action: {
                        if networkMonitor.isConnected {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                showAuthorizationView = true
                            }
                        } else {
                            showNoNetworkView = true
                        }
                    })
                    .foregroundColor(.white)
                    .fullScreenCover(isPresented: $showAuthorizationView) {
                        AuthorizationView()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}
