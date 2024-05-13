import SwiftUI

struct AllEventsView: View {
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
                    
                    Text("Все мероприятия")
                }
                .frame(height: 30)
                
                ScrollView {
                    ForEach(viewModel.events, id: \.id) { event in
                        NavigationLink(destination: EventDetailView(id: event.id,
                                                                    logo: event.logoUrl ?? "")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    AsyncImage(url: URL(string: event.logoUrl ?? ""),
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
                                        
                                        Text(event.title ?? "")
                                            .font(.system(size: 24))
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
                    
                    if !viewModel.allEventsLoad && !viewModel.events.isEmpty {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .brightness(0.3)
                                .cornerRadius(10)
                            
                            Button("Загрузить еще") {
                                viewModel.setupAllEvents(resetData: false)
                            }
                            .foregroundColor(.black)
                        }
                        .frame(width: 150, height: 40)
                    }
                }
            }
            .onAppear {
                viewModel.setupAllEvents(resetData: true)
            }
            .refreshable {
                viewModel.setupAllEvents(resetData: false)
            }
        }
    }
}
