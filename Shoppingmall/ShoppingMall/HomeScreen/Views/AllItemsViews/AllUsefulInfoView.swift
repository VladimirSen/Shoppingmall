import SwiftUI

struct AllUsefulInfoView: View {
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
                    
                    Text("Полезная информация")
                }
                .frame(height: 30)
                
                ScrollView {
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
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width - 40, 
                                               height: 200)
                                        .cornerRadius(0)
                                        
                                        VStack(alignment: .leading) {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                            
                                            Text(info.name ?? "")
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
                                .navigationTitle("")
                        }
                    }
                    
                    if !viewModel.allInfoLoad && !viewModel.usefulInfo.isEmpty {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .brightness(0.3)
                                .cornerRadius(10)
                            
                            Button("Загрузить еще") {
                                viewModel.setupAllUsefulInfo(resetData: false)
                            }
                            .foregroundColor(.black)
                        }
                        .frame(width: 150, height: 40)
                    }
                }
            }
            .onAppear {
                viewModel.setupAllUsefulInfo(resetData: true)
            }
            .refreshable {
                viewModel.setupAllUsefulInfo(resetData: false)
            }
        }
    }
}
