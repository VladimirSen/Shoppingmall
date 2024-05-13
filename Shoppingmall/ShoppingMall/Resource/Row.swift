import SwiftUI

struct Row<Destination>: View where Destination: View {
    private var image: String
    private var title: LocalizedStringKey
    private var destination: Destination
    
    init(image: String, 
         title: LocalizedStringKey, 
         @ViewBuilder destination: @escaping () -> Destination) {
        self.image = image
        self.title = title
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: {
            destination
        }, label: {
            HStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text(title)
                    .font(.title3)
            }
        })
    }
}
