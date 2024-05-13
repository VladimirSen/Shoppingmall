import SwiftUI

struct NewsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        BackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 40, height: 40)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    Text("Новости и акции")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(height: 40)
                
                if viewModel.showLoading {
                    LoadingView()
                } else {
                    if !viewModel.newsAndPromotions.isEmpty {
                        ScrollView {
                            ForEach(viewModel.newsAndPromotions, id: \.id) { news in
                                NavigationLink(destination: NewsAndPromotionsDetailView(id: news.id, 
                                                                                        type: news.type ?? "",
                                                                                        title: news.title ?? "",
                                                                                        logo: news.logoUrl ?? "",
                                                                                        disclaimer: news.disclaimer ?? "",
                                                                                        startDate: news.date?.start ?? "",
                                                                                        finishDate: news.date?.finish ?? "")
                                    .navigationBarBackButtonHidden()) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.gray)
                                                .opacity(0.2)
                                                .cornerRadius(20)
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                AsyncImage(url: URL(string: news.logoUrl ?? ""),
                                                           placeholder: {
                                                    ProgressView()
                                                })
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: UIScreen.main.bounds.width - 80, 
                                                       height: 180)
                                                .cornerRadius(20)
                                                .padding(.horizontal, 10)
                                                
                                                Text(news.title ?? "")
                                                    .font(.system(size: 18))
                                                    .padding(.horizontal, 20)
                                                    .multilineTextAlignment(.leading)
                                                
                                                if news.type == "promotion" {
                                                    if news.date?.finish == "" {
                                                        Text("c \(convertDateTS(news.date?.start ?? ""))")
                                                            .font(.system(size: 16))
                                                            .foregroundColor(.secondary)
                                                            .multilineTextAlignment(.leading)
                                                            .padding(.horizontal, 20)
                                                    } else {
                                                        HStack(spacing: 3) {
                                                            Text("\(convertDateTS(news.date?.start ?? "")) -")
                                                            Text("\(convertDateTS(news.date?.finish ?? ""))")
                                                        }
                                                            .font(.system(size: 16))
                                                            .foregroundColor(.secondary)
                                                            .padding(.vertical, 5)
                                                            .padding(.horizontal, 20)
                                                    }
                                                }
                                            }
                                            .foregroundColor(.primary)
                                            .padding(.vertical, 10)
                                        }
                                    }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                    } else {
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 300, height: 80)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                            
                            Text("Нет новостей и акций")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            viewModel.setupNewsAndPromotions()
        }
        .refreshable {
            viewModel.setupNewsAndPromotions()
        }
    }
}
