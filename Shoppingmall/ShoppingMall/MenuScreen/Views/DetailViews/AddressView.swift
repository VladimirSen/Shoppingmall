import SwiftUI

struct AddressView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isWebView = false
    
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
            
            Text("Как добраться")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(height: 40)
        
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                isWebView = true
            }, label: {
                Image("riveraLocation")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 40)
                    .cornerRadius(20)
            })
            
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.7)
                    .cornerRadius(10)
                
                Text("перейти в Яндекс Карты")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 40, 
                   height: 35)
            
            HStack(spacing: 10) {
                Image("question")
                
                Text("г.Москва ул. Автозаводская д.18")
                
                Spacer()
            }
            
            Spacer()
        }
        .fullScreenCover(isPresented: $isWebView) {
            ZStack {
                HStack {
                    BackButton {
                        isWebView = false
                    }
                    .frame(width: 30, height: 30)
                    
                    Text("")
                    
                    Rectangle()
                        .foregroundColor(.clear)
                }
                
                Text("Торговый центр РИВЬЕРА")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 30)
            
            WebView(url: "https://maps.yandex.ru?text=Москва Автозаводская 18")
                .frame(width: UIScreen.main.bounds.width - 20, 
                       height: UIScreen.main.bounds.height - 100)
        }
        .padding(.horizontal, 20)
    }
}
