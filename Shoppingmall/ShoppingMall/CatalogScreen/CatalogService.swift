import Foundation
import Combine

final class CatalogScreenService: ObservableObject {
    private func categoryUrl(slug: String, start: Int, offset: Int, onMain: Bool) -> URL? {
        return URL(string: "\(Constants.Path.categoryPath)/\(slug)?start=\(start)&offset=\(offset)&on_home=\(onMain)")
    }
    
    func categoryPublisher(slug: String, start: Int, offset: Int, onMain: Bool) -> AnyPublisher<Result<[CategoryItem], ResponseError>, DataError> {
        guard let url = categoryUrl(slug: slug, start: start, offset: offset, onMain: onMain) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([CategoryItem].self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func shopUrl(shopId: String) -> URL? {
        return URL(string: "\(Constants.Path.shopsPath)/\(shopId)?mobileUserId=\(UserDefaults.standard.mobileUserId ?? "")")
    }

    func shopPublisher(shopId: String) -> AnyPublisher<Result<Shop, ResponseError>, DataError> {
        guard let url = shopUrl(shopId: shopId) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(Shop.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func shopPromotionsUrl(shopId: String) -> URL? {
        return URL(string: "\(Constants.Path.shopsPath)/\(shopId)/promotions)")
    }
    
    func shopPromotionsPublisher(shopId: String) -> AnyPublisher<Result<[Promotion], ResponseError>, DataError> {
        guard let url = shopPromotionsUrl(shopId: shopId) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([Promotion].self, from: data)
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
