import SwiftUI

struct EventDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomeViewModel()
    @State var id: String
    @State var logo: String
    @State private var isWebView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            viewModel.setupEventDetail(id: id)
        }
        .refreshable {
            viewModel.setupEventDetail(id: id)
        }
        .padding([.horizontal, .top], 20)
    }
}
