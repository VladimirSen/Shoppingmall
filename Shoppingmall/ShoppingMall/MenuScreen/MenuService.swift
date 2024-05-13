import Foundation
import Combine

final class MenuService {
    func pushPublisher(by data: [String: Any]) -> AnyPublisher<Result<SingleMobileDevice, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileDevicePath)/\(UserDefaults.standard.mobileDeviceId ?? "")/setting-push") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(SingleMobileDevice.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func appFeedbackPublisher(by data: [String: Any]) -> AnyPublisher<Result<Feedback, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.serverPath)/app-feedback") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                do {
                    let response = try JSONDecoder().decode(Feedback.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
    
    func logoutPubliser(by data: [String: Any]) -> AnyPublisher<Result<Void, ResponseError>, DataError> {
        guard let url = URL(string: "\(Constants.Path.mobileUserPath)/\(UserDefaults.standard.mobileUserId ?? "")/logout") else {
            return Fail(error: DataError.urlError).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.token, forHTTPHeaderField: "token")
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                if try JSONSerialization.jsonObject(with: data, options: []) is [Any] {
                    return .success(())
                } else {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    return .failure(errorResponse)
                }
            }
            .mapError { _ in DataError.dataError }
            .eraseToAnyPublisher()
    }
}
