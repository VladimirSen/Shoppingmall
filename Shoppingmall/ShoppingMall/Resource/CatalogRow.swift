import SwiftUI

struct CatalogRow<Destination>: View where Destination: View {
    private var image: String
    private var title: String
    private var destination: Destination
    @State private var isLocation = false
    
    init(image: String, 
         title: String,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.image = image
        self.title = title
        self.destination = destination()
    }
    
    var body: some View {
        NavigationLink(destination: {
            destination
        }, label: {
            HStack(spacing: 10) {
                AsyncImage(url: URL(string: image), 
                           placeholder: {
                    ProgressView()
                })
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .cornerRadius(3)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                
                Spacer()
            }
        })
    }
}
