import SwiftUI

struct BonusView: View {
    var body: some View {
        if UserDefaults.standard.mobileUserId != nil {
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Бонус")
                            .font(.title)
                        
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                            
                            HStack(spacing: 10) {
                                Text("\(UserDefaults.standard.userBalance ?? 0)")
                                    .foregroundColor(.white)
                                
                                Image("diamond")
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 88, height: 32)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading) {
                        Row(image: "catalogGifts", 
                            title: "Каталог подарков") {
                            CatalogGifts()
                                .navigationBarBackButtonHidden()
                        }
                        .frame(height: 50)
                        
                        Row(image: "scores", 
                            title: "Баллы за друзей") {
                            SharePromoCodeView()
                                .navigationBarBackButtonHidden()
                        }
                        .frame(height: 50)
                        
                        Row(image: "gifts", 
                            title: "Мои подарки") {
                            GiftsView()
                                .navigationBarBackButtonHidden()
                        }
                        .frame(height: 50)
                        
                        Row(image: "history", 
                            title: "История операций") {
                            HistoryOperationsView()
                                .navigationBarBackButtonHidden()
                        }
                        .frame(height: 50)
                    }
                    .foregroundColor(.primary)
                    .padding(.leading, 40)
                    
                    Spacer()
                }
            }
        } else {
            AuthorizationCardView()
        }
    }
}
