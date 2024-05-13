import SwiftUI

struct CatalogGifts: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
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
                    
                    Text("Каталог подарков")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(height: 40)
                
                if !viewModel.offers.isEmpty {
                    NavigationView {
                        VStack {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(viewModel.offers, id: \.id) { offer in
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
                                                    .frame(width: 152, height: 175)
                                                    .foregroundColor(getRandomColor())
                                                    .cornerRadius(20)
                                                
                                                ZStack {
                                                    Rectangle()
                                                        .frame(width: 80, height: 30)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                    
                                                    HStack(spacing: 10) {
                                                        Text("\(offer.cost ?? 0)")
                                                        Image("diamond")
                                                    }
                                                    .foregroundColor(.blue)
                                                    .padding()
                                                }
                                                
                                                VStack(alignment: .leading) {
                                                    Text(offer.shop.name ?? "")
                                                        .font(.system(size: 16))
                                                        .padding(.bottom, 5)
                                                    
                                                    Text(offer.name ?? "")
                                                        .font(.system(size: 20))
                                                    
                                                    Text(offer.disclaimer ?? "")
                                                        .font(.system(size: 16))
                                                }
                                                .frame(width: 132, 
                                                       height: 100,
                                                       alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.white)
                                                .padding(.top, 70)
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
                } else {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 300, height: 80)
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        
                        Text("Подарков пока нет")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.setupAllOffers(resetData: false)
        }
    }
    
    private func getRandomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
