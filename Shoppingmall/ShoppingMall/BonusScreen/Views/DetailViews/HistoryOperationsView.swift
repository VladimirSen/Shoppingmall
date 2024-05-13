import SwiftUI

struct HistoryOperationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = BonusViewModel()
    
    var body: some View {
        VStack {
            if viewModel.showLoading {
                LoadingView()
            } else {
                ZStack {
                    HStack {
                        BackButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 40, height: 40)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                    
                    Text("История транзакций")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(height: 40)
                
                if !viewModel.historyOperations.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(Array(Set(viewModel.historyOperations.map { $0.createdAt ?? "" })).sorted(by: >), id: \.self) { date in
                                Text(convertDateString(date))
                                    .font(.headline)
                                    .padding(.top, 10)
                                ForEach(viewModel.historyOperations.filter { $0.createdAt == date }, id: \.id) { value in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(value.typeTransaction ?? "")
                                            if value.typeObject == "Offer" {                                            Text(value.object?.name ?? "")
                                                    .font(.headline)
                                            }
                                            if value.typeObject == "event" {
                                                Text(value.object?.title ?? "")
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Text("\(value.changeBalance ?? 0)")
                                            
                                            Image("diamond")
                                        }
                                        .foregroundColor("\(value.changeBalance ?? 0)".hasPrefix("-") ? .red : .green)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 300, height: 80)
                            .foregroundColor(.red)
                            .cornerRadius(10)
                        
                        Text("Операций не совершалось")
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.setupHistoryOperations()
        }
    }
}
