import SwiftUI

struct ScoringEntryView: View {
    @State var bonus = UserDefaults.standard.userBalance ?? 0
    @State private var showPromoCodeView = false
    @State private var showSurveyView = false
    @State private var showHomeView = false
    @State var isPromoCode: Bool
    @State var isSurvey: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image("scoringEntry")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .padding(.leading, 20)
                .padding()
            
            HStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    
                    Button("", systemImage: "xmark", action: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            if !isPromoCode {
                                showPromoCodeView = true
                            }
                            if !isSurvey {
                                showSurveyView = true
                            }
                            if isPromoCode && isSurvey {
                                showHomeView = true
                            }
                        }
                    })
                    .labelStyle(.iconOnly)
                    .foregroundColor(.black)
                }
                .frame(width: 40, height: 40)
                    .padding(.top, 50)
                    .padding(.trailing, 75)
                }
                .padding(.top, 20)
            
            Button {
                if !isPromoCode {
                    showPromoCodeView = true
                }
                if !isSurvey {
                    showSurveyView = true
                }
                if isPromoCode && isSurvey {
                    showHomeView = true
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        Text("\(bonus)")
                            .font(.title)
                            Image("diamond")
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 170, height: 60)
                
                .padding([.top, .trailing], 30)
            }
            .fullScreenCover(isPresented: $showPromoCodeView) {
                PromoCodeView()
            }
            .fullScreenCover(isPresented: $showSurveyView) {
                SurveyView()
            }
            .fullScreenCover(isPresented: $showHomeView) {
                TabBarView(tabSelection: 1)
            }
            .padding(.top, 175)
            .padding(.trailing, 100)
        }
        .padding()
    }
}
