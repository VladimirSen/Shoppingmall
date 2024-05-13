import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        VStack {
            Image("noNetwork")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
            
            Text("Сетевое соединение, похоже, отключено.")
                .font(.title)
                .padding()
            
            Text("Пожалуйста, проверьте вашу связь.")
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}
