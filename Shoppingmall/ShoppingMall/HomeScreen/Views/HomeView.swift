import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = HomeViewModel()
    @State private var isAllNews = false
    @State private var isAllOffers = false
    @State private var isAllusefulInfo = false
    @State private var isAllEvents = false
    var hour = Calendar.current.component(.hour, from: Date())
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.showLoading {
                    LoadingView()
                }
                
                Text("Shoppingmall")
                    .font(.title2)
                
                ScrollView {
                    switch hour {
                    case 0..<6:
                        Text("Доброй ночи!")
                            .font(.title)
                    case 6..<12:
                        Text("Доброе утро!")
                            .font(.title)
                    case 12..<18:
                        Text("Добрый день!")
                            .font(.title)
                    default:
                        Text("Добрый вечер!")
                            .font(.title)
                    }
                    
                    if !viewModel.news.isEmpty {
                        HStack {
                            Text("Новости")
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            Button("Все", action: {
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isAllNews = true
                                }
                            })
                            .fullScreenCover(isPresented: $isAllNews) {
                                AllNewsView()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.news, id: \.id) { news in
                                    NavigationLink(destination: NewsDetailView(newsId: news.id,
                                                                               type: news.type,
                                                                               title: news.title ?? "",
                                                                               logo: news.logoUrl ?? "")
                                        .navigationBarBackButtonHidden()) {
                                            ZStack {
                                                AsyncImage(url: URL(string: news.logoUrl ?? ""),
                                                           placeholder: {
                                                    ProgressView()
                                                })
                                                .frame(width: 308, height: 167)
                                                .cornerRadius(20)
                                                
                                                VStack(alignment: .leading) {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                    
                                                    Text(news.title ?? "")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                        .background {
                                                            Rectangle()
                                                                .foregroundColor(.green)
                                                                .brightness(0.3)
                                                                .padding(.horizontal, -20)
                                                        }
                                                        .padding(.horizontal, 10)
                                                        .cornerRadius(10)
                                                }
                                                .frame(width: 288)
                                                .multilineTextAlignment(.leading)
                                                .padding(.bottom, 10)
                                            }
                                        }
                                }
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    if !viewModel.offers.isEmpty {
                        HStack {
                            Text("Новые предложения")
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            Button("Все", action: {
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isAllOffers = true
                                }
                            })
                            .fullScreenCover(isPresented: $isAllOffers) {
                                AllOffersView()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
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
                                                .frame(width: 227, height: 127)
                                                .cornerRadius(20)
                                                
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(offer.name ?? "")
                                                            .font(.system(size: 16))
                                                        
                                                        Text(offer.disclaimer ?? "")
                                                            .font(.system(size: 14))
                                                            .fontWeight(.light)
                                                    }
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(.leading)
                                                    .background {
                                                        Rectangle()
                                                            .foregroundColor(.green)
                                                            .brightness(0.3)
                                                            .padding(.horizontal, -20)
                                                    }
                                                    .padding(.horizontal, 10)
                                                    .cornerRadius(10)
                                                }
                                                .frame(width: 207)
                                                .padding(.bottom, 10)
                                            }
                                        }
                                }
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    if !viewModel.usefulInfo.isEmpty {
                        HStack {
                            Text("Полезная информация")
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            Button("Вся", action: {
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isAllusefulInfo = true
                                }
                            })
                            .fullScreenCover(isPresented: $isAllusefulInfo) {
                                AllUsefulInfoView()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.usefulInfo, id: \.id) { info in
                                    if info.description != "" {
                                        NavigationLink(destination:
                                                        HTMLTextView(htmlText: info.description ?? "")
                                            .navigationTitle(info.name ?? "")
                                            .padding(.horizontal, 10)) {
                                                ZStack {
                                                    AsyncImage(url: URL(string: info.logoUrl ?? ""),
                                                               placeholder: {
                                                        ProgressView()
                                                    })
                                                    .frame(width: 227, height: 127)
                                                    .cornerRadius(20)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Rectangle()
                                                            .foregroundColor(.clear)
                                                        
                                                        Text(info.name ?? "")
                                                            .font(.system(size: 16))
                                                            .foregroundColor(.black)
                                                            .background {
                                                                Rectangle()
                                                                    .foregroundColor(.green)
                                                                    .brightness(0.3)
                                                                    .padding(.horizontal, -20)
                                                            }
                                                            .padding(.horizontal, 10)
                                                            .cornerRadius(10)
                                                    }
                                                    .frame(width: 207)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.bottom, 10)
                                                }
                                            }
                                            .navigationTitle("")
                                    }
                                }
                            }
                            .padding(.leading, 20)
                        }
                        .padding(.bottom, 10)
                    }
                    
                    if !viewModel.events.isEmpty {
                        HStack {
                            Text("Мероприятия")
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            Button("Все", action: {
                                var transaction = Transaction()
                                transaction.disablesAnimations = true
                                withTransaction(transaction) {
                                    isAllEvents = true
                                }
                            })
                            .fullScreenCover(isPresented: $isAllEvents) {
                                AllEventsView()
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.events, id: \.id) { event in
                                    NavigationLink(destination: EventDetailView(id: event.id,
                                                                                logo: event.logoUrl ?? "")
                                        .navigationBarBackButtonHidden()) {
                                            ZStack {
                                                AsyncImage(url: URL(string: event.logoUrl ?? ""),
                                                           placeholder: {
                                                    ProgressView()
                                                })
                                                .frame(width: 227, height: 127)
                                                .cornerRadius(20)
                                                
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Rectangle()
                                                        .foregroundColor(.clear)
                                                    
                                                    Text(event.title ?? "")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.black)
                                                        .background {
                                                            Rectangle()
                                                                .foregroundColor(.green)
                                                                .brightness(0.3)
                                                                .padding(.horizontal, -20)
                                                        }
                                                        .padding(.horizontal, 10)
                                                        .cornerRadius(10)
                                                }
                                                .frame(width: 207)
                                                .multilineTextAlignment(.leading)
                                                .padding(.bottom, 10)
                                            }
                                        }
                                }
                            }
                            .padding(.leading, 20)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupNews()
            viewModel.setupUsefulInfo()
            viewModel.setupEvents()
            viewModel.setupOffers()
        }
        .refreshable {
            viewModel.setupNews()
            viewModel.setupUsefulInfo()
            viewModel.setupEvents()
            viewModel.setupOffers()
        }
    }
}
