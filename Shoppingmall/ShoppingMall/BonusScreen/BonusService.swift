import Foundation
import Combine

final class BonusService: ObservableObject {
    private func userOffersUrl() -> URL? {
        return URL(string: "\(Constants.Path.mobileUserPath)/\(UserDefaults.standard.mobileUserId ?? "")/offers")
    }
    
    func userOffersPublisher() -> AnyPublisher<Result<[Offer], ResponseError>, DataError> {
        guard let url = userOffersUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserDefaults.standard.token, forHTTPHeaderField: "token")
        return URLSession.shared.dataTaskPublisher(for: request)
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
    
    private func buyOffersUrl(offerId: String) -> URL? {
        return URL(string: "\(Constants.Path.mobileUserPath)/\(UserDefaults.standard.mobileUserId ?? "")/offers/\(offerId)/attend")
    }
    
    func buyOffersPublisher(offerId: String) -> AnyPublisher<Result<ListTransaction, ResponseError>, DataError> {
        guard let url = buyOffersUrl(offerId: offerId) else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.token, forHTTPHeaderField: "token")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(ListTransaction.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    private func historyOperationsUrl() -> URL? {
        return URL(string: "\(Constants.Path.mobileUserPath)/\(UserDefaults.standard.mobileUserId ?? "")/transactions")
    }
    
    func historyOperationsPublisher() -> AnyPublisher<Result<[ListTransaction], ResponseError>, DataError> {
        guard let url = historyOperationsUrl() else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.token, forHTTPHeaderField: "token")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode([ListTransaction].self, from: data)
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
