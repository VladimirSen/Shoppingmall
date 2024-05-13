import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var news: [News] = []
    @Published var newsAndPromotions: [NewsAndPromotionListEntity] = []
    @Published var offers: [Offer] = []
    @Published var usefulInfo: [Services] = []
    @Published var events: [EventList] = []
    @Published var event: Event = Event(id: "", 
                                        title: "",
                                        logoUrl: "",
                                        content: "",
                                        date: DatePeriod(start: "", finish: ""),
                                        sitemap: "",
                                        cost: 0,
                                        eventPurchased: false)
    @Published var newsDetail: NewsDetail = NewsDetail(id: "", 
                                                       title: "",
                                                       logoUrl: "",
                                                       content: "",
                                                       publishDate: "",
                                                       sitemap: "")
    @Published var promotion: Promotion = Promotion(id: "", 
                                                    title: "",
                                                    logoUrl: "",
                                                    disclaimer: "",
                                                    startDate: "",
                                                    finishDate: "", 
                                                    content: "",
                                                    sitemap: "",
                                                    offerId: "")
    @Published var allNewsLoad = false
    @Published var allInfoLoad = false
    @Published var allEventsLoad = false
    @Published var allOffersLoad = false
    @Published var showLoading = false
    private var start = 0
    private var offset = 5
    private let service = HomeService()
    var cancellables = Set<AnyCancellable>()

    func setupNews() {
        showLoading = true
        service.newsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let news) = result {
                    self?.news = news
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupNewsAndPromotions() {
        showLoading = true
        service.newsAndPromotionsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let news) = result {
                    self?.newsAndPromotions = news
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupNewsDetail(id: String) {
        service.newsDetailPublisher(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let news) = result {
                    self?.newsDetail = news
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupPromotionDetail(id: String) {
        service.promotionDetailPublisher(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let promotion) = result {
                    self?.promotion = promotion
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupAllNews(resetData: Bool) {
        showLoading = true
        if resetData {
            news = []
            start = 0
        }
        service.allNewsPublisher(start: start, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let news) = result {
                    if news.count != self?.offset {
                        self?.allNewsLoad = true
                    }
                    self?.news.append(contentsOf: news)
                    self?.start += self?.offset ?? 0
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }

    func setupUsefulInfo() {
        showLoading = true
        service.servicesPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let info) = result {
                    self?.usefulInfo = info
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }

    func setupAllUsefulInfo(resetData: Bool) {
        showLoading = true
        if resetData {
            usefulInfo = []
            start = 0
        }
        service.allServicesPublisher(start: start, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let info) = result {
                    if info.count != self?.offset {
                        self?.allInfoLoad = true
                    }
                    self?.usefulInfo.append(contentsOf: info)
                    self?.start += self?.offset ?? 0
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupOffers() {
        showLoading = true
        service.offersPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let offers) = result {
                    self?.offers = offers
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupAllOffers(resetData: Bool) {
        showLoading = true
        if resetData {
            offers = []
            start = 0
        }
        service.allOffersPublisher(start: start, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let offers) = result {
                    if offers.count != self?.offset {
                        self?.allOffersLoad = true
                    }
                    self?.offers.append(contentsOf: offers)
                    self?.start += self?.offset ?? 0
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }

    func setupEvents() {
        showLoading = true
        service.eventsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let events) = result {
                    self?.events = events
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupEventDetail(id: String) {
        service.eventDetailPublisher(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let event) = result {
                    self?.event = event
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
    
    func setupAllEvents(resetData: Bool) {
        showLoading = true
        if resetData {
            events = []
            start = 0
        }
        service.allEventsPublisher(start: start, offset: offset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.showLoading = false
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "\(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] result in
                if case .success(let events) = result {
                    if events.count != self?.offset {
                        self?.allEventsLoad = true
                    }
                    self?.events.append(contentsOf: events)
                    self?.start += self?.offset ?? 0
                } else if case .failure(let errorResponse) = result {
                    AlertHelper.showAlert(withMessage: errorResponse.message ?? errorResponse.text ?? "")
                }
            })
            .store(in: &cancellables)
    }
}
