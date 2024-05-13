import SwiftUI

struct GiftsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = BonusViewModel()
    @State private var popover: Offer?
    private var columns: [GridItem] = [.init(.fixed(160)), .init(.fixed(160))]
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
                LoadingView()
            } else {
                ZStack {
                    HStack {
                        BackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 40, height: 40)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    
                    Text("Мои подарки")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(height: 40)
                
                if viewModel.userOffers.isEmpty {
                    Text("Пусто...\n\n Кажется, самое время\nвыбрать что-то из каталога\nподарков")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 50)
                    
                    Image("giftcatalogpage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                } else {
                    NavigationView {
                        VStack {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(viewModel.userOffers, id: \.id) { offer in
                                        Button {
                                            popover = Offer(id: offer.id, 
                                                            shop: offer.shop,
                                                            name: offer.name,
                                                            disclaimer: offer.disclaimer,
                                                            description: offer.description,
                                                            confirmationConditions: offer.confirmationConditions,
                                                            conditionsReceiving: offer.conditionsReceiving,
                                                            type: offer.type, cost: offer.cost, 
                                                            offerActivatedForMultiple: offer.offerActivatedForMultiple,
                                                            onHome: offer.onHome,
                                                            startAt: offer.startAt,
                                                            endAt: offer.endAt,
                                                            createdAt: offer.createdAt,
                                                            image: offer.image,
                                                            offerPurchased: offer.offerPurchased)
                                        } label: {
                                            ZStack(alignment: .topLeading) {
                                                Rectangle()
                                                    .frame(width: 152, height: 110)
                                                    .foregroundColor(getRandomColor())
                                                    .cornerRadius(20)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(offer.shop.name ?? "")
                                                        .font(.system(size: 14))
                                                        .padding(.bottom, 5)
                                                    
                                                    Text(offer.name ?? "")
                                                        .font(.system(size: 18))
                                                    
                                                    Text(offer.disclaimer ?? "")
                                                        .font(.system(size: 14))
                                                }
                                                .frame(width: 132, 
                                                       height: 100,
                                                       alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.white)
                                                .padding(.top, 5)
                                                .padding(.horizontal, 10)
                                            }
                                        }
                                    }
                                }
                                .popover(item: $popover) { detail in
                                    GiftDetailView(id: detail.id, 
                                                   shop: detail.shop.name ?? "",
                                                   name: detail.name ?? "",
                                                   logo: detail.image ?? "",
                                                   disclaimer: detail.disclaimer ?? "",
                                                   description: detail.description ?? "",
                                                   cost: detail.cost ?? 0)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupUserOffers()
        }
    }
    
    func getRandomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
