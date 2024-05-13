import SwiftUI

struct NewsDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
    @State var newsId: String
    @State var type: String
    @State var title: String
    @State var logo: String
    @State private var isWebView = false

    var body: some View {
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
                    
                    if type == "news" {
                        Text(viewModel.newsDetail.content ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        
                        Text("\(convertDateTS(viewModel.newsDetail.publishDate ?? ""))")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        if viewModel.newsDetail.sitemap != nil {
                            Button("Открыть карту ТЦ", action: {
                                isWebView = true
                            })
                            .font(.system(size: 14))
                            .fullScreenCover(isPresented: $isWebView) {
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
                                    
                                    Text("Торговый центр РИВЬЕРА")
                                        .font(.system(size: 16))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                .padding(.top, 40)
                                
                                WebView(url: viewModel.newsDetail.sitemap)
                                    .frame(width: UIScreen.main.bounds.width - 20,
                                           height: UIScreen.main.bounds.height - 100)
                            }
                        }
                    } else if type == "event" {
                        Text(viewModel.event.title ?? "")
                            .font(.system(size: 24))
                            .multilineTextAlignment(.leading)
                        
                        Text(viewModel.event.content ?? "")
                            .font(.system(size: 14))
                            .padding(.vertical, 10)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Начало мероприятия: " + "\(convertDateTS(viewModel.event.date?.start ?? ""))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Text("Окончание мероприятия: " + "\(convertDateTS(viewModel.event.date?.finish ?? ""))")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 10)
                        
                        HStack {
                            Text("Стоимость")
                            Text("\(viewModel.event.cost ?? 0)")
                            Text("баллов")
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        
                        if viewModel.event.sitemap != nil {
                            Button("Открыть карту ТЦ", action: {
                                isWebView = true
                            })
                            .font(.system(size: 14))
                            .fullScreenCover(isPresented: $isWebView) {
                                ZStack {
                                    HStack {
                                        BackButton {
                                            isWebView = false
                                        }
                                        .frame(width: 30, height: 30)
                                        
                                        Text("")
                                        
                                        Rectangle()
                                            .foregroundColor(.clear)
                                    }
                                    
                                    Text("Торговый центр РИВЬЕРА")
                                        .font(.system(size: 16))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 40)
                                }
                                
                                WebView(url: viewModel.event.sitemap)
                                    .frame(width: UIScreen.main.bounds.width - 20,
                                           height: UIScreen.main.bounds.height - 100)
                            }
                        }
                    } else {
                        Text(viewModel.promotion.disclaimer ?? "")
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                        
                        if viewModel.promotion.finishDate == "" {
                            HStack(spacing: 3) {
                                Text("c")
                                Text("\(convertDateTS(viewModel.promotion.startDate ?? ""))")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        } else {
                            Text("\(convertDateTS(viewModel.promotion.startDate ?? "")) - \(convertDateTS(viewModel.promotion.finishDate ?? ""))")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        
                        Text(viewModel.promotion.content ?? "")
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 10)
            .onAppear {
                if type == "news" {
                    viewModel.setupNewsDetail(id: newsId)
                } else if type == "event" {
                    viewModel.setupEventDetail(id: newsId)
                } else {
                    viewModel.setupPromotionDetail(id: newsId)
                }
            }
        }
    }
}
