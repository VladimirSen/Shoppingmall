import SwiftUI

struct AuthorizationCardView: View {
    @State private var isExit = false
    @State private var showRegistration = false
    @State private var showAuthorization = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button("", systemImage: "xmark", action: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            isExit = true
                        }
                    })
                    .foregroundColor(.black)
                    .padding(.trailing, 10)
                }
                .fullScreenCover(isPresented: $isExit) {
                    TabBarView(tabSelection: 3)
                }
                .padding(.top, 20)
                
                Image("registration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text("Регистрация")
                    .font(.system(size: 36))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                Text("Этот раздел доступен только авторизованным пользователям")
                    .frame(width: 300)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                VStack {
                    Button("Зарегистрироваться", action: {
                        showRegistration = true
                    })
                    .frame(width: 264, height: 35)
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .fullScreenCover(isPresented: $showRegistration) {
                        RegistrationNumberPhoneView()
                    }
                    
                    Button("У меня уже есть аккаунт", action: {
                        showAuthorization = true
                    })
                    .foregroundColor(.black)
                    .fullScreenCover(isPresented: $showAuthorization) {
                        AuthorizationView()
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}
