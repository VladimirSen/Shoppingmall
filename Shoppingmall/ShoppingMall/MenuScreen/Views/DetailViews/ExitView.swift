import SwiftUI

struct ExitView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MenuViewModel()
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
            
            Image("notification")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text("Уже уходите?")
                .font(.system(size: 40))
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            Text("Вы уверены, что хотите выйти\nиз этого аккаунта?")
                .font(.system(size: 18))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Button("Да", action: {
                viewModel.logout()
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
            TabBarView(tabSelection: 1)
        }
    }
}
