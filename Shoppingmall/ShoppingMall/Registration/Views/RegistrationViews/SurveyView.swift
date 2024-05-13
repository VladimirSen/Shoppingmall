import SwiftUI

struct SurveyView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    @State private var surveyCompleted = false
    @State private var surveySkip = false
    @State private var date = Date()
    @State private var havingChildren: Children = .no
    @State private var showScoringEntryView = false
    private var isUserOver16: Bool {
        let currentDate = Date()
        let userCalendar = Calendar.current
        let userBirthDate = userCalendar.dateComponents([.year], from: date)
        let currentYear = userCalendar.component(.year, from: currentDate)
        if let year = userBirthDate.year {
            return (currentYear - year) > 16
        }
        return false
    }
    
    enum Children: String, CaseIterable, Identifiable {
        case yes, no
        var id: Self { self }
    }
    
    var body: some View {
        Text("Опрос")
            .font(.title2)
            .padding(.bottom, 40)
        
        VStack(alignment: .leading) {
            Text("1. Ваш День рождения")
                .font(.subheadline)
            
            DatePicker("ДД.ММ.ГГ",
                       selection: $date,
                       displayedComponents: [.date])
            .foregroundColor(.secondary)
            .padding(.bottom, 40)
            
            Text("2. Есть ли у Вас дети до 10 лет?")
                .font(.subheadline)
            
            Picker("", selection: $havingChildren) {
                Text("Да").tag(Children.yes)
                Text("Нет").tag(Children.no)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 40)
        
        if isUserOver16 {
            Button("Получить баллы", action: {
                if havingChildren == .yes {
                    viewModel.setupMobileUserSurvey(dateBirth: "\(date)", 
                                                    haveKids: true)
                } else {
                    viewModel.setupMobileUserSurvey(dateBirth: "\(date)", 
                                                    haveKids: false)
                }
                viewModel.setupSurveyChange()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    surveyCompleted = true
                }
            })
            .frame(width: UIScreen.main.bounds.width - 40, 
                   height: 35)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .fullScreenCover(isPresented: $surveyCompleted) {
                ScoringEntryView(isPromoCode: true, 
                                 isSurvey: true)
            }
            .padding(.top, 40)
        }
        
        Button("Пропустить опрос", action: {
            surveySkip = true
        })
        .fullScreenCover(isPresented: $surveySkip) {
            TabBarView(tabSelection: 1)
        }
        .padding(.top, 20)
        
        Spacer()
    }
}
