import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State var tabSelection: Int

    var body: some View {
        ZStack {
            if networkMonitor.isConnected {
                TabView(selection: $tabSelection) {
                    HomeView()
                        .tabItem {
                            Label("Дом", image: "house")
                        }
                        .tag(1)
                    
                    CatalogView()
                        .tabItem {
                            Label("Каталог", image: "catalog")
                        }
                        .tag(2)
                    
                    BonusView()
                        .tabItem {
                            Label("Бонус", image: "bonus")
                        }
                        .tag(3)
                    
                    MenuView()
                        .tabItem {
                            Label("Меню", image: "menu")
                        }
                        .tag(4)
                }
            } else {
                NoNetworkView()
            }
        }
    }
}
