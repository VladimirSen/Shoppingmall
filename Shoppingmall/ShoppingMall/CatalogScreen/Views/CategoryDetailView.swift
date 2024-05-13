import SwiftUI

struct CatalogItemsDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = CatalogViewModel()
    @State private var isSiteUrl = false
    @State private var isAllOffers = false
    @State var id = ""
    @State var image = ""
    @State var name = ""
    
    var body: some View {
        if viewModel.showLoading {
            LoadingView()
        }
        
        ZStack {
            HStack {
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 40, height: 40)
                
                Rectangle().foregroundColor(.clear)
            }
            
            Text(name)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(height: 40)
        
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: image), 
                           placeholder: {
                    ProgressView()
                })
                .frame(width: UIScreen.main.bounds.width - 20, 
                       height: 250)
                .cornerRadius(20)
                
                HStack {
                    if viewModel.shop.floor != 0 {
                        Text("\(viewModel.shop.floor ?? 0) этаж")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isSiteUrl = true
                    }, label: {
                        Text(viewModel.shop.siteUrl ?? "")
                    })
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 3) {
                        ForEach(viewModel.shop.images ?? [], id: \.self) { image in
                            ZStack {
                                AsyncImage(url: URL(string: image.url), 
                                           placeholder: {
                                    ProgressView()
                                })
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 268, height: 147)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .fullScreenCover(isPresented: $isSiteUrl) {
                ZStack {
                    HStack {
                        BackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 30, height: 30)
                        
                        Text("")
                        
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    
                    Text(viewModel.shop.name ?? "")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                WebView(url: viewModel.shop.siteUrl)
                    .frame(width: UIScreen.main.bounds.width - 20, 
                           height: UIScreen.main.bounds.height - 130)
            }
            
            if viewModel.shop.promotions != [] {
                HStack {
                    Text("Предложения за баллы")
                        .font(.system(size: 20))
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.promotions, id: \.id) { promotion in
                            ZStack {
                                AsyncImage(url: URL(string: promotion.logoUrl ?? ""), 
                                           placeholder: {
                                    ProgressView()
                                })
                                .frame(width: 227, height: 127)
                                .cornerRadius(20)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Rectangle()
                                        .foregroundColor(.clear)
                                    
                                    Text(promotion.title ?? "")
                                        .font(.system(size: 20))
                                    
                                    Text(promotion.disclaimer ?? "")
                                        .font(.system(size: 14))
                                        .fontWeight(.light)
                                }
                                .frame(width: 207)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .padding([.leading, .bottom], 10)
                            }
                        }
                        .padding(.leading, 20)
                    }
                    .padding(.bottom, 10)
                }
            }
            
            HStack {
                HTMLTextView(htmlText: viewModel.shop.description ?? "")
            }
            .frame(width: UIScreen.main.bounds.width - 20,
                   height: 200)
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.setupShop(shopId: id)
            if viewModel.shop.promotions != [] {
                viewModel.setupShopPromotions(shopId: id)
            }
        }
    }
}
