import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = RegistrationViewModel()
    @State private var userName: String = UserDefaults.standard.mobileUserName ?? ""
    @State private var userSurname: String = UserDefaults.standard.mobileUserSurname ?? ""
    @State private var userEmail: String = UserDefaults.standard.mobileUserEmail ?? ""
    @State private var phoneNumber: String = UserDefaults.standard.mobileUserPhoneNumber ?? "+7(XXX)-XXX-XX-XX"
    @State private var userSMSCode: String = ""
    @State private var isPhoneNumberEntered: Bool = false
    @State private var smsCodeNoCorrect: Bool = false
    @State private var timeRemaining = 15
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Профиль")
                .font(.title)
            
            if !isPhoneNumberEntered {
                Text("Имя")
                
                TextField("", text: $userName)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 30)
                
                Text("Фамилия")
                
                TextField("", text: $userSurname)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 30)
                
                Text("e-mail")
                
                TextField("", text: $userEmail)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 30)
                
                Text("Телефон")
                
                TextField("", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                    .keyboardType(.phonePad)
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 30)
            }
            
            if isPhoneNumberEntered {
                Text("Введите код из смс")
                    .font(.subheadline)
                
                TextField("******", text: $userSMSCode)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(5)
                    .keyboardType(.numberPad)
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 35)
                
                if userSMSCode != viewModel.smsCode && 
                    smsCodeNoCorrect ||
                    userSMSCode.count > 6 {
                    Text("Код не верный. Попробуйте снова.")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                
                if timeRemaining != 0 {
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
                }
                
                if timeRemaining == 0 && 
                    userSMSCode != viewModel.smsCode {
                    Button("Отправить повторно", action: {
                        viewModel.setupSmsCode(phone: phoneNumber)
                        timeRemaining = 15
                        userSMSCode = ""
                    })
                    .frame(width: UIScreen.main.bounds.width - 40, 
                           height: 35)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 40)
                }
            }
            
            Button("Сохранить") {
                if userName != "" && 
                    userSurname != "" && 
                    userEmail != "" &&
                    phoneNumber == UserDefaults.standard.mobileUserPhoneNumber {
                    viewModel.setupMobileUserName(name: userName + userSurname, 
                                                  email: userEmail)
                    presentationMode.wrappedValue.dismiss()
                } else if phoneNumber != UserDefaults.standard.mobileUserPhoneNumber &&
                            phoneNumber.hasPrefix("+7") && 
                            phoneNumber.count == 16 &&
                            !isPhoneNumberEntered {
                    viewModel.setupCheckPhone(phone: phoneNumber)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if viewModel.isPhoneNumberEntered {
                            isPhoneNumberEntered = true
                        }
                    }
                }
                
                if userSMSCode == viewModel.smsCode && 
                    !userSMSCode.isEmpty {
                    viewModel.setupChangePhone(phone: phoneNumber,
                                               smsCode: userSMSCode)
                    presentationMode.wrappedValue.dismiss()
                } else if !userSMSCode.isEmpty {
                    smsCodeNoCorrect = true
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, 
                   height: 35)
            .background(isValidEmail(userEmail) &&
                        !userName.isEmpty &&
                        !userSurname.isEmpty ? .blue : .gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(userName == "" || 
                      userSurname == "" ||
                      !isValidEmail(userEmail))
            .padding(.top, 10)
            
            Spacer()
        }
    }
}
