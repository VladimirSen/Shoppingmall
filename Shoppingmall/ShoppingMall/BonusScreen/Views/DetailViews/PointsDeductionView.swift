import SwiftUI

struct PointsDeductionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = BonusViewModel()
    @State var offerId: String
    @State private var showHomeView: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                
                Button("", systemImage: "xmark", action: {
                    presentationMode.wrappedValue.dismiss()
                })
                .labelStyle(.iconOnly)
                .foregroundColor(.black)
            }
            .padding([.trailing, .top], 30)
            
            Image("onboarding1")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Списываем\nбаллы?")
                .font(.system(size: 40))
                .foregroundColor(.black)
                .padding(.vertical, 20)
                .multilineTextAlignment(.center)
            
            Button("Да", action: {
                viewModel.setupBuyOffer(offerId: offerId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showHomeView = true
                }
            })
            .frame(width: UIScreen.main.bounds.width - 40, 
                   height: 35)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
        .background(.white)
        .fullScreenCover(isPresented: $showHomeView) {
            TabBarView(tabSelection: 3)
        }
    }
}
