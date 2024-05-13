import Foundation
import Combine

final class BonusViewModel: ObservableObject {
    @Published var userOffers: [Offer] = []
    @Published var historyOperations: [ListTransaction] = []
    @Published var showLoading = false
    @Published var offerBuy = false
    private let service = BonusService()
    var cancellables = Set<AnyCancellable>()
    
    func setupUserOffers() {
        service.userOffersPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let offers) = result {
                    self?.userOffers = offers
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupBuyOffer(offerId: String) {
        service.buyOffersPublisher(offerId: offerId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let userData) = result {
                    self?.offerBuy = true
                    UserDefaults.standard.userBalance = (UserDefaults.standard.userBalance ?? 0) + (userData.changeBalance ?? 0)
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupHistoryOperations() {
        showLoading = true
        service.historyOperationsPublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                    self.showLoading = false
                }
            }, receiveValue: { [weak self] result in
                if case .success(let history) = result {
                    self?.historyOperations = history
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
}
