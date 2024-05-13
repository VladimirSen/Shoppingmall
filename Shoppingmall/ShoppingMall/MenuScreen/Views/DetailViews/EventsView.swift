import SwiftUI

struct EventsView: View {
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
                    
                    Text("Мероприятия")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(height: 40)
                
                if viewModel.showLoading {
                    LoadingView()
                } else {
                    
                    if !viewModel.events.isEmpty {
                        ScrollView {
                            ForEach(viewModel.events, id: \.id) { event in
                                NavigationLink(destination: EventDetailView(viewModel: viewModel,
                                                                            id: event.id,
                                                                            logo: event.logoUrl ?? "")
                                    .navigationBarBackButtonHidden()) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.gray)
                                                .opacity(0.2)
                                                .cornerRadius(20)
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                AsyncImage(url: URL(string: event.logoUrl ?? ""),
                                                           placeholder: {
                                                    ProgressView()
                                                })
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: UIScreen.main.bounds.width - 80,
                                                       height: 180)
                                                .cornerRadius(20)
                                                .padding(.horizontal, 10)
                                                
                                                Text(event.title ?? "")
                                                    .font(.system(size: 18))
                                                    .padding(.horizontal, 20)
                                                    .multilineTextAlignment(.leading)
                                                
                                                if event.eventPurchased == false {
                                                    Text("\(convertDateTS((event.date?.start ?? ""))) - \(convertDateTS((event.date?.start ?? "")))")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.secondary)
                                                        .padding(.leading, 20)
                                                } else {
                                                    HStack {
                                                        ZStack {
                                                            Rectangle()
                                                                .foregroundColor(.blue)
                                                                .cornerRadius(6)
                                                                .frame(width: 140, height: 30)
                                                            Text("Зарегистрирован")
                                                                .font(.system(size: 14))
                                                                .foregroundColor(.white)
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        Text(convertDateTS(event.date?.start ?? ""))
                                                            .font(.system(size: 14))
                                                            .foregroundColor(.primary)
                                                    }
                                                    .padding(.horizontal, 40)
                                                }
                                            }
                                            .foregroundColor(.primary)
                                            .padding(.vertical, 10)
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    } else {
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 300, height: 80)
                                .foregroundColor(.red)
                                .cornerRadius(10)
                            
                            Text("Нет запланированных меропиятий")
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
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
