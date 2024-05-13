import SwiftUI

struct GiftDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = BonusViewModel()
    @State var id: String
    @State var shop: String
    @State var name: String
    @State var logo: String
    @State var disclaimer: String
    @State var description: String
    @State var cost: Int
    @State var offerReceived: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        AsyncImage(url: URL(string: logo), 
                                   placeholder: {
                            ProgressView()
                        })
                        .cornerRadius(20)
                        .frame(width: UIScreen.main.bounds.width - 40, 
                               height: 250)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            
                            Button("", systemImage: "xmark", action: {
                                presentationMode.wrappedValue.dismiss()
                            })
                            .labelStyle(.iconOnly)
                            .foregroundColor(.black)
                        }
                        .frame(width: 40, height: 40)
                        .padding()
                    }
                    
                    Text(shop)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .padding(.vertical, 15)
                    
                    Text(name)
                        .font(.system(size: 20))
                        .foregroundColor(.primary)
                    
                    Text(disclaimer)
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.primary)
                        .padding(.vertical, 20)
                    
                    if viewModel.offerBuy == false {
                        if !offerReceived {
                            Button(action: {
                                offerReceived = true
                            }, label: {
                                HStack(spacing: 10) {
                                    HStack {
                                        Text("Приобрести за ")
                                        
                                        Text("\(cost)")
                                        
                                        Text(" баллов")
                                    }
                                    
                                    Image("diamond")
                                }
                            })
                            .frame(width: UIScreen.main.bounds.width - 40, 
                                   height: 35)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        } else {
                            HStack(spacing: 3) {
                                Text("С вашего балланса спишется ")
                                
                                Text("\(cost)")
                                
                                Text(" баллов")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 20)
                            
                            Button("Предложение получено") {
                                showAlert = true
                            }
                            .frame(width: UIScreen.main.bounds.width - 40, 
                                   height: 35)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
        }
        .popover(isPresented: $showAlert) {
            PointsDeductionView(offerId: id)
        }
    }
}
