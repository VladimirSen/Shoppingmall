import SwiftUI

struct InfoAppView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MenuViewModel()
    @State private var rating = 0
    @State private var feedback = ""
    @State private var isFeedback: Bool = false
    @State private var isSkillboxView = false
    @FocusState private var isFocused: Bool
    
    private var starsView: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(.title)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
    
    private var overLayView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: CGFloat(rating) / 5 * geometry.size.width)
            }
        }
        .allowsHitTesting(false)
    }
    
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
            
            if !isFeedback {
                Text("О приложении")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            } else {
                Text("Отзыв")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(height: 40)
        
        if !isFeedback {
            if UserDefaults.standard.appRating == 0 {
                Text("Оцените приложение")
                    .font(.title2)
                    .foregroundColor(.primary)
                
                ZStack {
                    starsView
                        .overlay(overLayView.mask(starsView)
                        )}
                .padding(.vertical, 20)
                
                Button("Оценить") {
                    viewModel.setupAppFeedback(text: "",
                                               rating: rating)
                    if rating < 5 {
                        isFeedback = true
                    } else {
                       isSkillboxView = true
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40, 
                       height: 35)
                .background(rating != 0 ? .blue : .gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(rating == 0)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Документация")
                    .padding(.horizontal, 20)
                
                List {
                    NavigationLink(destination: {
                        WebView(url: "https://skillbox.ru/terms_of_use.pdf")
                            .frame(width: UIScreen.main.bounds.width - 20, 
                                   height: UIScreen.main.bounds.height - 200)
                            .navigationTitle("Условия использования")
                            .padding(.horizontal, 20)
                    }, label: {
                        Text("Условия использования")
                    })
                    .frame(height: 40)
                    
                    NavigationLink(destination: {
                        WebView(url: "https://skillbox.ru/oferta.pdf")
                            .frame(width: UIScreen.main.bounds.width - 20, 
                                   height: UIScreen.main.bounds.height - 200)
                            .navigationTitle("Пользовательское соглашение")
                            .padding(.horizontal, 20)
                    }, label: {
                        Text("Пользовательское соглашение")
                    })
                    .frame(height: 40)
                }
                .listStyle(.plain)
                .padding(.leading, 5)
                .padding(.trailing, 20)
            }
            .padding(.top, 30)
            .popover(isPresented: $isSkillboxView) {
                VStack {
                    Image("5stars")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 40, 
                               height: 300)
                        .padding()
                    
                    Text("Спасибо за высокую оценку приложения!")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Мы старались для Вас.")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                }
            }
            
            Spacer()
        } else {
            VStack(alignment: .leading, spacing: 20) {
                Text("Данные обращения")
                    .font(.title2)
                    .foregroundColor(.primary)
                
                HStack(spacing: 20) {
                    Text("Аккаунт")
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 35)
                            .cornerRadius(8)
                            .opacity(0.1)
                        
                        Text(UserDefaults.standard.mobileUserPhoneNumber ?? "")
                    }
                }
                
                Text("Опишите Ваши замечания")
                
                TextField("Текст", text: $feedback)
                    .textFieldStyle(.roundedBorder)
                    .cornerRadius(10)
                    .focused($isFocused)
                    .submitLabel(.send)
                    .onSubmit {
                        viewModel.setupAppFeedback(text: feedback, 
                                                   rating: rating)
                        isFeedback = false
                        EmailController.shared.sendEmail(subject: "Отзыв о Shoppingmall", 
                                                         body: feedback,
                                                         to: "senkovv@icloud.com")
                    }
                
                Text("Мы рассматриваем все обращения и делаем приложение лучше для Вас.")
                    .font(.footnote)
                    .opacity(0.4)
                    .multilineTextAlignment(.leading)
            }
            .onAppear {
                isFocused = true
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}
