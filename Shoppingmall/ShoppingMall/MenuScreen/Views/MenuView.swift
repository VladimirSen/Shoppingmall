import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Меню")
                    .font(.title)
                    .padding(.leading, 20)
                    .padding(.vertical, 20)
                
                Text("О Shoppingmall")
                    .font(.title2)
                    .padding(.leading, 20)
                
                List {
                    Row(image: "news", 
                        title: "Новости и акции") {
                        NewsView()
                            .navigationBarBackButtonHidden()
                    }
                    
                    Row(image: "news", 
                        title: "Мероприятия") {
                        EventsView()
                            .navigationBarBackButtonHidden()
                    }
                    
                    Row(image: "question", 
                        title: "Как добраться") {
                        AddressView()
                            .navigationBarBackButtonHidden()
                    }
                    
                    Row(image: "settings", 
                        title: "Настройки") {
                        SettingsView()
                            .navigationBarBackButtonHidden()
                    }
                    
                    Row(image: "info", 
                        title: "О приложении") {
                        InfoAppView()
                        .navigationBarBackButtonHidden()
                    }
                }
                .listStyle(.plain)
                .padding(.trailing, 20)
                
                Spacer()
            }
        }
    }
}
