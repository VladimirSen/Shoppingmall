import SwiftUI

struct AllOffersView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        if viewModel.showLoading {
            LoadingView()
        }
        
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        BackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 30, height: 30)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    .padding(.leading, 10)
                    
                    Text("Все предложения")
                }
                .frame(height: 30)
                
                ScrollView {
                    ForEach(viewModel.offers, id: \.id) { offer in
                        NavigationLink(destination: OfferDetailView(title: offer.name ?? "",
                                                                    logo: offer.image ?? "",
                                                                    description: offer.description ?? "",
                                                                    cost: offer.cost ?? 0,
                                                                    startAt: offer.startAt ?? "",
                                                                    endAt: offer.endAt ?? "")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    AsyncImage(url: URL(string: offer.image ?? ""),
                                               placeholder: {
                                        ProgressView()
                                    })
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 40, 
                                           height: 200)
                                    .cornerRadius(0)
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                        
                                        VStack(alignment: .leading) {
                                            Text(offer.name ?? "")
                                                .font(.system(size: 24))
                                            
                                            Text(offer.disclaimer ?? "")
                                                .font(.system(size: 18))
                                                .fontWeight(.light)
                                        }
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.leading)
                                        .background {
                                            Rectangle()
                                                .foregroundColor(.green)
                                                .brightness(0.3)
                                                .padding(.horizontal, -10)
                                        }
                                        .padding(.horizontal, 10)
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .padding(.bottom, 10)
                                }
                            }
                    }
                    
                    if !viewModel.allOffersLoad && !viewModel.offers.isEmpty {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .brightness(0.3)
                                .cornerRadius(10)
                            
                            Button("Загрузить еще") {
                                viewModel.setupAllOffers(resetData: false)
                            }
                            .foregroundColor(.black)
                        }
                        .frame(width: 150, height: 40)
                    }
                }
            }
            .onAppear {
                viewModel.setupAllOffers(resetData: true)
            }
            .refreshable {
                viewModel.setupAllOffers(resetData: false)
            }
        }
    }
}
