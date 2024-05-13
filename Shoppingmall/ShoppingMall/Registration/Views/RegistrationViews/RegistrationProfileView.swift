import SwiftUI

struct RegistrationProfileView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    @State private var userName: String = ""
    @State private var userSurname: String = ""
    @State private var userEmail: String = ""
    @State private var correctData: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        Text("Регистрация")
            .font(.title2)
            .padding(.bottom, 20)
        
        VStack(alignment: .leading) {
            Text("Имя")
                .font(.subheadline)
            
            TextField("Введите Ваше имя",
                      text: $userName)
            .textFieldStyle(.roundedBorder)
            .cornerRadius(10)
            .background(userName.isEmpty ? .red : .gray)
            .disableAutocorrection(true)
            
            Text("Фамилия")
                .font(.subheadline)
            
            TextField("Введите Вашу фамилию",
                      text: $userSurname)
            .textFieldStyle(.roundedBorder)
            .cornerRadius(10)
            .background(userSurname.isEmpty ? .red : .gray)
            .disableAutocorrection(true)
            
            Text("e-mail")
                .font(.subheadline)
            
            TextField("Введите Ваш e-mail",
                      text: $userEmail)
            .textFieldStyle(.roundedBorder)
            .cornerRadius(10)
            .background(userEmail.isEmpty ||
                        !isValidEmail(userEmail) ? .red : .gray)
            .focused($isFocused)
            .foregroundColor(isFocused &&
                             !isValidEmail(userEmail) ? .primary : .red)
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            
            if !isFocused &&
                !userEmail.isEmpty &&
                (!isValidEmail(userEmail) ||
                 userName.isEmpty ||
                 userSurname.isEmpty) {
                Text("Проверте правильность введенных данных")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .focused($isFocused)
            }
            
            Button("Сохранить") {
                viewModel.setupMobileUserName(name: userName + userSurname,
                                              email: userEmail)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    correctData = true
                }
                viewModel.setupAddRegister()
            }
            .frame(width: UIScreen.main.bounds.width - 40,
                   height: 35)
            .background(isValidEmail(userEmail) &&
                        !userName.isEmpty &&
                        !userSurname.isEmpty ? .blue : .gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isValidEmail(userEmail) ||
                      userName.isEmpty ||
                      userSurname.isEmpty)
            .fullScreenCover(isPresented: $correctData) {
                ScoringEntryView(bonus: UserDefaults.standard.userBalance ?? 0,
                                 isPromoCode: false,
                                 isSurvey: false)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .padding()
        
        Spacer()
    }
}
