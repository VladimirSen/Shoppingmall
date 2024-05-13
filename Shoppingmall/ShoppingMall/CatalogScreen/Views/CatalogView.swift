import SwiftUI

struct CatalogView: View {
    private var columns: [GridItem] = [.init(.fixed(160)), .init(.fixed(160))]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Каталог")
                    .font(.title)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        NavigationLink(destination: CategoryView(category: "shops", 
                                                                 categoryName: "Магазины")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 152, height: 152)
                                        .cornerRadius(20)
                                        .foregroundColor(.purple)
                                    
                                    Text("Магазины")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                        NavigationLink(destination: CategoryView(category: "food", 
                                                                 categoryName: "Еда")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Image("food")
                                        .cornerRadius(20)
                                    
                                    Text("Еда")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                        NavigationLink(destination: CategoryView(category: "entertainment", 
                                                                 categoryName: "Развлечения")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Image("entertainments")
                                        .cornerRadius(20)
                                    
                                    Text("Развлечения")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                        NavigationLink(destination: CategoryView(category: "services", 
                                                                 categoryName: "Услуги")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Image("services")
                                        .cornerRadius(20)
                                    
                                    Text("Услуги")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                        NavigationLink(destination: CategoryView(category: "sport", 
                                                                 categoryName: "Фитнес")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Image("fitness")
                                        .cornerRadius(20)
                                    
                                    Text("Фитнес")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                        NavigationLink(destination: CategoryView(category: "cinema", 
                                                                 categoryName: "Кино")
                            .navigationBarBackButtonHidden()) {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 152, height: 152)
                                        .cornerRadius(20)
                                        .foregroundColor(.blue)
                                    
                                    Text("Кино")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
