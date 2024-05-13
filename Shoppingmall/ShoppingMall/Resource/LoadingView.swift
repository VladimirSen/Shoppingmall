import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .opacity(0.2)
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(.circular)
                Text("Загрузка...")
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.green)
                    .brightness(0.6)
                    .opacity(0.2)
                    .frame(width: 120, height: 120)
            }
        }
        .frame(width: UIScreen.main.bounds.width, 
               height: UIScreen.main.bounds.height)
    }
}
