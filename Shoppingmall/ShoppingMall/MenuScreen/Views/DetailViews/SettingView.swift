import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MenuViewModel()
    @State private var isPromotionsToggleOn = false
    @State private var isKidsEventsToggleOn = false
    @State private var isEventToggleOn = false
    @State private var isExit = false
    
    var body: some View {
            ZStack {
                HStack {
                    BackButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 40, height: 40)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                }
                
                Text("Настройки")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .frame(height: 40)
            
        NavigationView {
            VStack(alignment: .leading) {
                Text("Уведомления")
                    .font(.title2)
                    .padding(.leading, 16)
                
                List {
                    Toggle("Акции в магазинах", isOn: $isPromotionsToggleOn)
                        .onChange(of: isPromotionsToggleOn) { value in
                            if value {
                                viewModel.setupPromotionPush(resetData: false)
                            } else {
                                viewModel.setupPromotionPush(resetData: true)
                            }
                        }
                        .frame(height: 50)
                    
                    Toggle("Детские мероприятия", isOn: $isKidsEventsToggleOn)
                        .onChange(of: isKidsEventsToggleOn) { value in
                            if value {
                                viewModel.setupChildrenEventsPush(resetData: false)
                            } else {
                                viewModel.setupChildrenEventsPush(resetData: true)
                            }
                        }
                        .frame(height: 50)
                    
                    Toggle("Мероприятия в ТРЦ", isOn: $isEventToggleOn)
                        .onChange(of: isEventToggleOn) { value in
                            if value {
                                viewModel.setupEventsPush(resetData: false)
                            } else {
                                viewModel.setupEventsPush(resetData: true)
                            }
                        }
                        .frame(height: 50)
                }
                .listStyle(.inset)
                .frame(height: 300)
                
                if UserDefaults.standard.mobileUserId == nil {
                    NavigationLink(destination: AuthorizationCardView()
                        .navigationBarBackButtonHidden()) {
                            HStack {
                                Image("entry")
                                
                                Text("Вход или регистрация")
                                    .foregroundColor(.primary)
                            }
                        }
                } else {
                    NavigationLink(destination: ProfileView()
                        .navigationBarBackButtonHidden()) {
                            HStack {
                                Image("user")
                                
                                Text("Данные профиля")
                                    .foregroundColor(.primary)
                            }
                        }
                    
                    Button {
                        isExit = true
                    } label: {
                        HStack {
                            Image("exit")
                            
                            Text("Выйти из профиля")
                                .foregroundColor(.primary)
                        }
                    }
                    .popover(isPresented: $isExit) {
                        ExitView()
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}
