import SwiftUI

struct AuthorizationView: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState var focusedField: Field?
    @ObservedObject var viewModel = RegistrationViewModel()
    @State private var showHomeView = false
    @State private var userPhoneNumber: String = ""
    @State private var userSMSCode: String = ""
    @State private var isPhoneNumberEntered: Bool = false
    @State private var isPhoneNumberNoCorrect: Bool = false
    @State private var timeRemaining = 15
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var mask = "+X(XXX)XXX-XX-XX"
    
    enum Field: Hashable {
        case phoneField
        case smsField
    }
    
    var body: some View {
        let textChangedBinding = Binding<String>(get: {
            FormatPhoneNumber.format(with: self.mask, phone: self.userPhoneNumber)
        }, set: {
            self.userPhoneNumber = $0
        })
        
        Text("Авторизация")
            .font(.title2)
            .padding(.bottom, 40)
        
        if !isPhoneNumberEntered {
            VStack(alignment: .leading) {
                Text("Введите номер телефона")
                    .font(.subheadline)
                
                ZStack {
                    Rectangle()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray)
                                .opacity(0.2))
                        .foregroundColor(.clear)
                    
                    TextFieldContainer(mask, text: textChangedBinding)
                        .focused($focusedField, equals: .phoneField)
                        .padding(.leading, 5)
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 35)
                
                Text("На него будет отправлен одноразовый код")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button("Получить код", action: {
                    viewModel.setupSmsCode(phone: userPhoneNumber)
                    isPhoneNumberEntered = true
                })
                .frame(width: UIScreen.main.bounds.width - 40,
                       height: 35)
                .background(userPhoneNumber.hasPrefix("+7") &&
                            userPhoneNumber.count == 16 ? .blue : .gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(userPhoneNumber.hasPrefix("+7") &&
                          userPhoneNumber.count != 16)
                .padding(.top, 40)
            }
            .onAppear {
                if userPhoneNumber.isEmpty {
                    focusedField = .phoneField
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        } else {
            VStack(alignment: .leading) {
                Text("Введите код из смс")
                    .font(.subheadline)
                
                TextField("******",
                          text: $userSMSCode)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .smsField)
                
                if userSMSCode.count != 6 ||
                    userSMSCode == viewModel.smsCode {
                    if !isPhoneNumberNoCorrect {
                        HStack(spacing: 3) {
                            Text("Повторный код можно получить через")
                            
                            Text("\(timeRemaining)")
                            
                            Text("cек.")
                        }
                        .onReceive(timer) { _ in
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Button("Отправить", action: {
                            viewModel.setupMobileUserAuth(phone: userPhoneNumber,
                                                          smsCode: userSMSCode)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                if UserDefaults.standard.mobileUserName != "" {
                                    viewModel.setupToken()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showHomeView = true
                                    }
                                } else {
                                    isPhoneNumberNoCorrect = true
                                }
                            }
                        })
                        .frame(width: UIScreen.main.bounds.width - 40,
                               height: 35)
                        .background(userSMSCode == viewModel.smsCode ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(userSMSCode != viewModel.smsCode)
                        .fullScreenCover(isPresented: $showHomeView) {
                            TabBarView(tabSelection: 3)
                        }
                        .padding(.top, 40)
                        .onAppear {
                            if userSMSCode.isEmpty {
                                focusedField = .smsField
                            }
                        }
                        
                        if timeRemaining == 0 {
                            Button("Отправить повторно", action: {
                                viewModel.setupSmsCode(phone: userPhoneNumber)
                                timeRemaining = 15
                            })
                            .frame(width: UIScreen.main.bounds.width - 40,
                                   height: 35)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 40)
                        }
                    } else if userSMSCode != viewModel.smsCode {
                        Text("Код не верный. Попробуйте снова.")
                            .font(.subheadline)
                            .foregroundColor(.red)
                        
                        Button("Отправить повторно", action: {
                            viewModel.setupSmsCode(phone: userPhoneNumber)
                        })
                        .frame(width: UIScreen.main.bounds.width - 40,
                               height: 35)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 40)
                    } else {
                        Text("Ни один из аккаунтов не привязан к этому номеру телефона.")
                            .frame(width: UIScreen.main.bounds.width - 40,
                                   height: 70)
                            .font(.subheadline)
                            .foregroundColor(.red)
                        
                        Button("Веруться назад", action: {
                            presentationMode.wrappedValue.dismiss()
                        })
                        .frame(width: UIScreen.main.bounds.width - 40)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        
        Spacer()
    }
}
