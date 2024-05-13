import Foundation
import Combine

final class HomeService: ObservableObject {
    private func newsUrl() -> URL? {
        return URL(string: "\(Constants.Path.promitionsAndEventPath)?on_main=true")
    }
    
    func newsPublisher() -> AnyPublisher<Result<[News], ResponseError>, DataError> {
        guard let url = newsUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([News].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func allNewsUrl(start: Int, offset: Int) -> URL? {
        return URL(string: "\(Constants.Path.promitionsAndEventPath)?start=\(start)&offset=\(offset)")
    }
    
    func allNewsPublisher(start: Int, offset: Int) -> AnyPublisher<Result<[News], ResponseError>, DataError> {
        guard let url = allNewsUrl(start: start, offset: offset) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([News].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func newsDetailUrl(id: String) -> URL? {
        return URL(string: "\(Constants.Path.newsPath)/\(id)")
    }
    
    func newsDetailPublisher(id: String) -> AnyPublisher<Result<NewsDetail, ResponseError>, DataError> {
        guard let url = newsDetailUrl(id: id) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(NewsDetail.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func newsAndPromotionsUrl() -> URL? {
        return URL(string: "\(Constants.Path.newsPath)/with/promotions")
            
    }
    
    func newsAndPromotionsPublisher() -> AnyPublisher<Result<[NewsAndPromotionListEntity], ResponseError>, DataError> {
        guard let url = newsAndPromotionsUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([NewsAndPromotionListEntity].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func promotionDetailUrl(id: String) -> URL? {
        return URL(string: "\(Constants.Path.promotionPath)/\(id)")
    }
    
    func promotionDetailPublisher(id: String) -> AnyPublisher<Result<Promotion, ResponseError>, DataError> {
        guard let url = promotionDetailUrl(id: id) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(Promotion.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func offersUrl() -> URL? {
        return URL(string: "\(Constants.Path.offersPath)?on_home=true")
    }
    
    func offersPublisher() -> AnyPublisher<Result<[Offer], ResponseError>, DataError> {
        guard let url = offersUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([Offer].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func allOffersUrl(start: Int, offset: Int) -> URL? {
        return URL(string: "\(Constants.Path.offersPath)?start=\(start)&offset=\(offset)")
    }
    
    func allOffersPublisher(start: Int, offset: Int) -> AnyPublisher<Result<[Offer], ResponseError>, DataError> {
        guard let url = allOffersUrl(start: start, offset: offset) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([Offer].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func servicesUrl() -> URL? {
        return URL(string: "\(Constants.Path.servicesPath)?on_home=true")
    }
    func servicesPublisher() -> AnyPublisher<Result<[Services], ResponseError>, DataError> {
        guard let url = servicesUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([Services].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func allServicesUrl(start: Int, offset: Int) -> URL? {
        return URL(string: "\(Constants.Path.servicesPath)?start=\(start)&offset=\(offset)")
    }
    
    func allServicesPublisher(start: Int, offset: Int) -> AnyPublisher<Result<[Services], ResponseError>, DataError> {
        guard let url = allServicesUrl(start: start, offset: offset) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([Services].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func eventsUrl() -> URL? {
        return URL(string: "\(Constants.Path.eventsPath)?on_home=true")
    }
    
    func eventsPublisher() -> AnyPublisher<Result<[EventList], ResponseError>, DataError> {
        guard let url = eventsUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([EventList].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func allEventsUrl(start: Int, offset: Int) -> URL? {
        return URL(string: "\(Constants.Path.eventsPath)?start=\(start)&offset=\(offset)")
    }
    
    func allEventsPublisher(start: Int, offset: Int) -> AnyPublisher<Result<[EventList], ResponseError>, DataError> {
        guard let url = allEventsUrl(start: start, offset: offset) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([EventList].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func eventDetailUrl(id: String) -> URL? {
        return URL(string: "\(Constants.Path.eventsPath)/\(id)")
    }
    
    func eventDetailPublisher(id: String) -> AnyPublisher<Result<Event, ResponseError>, DataError> {
        guard let url = eventDetailUrl(id: id) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(Event.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
}
