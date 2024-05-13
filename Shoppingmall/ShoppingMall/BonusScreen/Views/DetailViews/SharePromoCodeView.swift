import SwiftUI

struct SharePromoCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var promoCode = UserDefaults.standard.userPromoCode ?? ""
    
    var body: some View {
        ZStack {
            HStack {
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 40, height: 40)
                
                Rectangle()
                    .foregroundColor(.clear)
            }
            
            Text("Баллы за друзей")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(height: 40)
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Подарим Вам\nпо 300 баллов\nза каждого друга")
                    .font(.title)
                
                Text("1. Отправляйте промокод друзьям\n2. Получайте баллы")
            }
            
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width - 40,
                           height: 35)
                    .foregroundColor(.gray)
                    .opacity(0.3)
                    .cornerRadius(10)
                
                HStack {
                    Text(promoCode)
                    Spacer()
                    Image("share")
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 30)

            Button {
                let activityViewController = UIActivityViewController(activityItems: [promoCode],
                                                                      applicationActivities: nil)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    window.rootViewController?.present(activityViewController, animated: true, completion: nil)
                }
            } label: {
                Text("Поделиться промокодом")
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 35)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
