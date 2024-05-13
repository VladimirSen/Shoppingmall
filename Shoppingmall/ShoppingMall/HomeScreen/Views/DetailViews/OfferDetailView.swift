import SwiftUI

struct OfferDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
    @State var title: String
    @State var logo: String
    @State var description: String
    @State var cost: Int
    @State var startAt: String
    @State var endAt: String

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 40, height: 40)
                    
                    Rectangle().foregroundColor(.clear)
                }
                Text(title)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(height: 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    AsyncImage(url: URL(string: logo), 
                               placeholder: {
                        ProgressView()
                    })
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 20)
                    
                    Text(description)
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Начало действия предложения: " + "\(convertDateString(startAt))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text("Окончание действия предложения: " + "\(convertDateString(endAt))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 10)
                    
                    HStack {
                        Text("Стоимость")
                        Text("\(cost)")
                        Text("баллов")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
