import SwiftUI

struct NewsAndPromotionsDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
    @State var id: String
    @State var type: String
    @State var title: String
    @State var logo: String
    @State var disclaimer: String
    @State var startDate: String
    @State var finishDate: String
    @State private var isWebView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: logo),
                               placeholder: {
                        ProgressView()
                    })
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 40,
                           height: 250)
                    .cornerRadius(10)
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .cornerRadius(10)
                            
                            Button("", systemImage: "xmark", action: {
                                presentationMode.wrappedValue.dismiss()
                            })
                            .labelStyle(.iconOnly)
                            .foregroundColor(.black)
                        }
                    }
                    .padding([.trailing, .top], 15)
                }
                
                Text(title)
                    .font(.system(size: 24))
                    .multilineTextAlignment(.center)
                
                if type == "news" {
                    Text(viewModel.newsDetail.content ?? "")
                        .font(.system(size: 14))
                        .padding(.vertical, 10)
                    
                    Text(convertDateTS(viewModel.newsDetail.publishDate ?? ""))
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
                            
                            WebView(url: viewModel.newsDetail.sitemap)
                                .frame(width: UIScreen.main.bounds.width - 20,
                                       height: UIScreen.main.bounds.height - 100)
                        }
                        .padding(.top, 10)
                        
                        .onAppear {
                            viewModel.setupNewsDetail(id: id)
                        }
                    }
                } else {
                    Text(disclaimer)
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                    
                    if finishDate == "" {
                        HStack(spacing: 3) {
                            Text("c")
                            Text("\(convertDateTS(startDate))")
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                    } else {
                        Text("\(convertDateTS(startDate)) - \(convertDateTS(finishDate))")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(viewModel.promotion.content ?? "")
                        .font(.system(size: 14))
                    
                        .onAppear {
                            viewModel.setupPromotionDetail(id: id)
                        }
                }
            }
        }
        .padding([.horizontal, .top], 20)
    }
}
