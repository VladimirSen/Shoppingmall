import SwiftUI

struct OnboardingCardView: View {
    var image: Image
    var text: LocalizedStringKey
    var color: Color

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            
            VStack {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Text(text)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}
