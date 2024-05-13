import SwiftUI

struct NotificationCardView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @ObservedObject var viewModel: ViewModel
    @State private var showAlert = false
    @State private var showRegistrationView = false
    @State private var showHomeView = false
    @State private var showNoNetworkView = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            
            VStack {
                Image("notification")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("Узнавайте\n первыми")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                Text("Разрешите уведомления, чтобы узнавать о начисленных бонусах и специальных предложениях")
                    .frame(width: 300)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                VStack {
                    Button("Разрешить", action: {
                        if networkMonitor.isConnected {
                            showAlert = true
                        } else {
                            showNoNetworkView = true
                        }
                    })
                    .frame(width: 264, height: 35)
                    .background(.white)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Разрешить уведомления?"),
                            message: Text("Вам будут поступать уведомления о проводимых в ТРЦ мероприятиях"),
                            primaryButton: .default(
                                Text("Да"),
                                action: {
                                    viewModel.setupEventsPush()
                                }),
                            secondaryButton: .destructive(
                                Text("Нет"),
                                action: {
                                    showAlert = false
                                })
                        )}
                    .popover(isPresented: $showNoNetworkView) {
                        NoNetworkView()
                    }
                    
                    Button("Позже", action: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            showRegistrationView = true
                        }
                    })
                    .foregroundColor(.white)
                    .fullScreenCover(isPresented: $showRegistrationView) {
                        Text("Shoppingmall")
                            .font(.title2)
                            .padding(5)
                        
                        RegistrationCardView()
                        
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
                                .tabViewStyle(.automatic)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}
