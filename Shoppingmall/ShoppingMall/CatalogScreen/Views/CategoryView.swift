import SwiftUI

struct CategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = CatalogViewModel()
    @State var category = ""
    @State var categoryName = ""
    @State private var userText: String = ""
    
    private var shops: [CategoryItem] {
        if userText.isEmpty {
            return viewModel.categoryItems
        } else {
            return viewModel.categoryItems.filter {
                $0.name.lowercased().contains(userText.lowercased())
            }
        }
    }
    
    var body: some View {
        if viewModel.showLoading {
            LoadingView()
        }
        
        ZStack {
            HStack {
                BackButton {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 40, height: 40)
                
                Rectangle().foregroundColor(.clear)
            }
            Text(categoryName)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(height: 40)
        
        ScrollView {
            ZStack {
                Rectangle()
                    .frame(height: 30)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                
                HStack {
                    Image("search")
                    
                    TextField("Поиск", text: $userText)
                        .textFieldStyle(.plain)
                        .disableAutocorrection(true)
                }
                .padding(.leading, 15)
            }
            .cornerRadius(8)
            .padding(.vertical, 20)
            
            ForEach(shops, id: \.id) { shop in
                CatalogRow(image: shop.logoUrl, 
                           title: shop.name) {
                    CatalogItemsDetailView(id: shop.id, 
                                           image: shop.logoUrl,
                                           name: shop.name)
                        .navigationBarBackButtonHidden()
                }
            }
            
            if shops.isEmpty && !userText.isEmpty {
                Text("Упс...\n\n по Вашему запросу\nничего не найдено")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Image("categorypageEmpty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.setupCategoryItems(slug: category)
        }
        .refreshable {
            viewModel.setupCategoryItems(slug: category)
        }
    }
}
