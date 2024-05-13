import SwiftUI

struct AllNewsView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    
                    Text("Все новости")
                }
                .frame(height: 30)
                
                ScrollView {
                    ForEach(viewModel.news, id: \.id) { news in
                        NavigationLink(destination: NewsDetailView(viewModel: viewModel,
                                                                   newsId: news.id,
                                                                   type: news.type,
                                                                   title: news.title ?? "",
                                                                   logo: news.logoUrl ?? "")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    AsyncImage(url: URL(string: news.logoUrl ?? ""),
                                               placeholder: {
                                        ProgressView()
                                    })
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 40,
                                           height: 200)
                                    .cornerRadius(0)
                                    
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
                                                    .padding(.horizontal, -10)
                                            }
                                            .padding(.horizontal, 10)
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 10)
                                }
                            }
                    }
                    
                    if !viewModel.allNewsLoad && !viewModel.news.isEmpty {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .brightness(0.3)
                                .cornerRadius(10)
                            
                            Button("Загрузить еще") {
                                viewModel.setupAllNews(resetData: false)
                            }
                            .foregroundColor(.black)
                        }
                        .frame(width: 150, height: 40)
                    }
                }
            }
            .onAppear {
                viewModel.setupAllNews(resetData: true)
            }
            .refreshable {
                viewModel.setupAllNews(resetData: false)
            }
        }
    }
}
