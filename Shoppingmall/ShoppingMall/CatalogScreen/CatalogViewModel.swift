import Foundation
import Combine

final class CatalogViewModel: ObservableObject {
    @Published var categoryItems: [CategoryItem] = []
    @Published var shop: Shop = Shop(id: "", 
                                     name: "",
                                     logoUrl: "",
                                     siteUrl: "",
                                     images: [],
                                     floor: 0,
                                     description: "",
                                     promotions: [],
                                     offers: [])
    @Published var promotions: [Promotion] = []
    @Published var showLoading = false
    private var start = 0
    private var offset = 100
    private let service = CatalogScreenService()
    var cancellables = Set<AnyCancellable>()
    
    func setupCategoryItems(slug: String) {
        showLoading = true
        service.categoryPublisher(slug: slug, 
                                  start: start,
                                  offset: offset,
                                  onMain: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let items) = result {
                    self?.categoryItems = items
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupShop(shopId: String) {
        showLoading = true
        service.shopPublisher(shopId: shopId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let shop) = result {
                    self?.shop = shop
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupShopPromotions(shopId: String) {
        showLoading = true
        service.shopPromotionsPublisher(shopId: shopId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = true
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let promotions) = result {
                    self?.promotions = promotions
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
}
