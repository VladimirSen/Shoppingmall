import SwiftUI

struct PromoCodeView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    @State private var showSurveyView = false
    @State private var showScoringEntryView = false
    @State private var userPromoCode: String = ""
    @State private var wrongPromoCode = false
    
    var body: some View {
        Text("Получите баллы от друга")
            .font(.title2)
            .padding(.bottom, 40)
        
        VStack(alignment: .leading) {
            Text("Введите промокод")
                .font(.subheadline)
            
            TextField("*****",
                      text: $userPromoCode)
            .textFieldStyle(.roundedBorder)
            
            Text("Вы можете получить его у друга, который уже пользуется Shoppingmall")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if wrongPromoCode {
                Text("Нет такого промокода!")
                    .foregroundColor(.red)
            }
            
            Button("Получить баллы", action: {
                viewModel.setupMobileUserCode(code: userPromoCode)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if !viewModel.wrongPromoCode {
                        showScoringEntryView = true
                    } else {
                        wrongPromoCode = true
                    }
                }
            })
            .frame(width: UIScreen.main.bounds.width - 40,
                   height: 35)
            .background(userPromoCode.count == 5 ? .blue : .gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(userPromoCode.count != 5)
            .fullScreenCover(isPresented: $showScoringEntryView) {
                ScoringEntryView(isPromoCode: true, 
                                 isSurvey: false)
            }
            .padding(.top, 40)
            
            Button("Нет промокода", action: {
                showSurveyView = true
            })
            .frame(width: UIScreen.main.bounds.width - 40, 
                   height: 35)
            .foregroundColor(.blue)
            .fullScreenCover(isPresented: $showSurveyView) {
                SurveyView()
            }
        }
        .padding(.horizontal, 20)
        
        Spacer()
    }
}
